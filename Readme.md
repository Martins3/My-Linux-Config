# My Linux configuration
This repository is configuration for [`SpaceVim`](http://spacevim.org/)
[`on-my-zsh`](https://github.com/robbyrussell/oh-my-zsh)
[`autojump`](https://github.com/wting/autojump) 
[`translate-shell`](https://github.com/soimort/translate-shell)
and many other thing which can greatly imporve your life quality under linux.

[vim中文文档](./doc/vim-zh.md)

## Layout
There are three important item for vim configurations.
1. init.toml : you can change theme, import spacevim layers or plugins
2. plugin/coc.vim plugin/defx.vim : as it's suggests, configurations for coc.nvim and defx
3. autoload/myspacevim.vim : your additional configuration, you can remap keybinding

```
├── antigen.zsh
├── autoload
│   └── myspacevim.vim            **important**
├── gitconfig
├── init.toml                     **important**
├── install
│   └── install_manjaro.sh
├── plugin                        **important**
│   ├── coc.vim
│   └── defx.vim
├── Readme.md
├── spell
│   ├── en.utf-8.add
│   └── en.utf-8.add.spl
├── UltiSnips
│   ├── cpp.snippets
│   ├── c.snippets
│   ├── go.snippets
│   ├── javascript.snippets
│   ├── markdown.snippets
│   └── rust.snippets
└── zshrc
```

## How to Setup
1. install latest [neovim](https://github.com/neovim/neovim), stale version may cause some plugins work abnormally.
2. install [SpaceVim](https://spacevim.org/), after installing, there should be a dir named `.SpaceVim.d` in `~`, replace it's content will this repo's.
    * after the replacement, run `nvim`, plugins should be installed automatically, please make **every** plugin installed successfully.
3. run the [checkhealth](https://neovim.io/doc/user/pi_health.html) in neovim, get rid of errors and warnings.
4. install [ccls](https://github.com/MaskRay/ccls)

## More vim distributions
1. https://www.onivim.io/
2. https://github.com/hardcoreplayers/ThinkVim

## Troubleshooting
#### (zhs)[Warning: plugin zsh-autosuggestions not found](https://github.com/robbyrussell/oh-my-zsh/issues/7688)
