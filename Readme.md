# My Linux configuration
This repository is configuration for [`SpaceVim`](http://spacevim.org/)
[`tilix`](https://gnunn1.github.io/tilix-web/)
[`on-my-zsh`](https://github.com/robbyrussell/oh-my-zsh)
[`autojump`](https://github.com/wting/autojump) 
[`translate-shell`](https://github.com/soimort/translate-shell)
and many other thing which can greatly imporve your life quality under linux.

## Components
```
.
├── antigen.zsh
├── autoload
│   └── myspacevim.vim          # your own config, don't remove 
├── gitconfig                   # config for git, can be deleted savely
├── init.toml                   # main config of SpaceVim, critical
├── install                     # useless
│   └── install_manjaro.sh
├── plugin
│   └── coc.vim                 # config for coc.nvim, critical
├── Readme.md                   # this file
├── UltiSnips                   # for snippets, can be deleted savely
│   ├── cpp.snippets
│   ├── c.snippets
│   ├── go.snippets
│   ├── javascript.snippets
│   ├── markdown.snippets
│   └── rust.snippets
└── zshrc                       # for zsh , can be deleted savely
```
## How to Setup
1. install latest [neovim](https://github.com/neovim/neovim), stale version may cause some plugins work abnormally.
2. install [SpaceVim](https://spacevim.org/), after installing, there should be a dir named `.SpaceVim.d` in `~`, replace it's content will this repo's.
    * after the replacement, run `nvim`, plugins should be installed automatically, please make **every** plugin installed successfully.
3. run the [checkhealth](https://neovim.io/doc/user/pi_health.html) in neovim, get rid of errors and warnings.
4. install [ccls](https://github.com/MaskRay/ccls)

## Troubleshooting
#### (zhs)[Warning: plugin zsh-autosuggestions not found](https://github.com/robbyrussell/oh-my-zsh/issues/7688)
