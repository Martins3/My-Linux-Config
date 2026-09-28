## Changelog

### 2022
本配置之前一直是基于 [spacevim](https://spacevim.org/) spacevim 的，移除的原因主要是因为:
- spacevim 的配置很多都是 vimscript 写的，我几乎看不懂，出现了问题无法快速独立解决
- spacevim 为了兼容 vim，一些插件的选择和我有冲突，比如包管理器(dein.vim -> packer.nvim) 和文件树(defx -> nvim-tree)

将 Fn 相关的快捷键全部去掉了:
- 需要移动手掌，不是很高效
- 有的键盘是没有 Fn 键的，按 Fn 键需要低效的组合键

### 2022.8
- 现在仓库的内容不只是 neovim 相关的，还有 nixos 以及其他的各种配置，现在将所有的 vim 配置都放到 nvim 目录下了。

### 2022.9
将 ccls 替换为 clangd，虽然我是 MaskRay 的忠实粉丝，但是:
  - ccls 最近更新的比较慢
  - clangd 无需额外的插件实现高亮

### 2023.2
将 clangd 换回来 ccls，将相关问题总结到 [2023 年对比一下 ccls 和 clangd](./docs/ccls-vs-clangd.md)。

### 2023.7
将 coc.nvim 切换为 native lsp 了。

### 2024.11
- 兼容 nvim 0.10 
- 将 terminal 替换为 toggleterm 了
- 将 anuvyklack/hydra.nvim 替换为 nvimtools/hydra.nvim ，前者已经不维护了，在 nvim 0.10 上有一个非常严重的 bug ，花了 2 天在找到。

### 2026.9

本次更新汇总 2026-06-15 至 2026-09-28 的配置变更。

#### Neovim

- 接入 rime.nvim，在编辑器内部使用 Rime，复用 Fcitx5 的词库与自定义短语；修复输入过程中暂时没有候选词时提前上屏的问题。
- 增加 fff 文件搜索与全文搜索，使用 `<leader>d` 和 `<leader>D` 调用，并通过 Cargo 构建 Neovim 插件所需的库。
- 移除 Hydra，用原生窗口调整模式实现 `ca` 后连续按 `h/j/k/l` 调整宽高。
- 使用 Snacks.bufdelete 清理已保存、隐藏且非终端的 buffer，同时清理参数列表，避免恢复会话时重新打开已关闭文件。
- 将 GDB backtrace 转换为缩进调用列表的逻辑改为 Lua 实现，移除对外部脚本和临时文件的依赖。
- 升级 rustaceanvim 至 v9，统一当前文件、项目与 Rust runnable 的运行入口；Python 格式化改用 Ruff，并按最近的项目标记选择根目录。
- 将 clangd 配置迁入 `after/lsp`，为缺少编译数据库条目的文件传入 Nix 编译参数，并扩展内核模块源码根目录识别。
- 修正 Windows 下 PowerShell 的启动参数，使用 MinGW GCC 构建 Tree-sitter parser，并增加 Windows C++ 示例运行入口。
- 使用 mini.hipatterns 替换颜色高亮插件，更新 nvim-tree 等插件 API，移除未使用的 Git 冲突插件和部分终端快捷键。
- Avante 默认改为 DeepSeek API，从本机配置文件读取密钥。

#### Windows

- 统一 Windows 安装入口，通过 PowerShell 7 和 Scoop 部署开发工具、字体与配置；支持跳过软件安装或 Neovim 插件同步。
- 部署前备份已有配置，使用 junction 连接配置目录，将 Neovim 配置放入 `%LOCALAPPDATA%`，并更新配置恢复脚本。
- 更新 PowerShell 的 SSH、代理和补全快捷键，按当前目录更新 Zellij 标签页名称；Windows Terminal 通过 `pwsh.exe` 启动 PowerShell。
- 增加 WDK、WinDbg 环境安装和驱动构建脚本，使用 64 位 MSBuild；补充 KMDF 示例、测试签名、驱动加载、调试和回滚文档。
- 扩充 Windows 部署、PowerShell、Visual Studio 与开发环境使用记录。

#### Rime

- 修正 Rime Ice 安装配方中的小鹤双拼方案名，使用 `double_pinyin_flypy`。
- 将个人固定词汇迁入 `custom_phrase_double.txt`，移除旧聚合词典及其引用，并补充安装、迁移和 Neovim 内部输入说明。

#### Nix 与 Linux 环境

- 将 Nix channel 升级至 26.05，调整字体和工具包名称，使用稳定源的 Neovim 与 Tailscale，移除 Multipass 配置及旧调试补丁。
- 内核开发环境优先使用与 `RUST_LIB_SRC` 匹配的 Nix Rust 编译器；QEMU 环境补充 dtrace 头文件依赖并清理重复依赖。
- 整理 Linux 配置链接安装逻辑，增加 htop 配置与限定 C++ 文件的 clangd C++20 默认参数，仅在图形目标启用时安装 Rime。

#### 终端与仓库维护

- Tmux 启用 CSI-u 扩展按键格式，移除旧 tmuxp 布局与辅助脚本，并补充会话、颜色和快捷键文档。
- Zellij 左右移动仅切换当前标签页内的 pane，布局目录改为相对路径，移除布局备份文件。
- 更新 GNOME 键盘与 Ghostty 使用说明，将 `readme.md` 更名为 `README.md` 并补充 Windows 文档入口。
- Markdown 提交检查仅处理 `docs/` 下的 Markdown 文件；lint 脚本接收文件参数、返回检查结果，不再自动修改文档。
