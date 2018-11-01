# My Linux configuration
This repository is configuration for [`SpaceVim`](http://spacevim.org/)
[`tilix`](https://gnunn1.github.io/tilix-web/)
[`on-my-zsh`](https://github.com/robbyrussell/oh-my-zsh)
[`autojump`](https://github.com/wting/autojump) 
[`translate-shell`](https://github.com/soimort/translate-shell)


## How to do use this repo
### Install  SpaceVim
Install SpaceVim is full of traps.
1. Install [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
> 1. `apt-get install neovim` will lead to a old version one, which would have wasted your hours to find out what's wrong with `SpaceVim`, the correct way is compile it
> 2. `git clone` may fail, I recommend `download zip` in your browser.
> 3.  install all the prerequisite before `make`.
> 4. `make` may fail, if that happened, type `make` in your console again until finishing it.
> 5. run `checkhealth` in neovim, fix all the error by installing following software
>   1. `pip install neovim`
>   2. `pip3 install neovim`
>   3. `gem install neovim` if gem not found, install it
>   4. install `nvm`
>   5. use `nvm` install `nodejs`
>   6. `sudo apt install xclip`

2. Install `SpaceVim`
3. Compile [`ycm`](https://github.com/Valloric/YouCompleteMe)
>  in command mode, type `help SpaceVim` and read the doc about ycm.


## clone this repo
```
mv .SpaceVim.bk .SpaceVim.d.bk
cd ~
git clone https://github.com/XiongGuiHui/My-Linux-config .SpaceVim
```

### zsh
1. install `zsh`
2. install `oh-my-zsh`
3. delete `.zshrc`
```
cd ~
mv .zshrc .zshrc.bk
```

4. install [`antigen`](https://github.com/zsh-users/antigen)
```
curl -L git.io/antigen > .antigen.zsh
```

5. modify the `.zshrc`
> there some config is related to absolute path, you should change to your specific path, eg, anaconda PATH

### tilix
```
sudo apt install tilix
```

### autojum
Too easy to mention.

### translate-shell


## Suggestion
1. if you are not familiar with `vim`, you'd better try `vim` in `vscode` at first.
