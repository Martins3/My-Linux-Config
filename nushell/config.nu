# https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu
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
# @todo 真的让人暴跳如雷，这种替换了，没有任何警告
# alias get = ssh -t -p5556 root@localhost 'tmux attach || tmux'

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
alias a = zsh
alias m2 = ssh martins3@10.0.0.2


alias find = /run/current-system/sw/bin/find

def m [ ] {
  let tmp = (getconf _NPROCESSORS_ONLN | into int) - 1
  make $"-j($tmp)"
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
    return
  }
}

def dk [] {
  alpine_clear_qemu

  # screen -d -m bash -c "/home/martins3/core/vn/docs/qemu/sh/alpine.sh -s -r -b"
  zellij run --close-on-exit -- /home/martins3/core/vn/docs/qemu/sh/alpine.sh -s
  /home/martins3/core/vn/docs/qemu/sh/alpine.sh -k
  alpine_clear_qemu false
}

def k [] {
  alpine_clear_qemu

    zellij run --close-on-exit -- "/home/martins3/core/vn/docs/qemu/sh/alpine.sh"
    ssh -o 'ConnectionAttempts 10' -p5556 root@localhost

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
    partial: false  # set this to false to prevent partial filling of the prompt
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

  menus: [
      {
        name: history_menu
        only_buffer_difference: true
        marker: "> "
        type: {
            layout: list
            page_size: 50
        }
        style: {
            text: yellow
            selected_text: green_reverse
            description_text: yellow
        }
      }
  ]

  # @todo 这个不是默认项目配置中的内容吗，为什么必须重新配置一次
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
  ]
}

source /home/martins3/core/zsh/nushell.nu

# @todo printf
# zat /boot/initramfs | cpio -idmv
# systemctl list-units
# Use docker ps to get the name of the existing container
# Use the command docker exec -it <container name> /bin/bash to get a bash shell in the container

def sheet_key [ ] {
  let notes = (open /home/martins3/.dotfiles/nushell/sheet.yaml)
  let notes = ($notes | transpose key note | get key | sort)
  $notes
}

def h [
  command : string@sheet_key
  ] {
      let notes = (open /home/martins3/.dotfiles/nushell/sheet.yaml)
      let notes = ($notes | transpose key note | where key == $command)
      echo $notes.note.0
  }

def he [ ] {
      # let SCOPE = (gum input --placeholder "sheet")
      # yq -i  e $".($command) += [ "($SCOPE)" ]" nushell/sheet.yaml
      nvim +10000  /home/martins3/.dotfiles/nushell/sheet.yaml
  }


def gscp [--show(-s), filename:string="."] {
  if $show {
    print `
function gscp() {
  file_name=$1
  if [ -z "$file_name" ]; then
    echo $0 file
    return 1
  fi
  ip_addr=$(ip a | grep -v vir | grep -o "192\..*" | cut -d/ -f1)
  file_path=$(readlink -f $file_name)
  echo scp -r $(whoami)@${ip_addr}:$file_path .
}
`
    return
  }
  # @todo 为什么要将 grep  "" 替换为 ``
  let ip_addr = (ip a | grep -v vir | grep -o `192\..*` | cut -d/ -f1)
  let file_path = (readlink -f $filename)
  echo $"scp -r (whoami)@($ip_addr):($file_path) ."
}

def defconfig [version:int=0] {
  cp /home/martins3/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config
  cp /home/martins3/.dotfiles/scripts/systemd/init.sh .
  echo "./init.sh"
}

def t [
  function: string
  --return (-r): bool
] {
    if  ( $return == true ) {
        # 这个将每一个都输出
        # sudo bpftrace -e $"kretprobe:($function) { printf\(\"returned: %lx\\n\", retval\); }"
        # 输出统计数值
        sudo bpftrace -e $"kretprobe:($function) { @process[comm] = stats\(retval\); }"
    } else {
        sudo bpftrace -e $"kprobe:($function) { @[kstack] = count\(\);}"
    }
}
