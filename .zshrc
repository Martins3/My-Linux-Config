# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
#

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# 

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  web-search
  last-working-dir
  extract
  zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh


source ~/.antigen.zsh

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

# 更加好看的ls
# antigen bundle supercrabtree/k
# Tell Antigen that you're done.
antigen apply
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias anzhuang="sudo apt install"
alias anzhuang="sudo pacman -S"
alias vpn="sslocal -c ~/Core/vpn.json"
# alias gj="shutdown --p now"
alias c="clear"
alias lanWifi="sudo create_ap wlp2s0 wlp2s0 wifiName 123456ab --hidden"
alias reboot="sudo shutdown -r now"
alias vim="nvim"
alias rjnet="cd ~/software/rjsupplicant && sudo ./rjsupplicant.sh -u U201514545 -p 075772 -d 1"
alias fuckRj="sudo service network-manager start"
alias reNet="sudo service network-manager restart"
alias setproxy='export http_proxy="socks5://127.0.0.1:1080" && export https_proxy="socks5://127.0.0.1:1080"'
alias q="exit"
alias t="~/.SpaceVim.d/translate/trans.sh"
alias cheat="~/.Application/cht.sh"
alias gotop="~/.Application/gotop"

# my added line hu bachelor 5.8 2017
source ~/.profile


#配置vte
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi


export CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java.jar
export PYTHONPATH=$PYTHONPATH:~/anaconda3/bin/python


# 配置nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 配置autojmp
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig 
export PKG_CONFIG_PATH

# 添加go的环境
export PATH=$PATH:/usr/local/go/bin

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



# 配置powerlevel9k
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
#POWERLEVEL9K_DISABLE_RPROMPT=true

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
