#!/usr/bin/env python3
import re
import subprocess
import os


def add_file_to_arr(file, arr):
    with open(file) as f:
        lines = f.readlines()
        lines = [line.rstrip() for line in lines]
        for l in lines:
            arr.append(l)


def repalce_include_with_file(working_dir, file):
    new_lines = []
    with open(file) as f:
        lines = f.readlines()
        lines = [line.rstrip() for line in lines]
        for l in lines:
            r1 = re.findall(r"#include \"(.*\.c)\"", l)
            r2 = re.findall(r"# include \"(.*\.c)\"", l)
            # kernel/rcu/tree.c 中最后的几个 .h 展开就是这个样子的
            r3 = re.findall(r"#include \"(tree_.*\.h)\"", l)

            source_files = None
            if r1:
                source_files = r1[0]
            if r2:
                source_files = r2[0]
            if r3:
                source_files = r3[0]

            if source_files:
                l = "// ============> " + l
                new_lines.append(l)
                add_file_to_arr(working_dir + source_files, new_lines)
            else:
                new_lines.append(l)

    return new_lines


def write_arr_to_file(file, lines):
    with open(file, "w") as f:
        for line in lines:
            f.write(f"{line}\n")


def revert(working_dir: str, file: str) -> str:
    file = working_dir + file
    lines = repalce_include_with_file(working_dir, file)
    write_arr_to_file(file, lines)
    return file


if __name__ == "__main__":
    os.chdir("/home/martins3/core/linux/")

    reverted_file: list[str] = []
    dir = "kernel/sched/"
    reverted_file.append(revert(dir, "build_policy.c"))
    reverted_file.append(revert(dir, "build_utility.c"))

    dir = "kernel/rcu/"
    reverted_file.append(revert(dir, "tree.c"))

    for file in reverted_file:
        subprocess.run(["git", "add", file])
