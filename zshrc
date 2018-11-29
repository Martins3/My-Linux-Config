source ~/.SpaceVim.d/.antigen.zsh

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
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell
# antigen theme bhilburn/powerlevel9k powerlevel9k

# antigen bundle supercrabtree/k
# Tell Antigen that you're done.
antigen apply



# alias anzhuang="sudo apt install"
alias anzhuang="sudo pacman -S"
alias vpn="sslocal -c ~/Core/vpn.json"
alias gj="shutdown --p now"
alias c="clear"
alias lanWifi="sudo create_ap wlp2s0 wlp2s0 wifiName 123456ab --hidden"
alias reboot="sudo shutdown -r now"
alias vim="nvim"
# alias rjnet="cd ~/software/rjsupplicant && sudo ./rjsupplicant.sh -u U201514545 -p 075772 -d 1"
# alias fuckRj="sudo service network-manager start"
# alias reNet="sudo service network-manager restart"
alias setproxy='export http_proxy="socks5://127.0.0.1:1080" && export https_proxy="socks5://127.0.0.1:1080"'
alias q="exit"
alias lg="lazygit"

# hackernews
alias hack="hn top"
alias hnv="hn view -b"

export PATH=$PATH:$HOME/.Application # Application contains the binary applications

# for device driver debug
# seems stupid, maybe we can use makefile instead
alias dg="dmesg | grep"
alias im="sudo insmod"
alias mm="sudo rmmod"

source ~/.profile

# vte
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi


export CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java.jar


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 配置autojmp
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

# manjaro install package
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig 
export PKG_CONFIG_PATH

# 添加go的环境
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin

# this will use vim as default editor 
export VISUAL=nvim
export EDITOR="$VISUAL"

# Rust 环境变量
export PATH=$PATH:~/.cargo/bin 
export FONTCONFIG_PATH=/etc/fonts

# os_tutorial lab need it these lines
# export PREFIX="/home/shen/Application/i386elfgcc"
# export TARGET=i386-elf
# export PATH="/home/shen/Application/i386elfgcc/bin:$PATH"


export PATH=~/anaconda3/bin:$PATH
export PATH=~/.gem/ruby/2.5.0/bin:$PATH

# 测试android repo 随时删除
# alias repo="python2 ~/Application/repo/repo"


# rm transform
# if you want clear trash, use the real *rm*
# /usr/bin/rm -rf ~/.trash/*
function rm() {
    # garbage collect
    now=$(date +%s)
    for s in $(ls --indicator-style=none $HOME/.trash/) ;do
        dir_name=${s//_/-}
        dir_time=$(date +%s -d $dir_name)
        # if big than one month then delete
        if [[ 0 -eq dir_time || $(($now - $dir_time)) -gt 2592000 ]] ;then
            echo "Trash " $dir_name " has Gone "
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


# http://zsh.sourceforge.net/Doc/Release/Command-Execution.html#Command-Execution
function command_not_found_handler(){
    review
}

# read 
function t(){
    review -w $1
    trans -sp :zh $1
}

# keep docs and pages from internet
# TODO: we need a project for this, but not now to finish it
function amdoc(){

}

function amsite(){
    echo $1 >> ~/Core/Vn/collection/AmazingSite.md
}
