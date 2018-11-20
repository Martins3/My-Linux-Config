# My Linux configuration
This repository is configuration for [`SpaceVim`](http://spacevim.org/)
[`tilix`](https://gnunn1.github.io/tilix-web/)
[`on-my-zsh`](https://github.com/robbyrussell/oh-my-zsh)
[`autojump`](https://github.com/wting/autojump) 
[`translate-shell`](https://github.com/soimort/translate-shell)
and many other thing which can greatly imporve your life quality under linux.


## Set

### Deepin


### Manjaro
pacman makes things much more easy.

1. Xfce Power Manger
In `security` panel, `Automatically lock the session` : `Never`

2. Fix shadowsocks [ref](https://kionf.com/2016/12/15/errornote-ss/)
Read the error to find where is `openssl.py`.
Open `openssl.py`
Replace `cleanup` with `reset`
```
:%s/cleanup/reset/
:x
```
3. Config tilix
    1. In `Manjaro Setting manager` change default software.

