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

# Tell Antigen that you're done.
antigen apply


source ~/.profile

export PATH=$PATH:$HOME/.Application # Application contains the binary applications



# vte
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi


export CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java.jar


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autojmp
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



export PATH=~/anaconda3/bin:$PATH
export PATH=~/.gem/ruby/2.5.0/bin:$PATH


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


source ~/.SpaceVim.d/private/zshrc
