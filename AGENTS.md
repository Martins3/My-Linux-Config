# AGENTS.md - Dotfiles 协作指南

本仓库是个人开发环境配置的源头。处理 vim/nvim、shell、tmux、terminal、nix、输入法、字体、快捷键、剪贴板等环境问题时，优先在本仓库定位真实配置。

## 入口路径

- Neovim/Vim: `nvim/`，文档在 `docs/nvim*.md`
- Shell/Zsh: `config/zsh`
- 项目别名: `~/data/vn/code/zsh`
- Tmux: `config/tmux.conf`
- 终端: `config/wezterm.lua`、`config/alacritty.toml`、`config/ghostty/`、`config/kitty/`
- Prompt: `config/starship.toml`
- Nix: `docs/nix*.md`、`nixpkgs/`、`scripts/nix/`
- Rime/Fcitx: `rime/`，文档在 `docs/rime.md`
- 安装/链接脚本: `scripts/install.sh`

## 工作原则

1. 先用 `rg` 搜索相关工具名、报错信息、配置键或快捷键。
2. 修改配置源文件，而不是只修改生成后的目标文件。
3. 涉及 `~/.config`、`~/.tmux.conf`、`~/.zshrc` 等路径时，先检查是否由 `scripts/install.sh` 创建软链接。
4. 不要覆盖用户已有未提交修改；修改前先看 `git status --short`。
5. 配置变更后尽量用非交互命令验证，例如 `nvim --headless`、`zsh -n`、`tmux -f ... start-server`、`nix-instantiate --parse`。
6. 输出中不要使用 emoji。
