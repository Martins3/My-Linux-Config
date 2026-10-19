"""
1. `Ctrl-R` 和 `Tab` 来触发
2. 参考 https://github.com/plusls/gdb-fzf 实现
"""

import ctypes
import os
import shutil
import subprocess
import tempfile

import gdb


class _GdbFzfHistoryEntry(ctypes.Structure):
    _fields_ = [
        ("line", ctypes.c_char_p),
        ("timestamp", ctypes.c_char_p),
        ("data", ctypes.c_void_p),
    ]


class _GdbFzf:
    _callback_type = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, ctypes.c_int)

    def __init__(self):
        # Use GDB's actual readline, including Nix's version. Loading another
        # libreadline by filename can silently bind keys in the wrong library.
        self.rl = ctypes.CDLL(None)
        signatures = {
            "history_list": (ctypes.POINTER(ctypes.POINTER(_GdbFzfHistoryEntry)), []),
            "rl_bind_keyseq": (ctypes.c_int, [ctypes.c_char_p, self._callback_type]),
            "rl_begin_undo_group": (ctypes.c_int, []),
            "rl_end_undo_group": (ctypes.c_int, []),
            "rl_delete_text": (ctypes.c_int, [ctypes.c_int, ctypes.c_int]),
            "rl_insert_text": (ctypes.c_int, [ctypes.c_char_p]),
            "rl_crlf": (ctypes.c_int, []),
            "rl_forced_update_display": (ctypes.c_int, []),
        }
        for name, (result, arguments) in signatures.items():
            function = getattr(self.rl, name)
            function.restype = result
            function.argtypes = arguments
        self.buffer = ctypes.c_char_p.in_dll(self.rl, "rl_line_buffer")
        self.point = ctypes.c_int.in_dll(self.rl, "rl_point")
        self.end = ctypes.c_int.in_dll(self.rl, "rl_end")
        self.mark = ctypes.c_int.in_dll(self.rl, "rl_mark")
        # Readline keeps raw function pointers: retain these Python objects for
        # the entire GDB session, even if this file is sourced again.
        self.callbacks = (
            self._callback_type(lambda count, key: self.invoke(history=True)),
            self._callback_type(lambda count, key: self.invoke(history=False)),
        )

    def bind(self):
        for key, callback in zip((b"\\C-r", b"\\t"), self.callbacks):
            if self.rl.rl_bind_keyseq(key, callback) != 0:
                raise RuntimeError("could not bind readline key " + repr(key))

    def history(self):
        entries = self.rl.history_list()
        lines = []
        index = 0
        while entries and entries[index]:
            lines.append(entries[index].contents.line)
            index += 1
        return reversed(lines)

    def complete(self, prefix):
        # Complete the parent context so fzf can match partial words fuzzily.
        # Preserve whitespace: 'set print ' and 'set print' are different.
        context = prefix
        if context and context[-1:] not in (b" ", b"\t"):
            split = max(context.rfind(b" "), context.rfind(b"\t"))
            context = context[:split + 1]
        if any(character in prefix for character in (b"\n", b"\r", b"\0")):
            return []

        # gdb.execute strips trailing whitespace. A GDB pipe preserves it.
        # Use a delimiter absent from the input, so '|' in an expression or
        # filename never becomes a shell pipeline. Only our fixed cat command
        # goes to the shell; the anonymous temporary file closes on all paths.
        delimiter = "__GDB_FZF_PIPE__"
        while delimiter.encode() in context:
            delimiter += "_"
        with tempfile.TemporaryFile() as output:
            destination = f"/proc/{os.getpid()}/fd/{output.fileno()}"
            gdb.execute(
                f"pipe -d {delimiter} complete {os.fsdecode(context)}"
                f"{delimiter} cat > {destination}",
                to_string=True,
            )
            output.seek(0)
            return output.read().splitlines()

    @staticmethod
    def choose(query, candidates, *, history=False):
        # Deduplicate without stripping significant spaces or changing order.
        candidates = list(dict.fromkeys(line for line in candidates if line))
        if not candidates:
            return None
        executable = shutil.which("fzf")
        if executable is None:
            raise RuntimeError("fzf is not on PATH")
        environment = os.environ.copy()
        # User-wide shell bindings/preview/--print-query options can change
        # fzf's output protocol or execute actions unrelated to GDB.
        environment.pop("FZF_DEFAULT_OPTS", None)
        environment.pop("FZF_DEFAULT_OPTS_FILE", None)
        result = subprocess.run(
            [
                executable, "--read0", "--print0", "--no-multi",
                "--no-sort" if history else "--tiebreak=index",
                "--height=40%", "--layout=reverse", "--select-1", "--cycle",
                "--bind=tab:down,shift-tab:up", "--query", os.fsdecode(query),
            ],
            input=b"\0".join(candidates) + b"\0",
            stdout=subprocess.PIPE,
            env=environment,
            check=False,
        )
        if result.returncode in (1, 130):
            return None
        if result.returncode != 0:
            raise RuntimeError(f"fzf exited with status {result.returncode}")
        selection = result.stdout.removesuffix(b"\0")
        # Never insert query text, diagnostic output, or multiple selections.
        return selection if selection in candidates else None

    def replace(self, line, point):
        if line == (self.buffer.value or b""):
            return
        self.rl.rl_begin_undo_group()
        try:
            self.rl.rl_delete_text(0, self.end.value)
            self.point.value = 0
            self.rl.rl_insert_text(line)
            self.point.value = point
            self.mark.value = point
        finally:
            self.rl.rl_end_undo_group()

    def invoke(self, history):
        line = self.buffer.value or b""
        point = self.point.value
        try:
            query = line if history else line[:point]
            candidates = self.history() if history else self.complete(query)
            self.rl.rl_crlf()
            selection = self.choose(query, candidates, history=history)
            if selection is not None:
                suffix = b"" if history else line[point:]
                self.replace(selection + suffix, len(selection))
        except KeyboardInterrupt:
            pass
        except Exception as error:
            # Exceptions must not escape a ctypes callback into readline.
            gdb.write(f"\ngdb-fzf: {error}\n", gdb.STDERR)
        finally:
            self.rl.rl_forced_update_display()
        return 0


def _install_gdb_fzf():
    if getattr(gdb, "_dotfiles_fzf", None) is not None:
        return
    if shutil.which("fzf") is None:
        gdb.write("gdb-fzf: fzf is not on PATH; keeping native key bindings.\n")
        return
    try:
        plugin = _GdbFzf()
        # Retain callbacks before binding any key, including partial failure.
        gdb._dotfiles_fzf = plugin
        plugin.bind()
    except (AttributeError, OSError, RuntimeError, ValueError) as error:
        gdb.write(f"gdb-fzf: {error}\n", gdb.STDERR)


_install_gdb_fzf()
