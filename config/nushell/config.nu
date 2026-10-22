# Windows interactive shell. Keep Nu's default prompt and editing keys.
# Use Nu itself: Scoop's launcher keeps its own original working directory.
$env.SHELL = $nu.current-exe
$env.PATH = ($env.PATH | prepend ($nu.home-dir | path join '.local' 'bin') | uniq)
$env.config.show_banner = false
$env.config.buffer_editor = 'nvim'
$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.config.shell_integration.osc7 = true

# Small, explicit Git shortcuts. No generated aliases or shell bridge.
alias g = ^git
alias ga = ^git add
alias gaa = ^git add --all
alias gb = ^git branch
alias gcb = ^git checkout -b
alias gco = ^git checkout
alias gc = ^git commit -v
alias gcmsg = ^git commit -m
alias gd = ^git diff
alias gdca = ^git diff --cached
alias gf = ^git fetch
alias gfa = ^git fetch --all --prune
alias gl = ^git pull
alias gm = ^git merge
alias gp = ^git push
alias gpf = ^git push --force-with-lease
alias gpr = ^git pull --rebase
alias gpra = ^git pull --rebase --autostash
alias grb = ^git rebase
alias grba = ^git rebase --abort
alias grbc = ^git rebase --continue
alias grv = ^git remote -v
alias gst = ^git status
alias gss = ^git status -s
alias gsw = ^git switch
alias gsta = ^git stash push
alias gstp = ^git stash pop
alias gstl = ^git stash list
def --env grt [] { cd (^git rev-parse --show-toplevel | str trim) }

def --wrapped s [...args: string] {
    ^python3 ($nu.home-dir | path join 'data' 'vn' 'smartx' 'ssh.py') ...$args
}
def gsy [] {
    ^git pull --rebase --autostash
    ^git commit -s -m 'double win'
    ^git push
}
def rmrf [...paths: glob] { rm --recursive --force ...$paths }
def q [] { exit }
alias gg = ^gitui --watcher
def --env tpx [] {
    $env.HTTP_PROXY = 'http://127.0.0.1:7897'
    $env.HTTPS_PROXY = 'http://127.0.0.1:7897'
}
def --env --wrapped co [...args: string] {
    tpx
    ^codex --approve-for-me ...$args
}
alias fedora = ^wsl --user martins3 -d FedoraLinux-42
alias ls = ^lsd
alias l = ^lsd -lah
alias c = clear
alias v = ^nvim
alias gs = ^gitui

# Rename the tab only when the directory changes, including the first prompt.
if ($env.ZELLIJ? | is-not-empty) {
    $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [] | append {|_, dir|
        let status = ($env.LAST_EXIT_CODE? | default 0)
        try { ^zellij action rename-tab ($dir | path basename | default --empty $dir) | ignore }
        $env.LAST_EXIT_CODE = $status
    })
}
