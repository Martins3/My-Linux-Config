source ~/.SpaceVim.d/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
# antigen bundle soimort/translate-shell # seems can not installed properly in this way.

# Syntax highlighting bundle.
# antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply


source ~/.profile

export PATH=$PATH:$HOME/.Application # Application contains the binary applications
export PATH=$PATH:$HOME/.Application/bin

# vte
# if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        # source /etc/profile.d/vte.sh
# fi


export CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java.jar


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autojmp
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

# manjaro install package
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig 
export PKG_CONFIG_PATH

# 添加go的环境(with a better way)
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# export PATH=$PATH:/usr/local/go/bin
# export PATH=$PATH:~/go/bin


# this will use vim as default editor 
export VISUAL=nvim
export EDITOR="$VISUAL"

# Rust 环境变量
export PATH=$PATH:~/.cargo/bin 
export FONTCONFIG_PATH=/etc/fonts

# conda leads to some problem
# if you need conda, just uncomment it
# added by Anaconda3 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$(CONDA_REPORT_ERRORS=false '/home/shen/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
# if [ $? -eq 0 ]; then
    # \eval "$__conda_setup"
# else
    # if [ -f "/home/shen/anaconda3/etc/profile.d/conda.sh" ]; then
        # . "/home/shen/anaconda3/etc/profile.d/conda.sh"
        # CONDA_CHANGEPS1=false conda activate base
    # else
        # \export PATH="/home/shen/anaconda3/bin:$PATH"
    # fi
# fi
# unset __conda_setup
# <<< conda init <<<


export PATH=~/.gem/ruby/2.6.0/bin:$PATH



alias anzhuang="sudo pacman -S"
alias gj="shutdown --p now"
alias vpn="sslocal -c ~/Core/vpn.json"
alias c="clear"
alias lanWifi="sudo create_ap wlp2s0 wlp2s0 wifiName 123456ab --hidden"
alias reboot="shutdown -r now"
alias vim="nvim"
alias setproxy='export http_proxy="socks5://127.0.0.1:1080" && export https_proxy="socks5://127.0.0.1:1080"'
alias q="exit"
alias lg="lazygit"

# this line make terminal edition act alike vim, but it ruin some feature.
# set -o vi
: <<'END'
function rm() {
    # garbage collect
    now=$(date +%s)
    for s in $(/bin/ls --indicator-style=none $HOME/.trash/) ;do
        dir_name=${s//_/-}
        dir_time=$(date +%s -d $dir_name)
        # if big than one month then delete
        if [[ 0 -eq dir_time || $(($now - $dir_time)) -gt 2592000 ]] ;then
            # echo "Trash " $dir_name " has Gone "
            /bin/rm $s -rf
        fi
    done
    
    # add new folder
    prefix=$(date +%Y_%m_%d)
    hour=$(date +%H)
    mkdir -p $HOME/.trash/$prefix/$hour
    if [[ -z $1 ]] ;then
            echo 'Missing Args'
        return
    fi
    echo "Hi, Trashing" $1 "to /root/.trash"
    mv $1 $HOME/.trash/$prefix/$hour
}
END


# read 
function t(){
    trans -sp :zh $1
    review -w $1
}

# http://zsh.sourceforge.net/Doc/Release/Command-Execution.html#Command-Execution
function command_not_found_handler(){
  echo 'command not found: cmd'
  review
  return 127
}

function make_swap() {
  sudo fallocate -l 8G swapfile
  sudo chmod 600 swapfile
  sudo mkswap swapfile
  sudo swapon swapfile
}

alias s="sharp"
# alias ls="exa"

alias ls='lsd'
alias l='ls -la'
alias lt='ls --tree'

alias glog="git log --graph --decorate --oneline --all"

alias du='ncdu'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# https://github.com/starship/starship
# eval "$(starship init zsh)"
