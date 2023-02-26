# startship
let-env STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = ""
let-env PROMPT_INDICATOR_VI_INSERT = ": "
let-env PROMPT_INDICATOR_VI_NORMAL = "〉"
let-env PROMPT_MULTILINE_INDICATOR = "::: "

source ~/.zoxide.nu

alias qm = /home/martins3/core/vn/docs/qemu/sh/alpine.sh -m
alias ge = ssh -p5556 root@localhost
alias get = ssh -t -p5556 root@localhost 'tmux attach || tmux'

alias b = tmuxp load -d /home/martins3/.dotfiles/config/tmux-session.yaml
alias c = clear
alias f = /home/martins3/core/vn/docs/kernel/flamegraph/flamegraph.sh
alias ck = systemctl --user start kernel
alias cq = systemctl --user start qemu
alias du = ncdu
alias flamegraph = /home/martins3/core/vn/docs/kernel/code/flamegraph.sh
alias git_ignore = echo \$(git status --porcelain | grep '^??' | cut -c4-) > .gitignore
alias gs = tig status
alias win = /home/martins3/core/vn/docs/qemu/sh/windows.sh
alias kernel_version = git describe --contains
# https://unix.stackexchange.com/questions/45120/given-a-git-commit-hash-how-to-find-out-which-kernel-release-contains-it
alias knews = /home/martins3/.dotfiles/scripts/systemd/news.sh kernel
alias ldc = lazydocker
alias ls = exa --icons
alias l = ls -lah
alias mc = make clean
alias q = exit
alias qnews = /home/martins3/.dotfiles/scripts/systemd/news.sh qemu
alias v = nvim
alias ag = rg
alias cp = xcp
alias kvm_stat = /home/martins3/core/linux/tools/kvm/kvm_stat/kvm_stat

alias gc = git commit
alias gp = git push

def m [ ] {
  let tmp = (getconf _NPROCESSORS_ONLN | into int) - 1
  make $"-j($tmp)"
}

def e [] {
    let table =           "| 单位    | 向左移动 | 向右移动 | 向左删除  | 向右删除 |\n"
    let table = $table +  "| 字符    | Ctrl + B | Ctrl + F | Ctrl + H  | Ctrl + D |\n"
    let table = $table +  "| 单词    | Alt + B  | Alt + F  | Ctrl + W  | Alt + D  |\n"
    let table = $table +  "| 行首/尾 | Ctrl + A | Ctrl + E | Ctrl + U  | Ctrl + K |"

    gum style --foreground 212 --border-foreground 212 --border double --align center --width 60 --margin "0 0 " --padding "0 0 " $table
}

def rpm_extract [rpm] {
  rpm2cpio $rpm | cpio -idmv
}

alias rk = /home/martins3/core/vn/docs/qemu/sh/alpine.sh

def alpine_clear_qemu [confirm=true] {
  try {
    let pid = (procs | grep qemu-system-x86_64 | grep alpine | awk '{print $1}' | into int)
    if ($confirm == true) {
      gum confirm "kill qemu" ; kill -9 $pid
    } else {
      kill -9 $pid
    }
  } catch {|e|
    print "no qemu process found"
    return
  }
}

def dk [] {
  alpine_clear_qemu

    screen -d -m bash -c "/home/martins3/core/vn/docs/qemu/sh/alpine.sh -s -r"
    /home/martins3/core/vn/docs/qemu/sh/alpine.sh -k
    alpine_clear_qemu false
}

def k [] {
  alpine_clear_qemu

    screen -d -m bash -c "/home/martins3/core/vn/docs/qemu/sh/alpine.sh -r"
    gum spin --spinner dot --title "waiting for the vm..." -- sleep 3
    ssh -p5556 root@localhost

  alpine_clear_qemu
}

let-env config = {
  cursor_shape: {
    emacs: block # block, underscore, line (line is the default)
  }
  # @todo 这两个有什么区别吗？
  edit_mode: emacs # emacs, vi
  show_banner: false # true or false to enable or disable the banner

  completions: {
    algorithm: "fuzzy"  # prefix or fuzzy
  }

  # @todo 无法理解为什么这样就可以让 direnv 工作了
  hooks: {
    pre_prompt: [{
      code: "
        let direnv = (direnv export json | from json)
        let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
        $direnv | load-env
      "
    }]
  }
}

source /home/martins3/core/zsh/nushell.nu

def t [
  function: string
  --return (-r): bool
] {
    if  ( $return == true ) {
        sudo bpftrace -e $"kretprobe:($function) { printf\(\"returned: %lx\\n\", retval\); }"
    } else {
        sudo bpftrace -e $"kprobe:($function) { @[kstack] = count\(\);}"
    }
}

