# windows 环境搭建

2026-03-24 我发现，zellij 可以在 windows 中运行，那么最后一个问题也收敛了。

为什么?
1. 我必须用 windows

2. windows kernel vs linux kernel 的对比


3. 各种 ai 工具极大的降低了平台迁移的难度，我完全不会写 pwsh ，但是我依旧可以配置起来环境

Windows 开发环境的统一入口是 `scripts/windows-install.ps1`。它可以从 Windows
PowerShell 5.1 启动，并完成 PowerShell 7、Scoop 工具链、dotfiles 和应用配置部署。

## 全新系统部署

在 Windows PowerShell 5.1 中执行：

```powershell
$installer = Join-Path $env:TEMP "dotfiles-windows-install.ps1"
Invoke-RestMethod `
  -Uri "https://raw.githubusercontent.com/Martins3/My-Linux-Config/2026.9/scripts/windows-install.ps1" `
  -OutFile $installer
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $installer
```

如果 `~/.dotfiles` 尚不存在，脚本会在安装 Git 后克隆 `2026.9` 分支。已有仓库时可以直接运行：

```powershell
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass `
  -File "$HOME\.dotfiles\scripts\windows-install.ps1"
```

只重新部署配置，不检查软件包或同步 Neovim 插件：

```powershell
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass `
  -File "$HOME\.dotfiles\scripts\windows-install.ps1" `
  -SkipPackages -SkipNeovimSync
```

`config/windows/install.ps1` 是兼容入口，内部调用同一个安装脚本，不再维护另一份包清单。

## 部署内容

软件层：

- PowerShell 7：通过 `winget` 安装。
- Scoop：自动判断当前进程是否为管理员；管理员会使用 Scoop 的 `-RunAsAdmin`。
- Scoop buckets：`main`、`extras`、`nerd-fonts`。
- 编辑器和终端工具：Vim、Neovim、Neovide、Zellij、Starship、zoxide、lsd。
- Git 工具：Git、gitui、lazygit、git-aliases。
- 编译和语言工具：GCC、LLVM、Make、Go、Python、Node.js LTS、Yarn、LuaRocks、tree-sitter、uv。
- 常用命令：ripgrep、fd、fzf、yazi、wget、gdu、ntop、Sysinternals。
- 字体和运行库：Hack Nerd Font、FiraCode Nerd Font、VC++ 2022 runtime。

配置层：

- Neovim：`%LOCALAPPDATA%\nvim` junction 到 `~/.dotfiles/nvim`。
- gitui：`%APPDATA%\gitui` junction 到 `~/.dotfiles/config/gitui`。
- Zellij：`%APPDATA%\Zellij\config` junction 到 `~/.dotfiles/config/zellij`。
- PowerShell profile：`~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`。
- Windows Terminal、WezTerm、Starship 和 tig 配置。

目标已正确时脚本会跳过。覆盖现有文件或目录前会先备份到：

```text
C:\Users\<user>\dotfiles-backup-YYYYMMDD-HHMMSS
```

## 这次部署中遇到的问题

### Scoop 在管理员 SSH 会话中拒绝安装

OpenSSH 登录得到的是管理员高完整性令牌。Scoop 默认拒绝管理员安装，输出：

```text
Running the installer as administrator is disabled by default
```

安装脚本会检测管理员角色，并为 Scoop installer 添加 `-RunAsAdmin`。不再修改
CurrentUser execution policy；部署进程本身通过 `-ExecutionPolicy Bypass` 启动。

### extras bucket 缺失

`neovide`、`lazygit`、`sysinternals`、`git-aliases` 和 `vcredist2022` 位于
`extras` bucket。旧脚本只添加 `nerd-fonts`，所以会报告找不到 manifest。新脚本会在
安装 Git 后按需添加两个 bucket。

### PowerShell 7 不在 Program Files

当前 `winget` 的 PowerShell 包是 MSIX，实际可执行文件位于版本化的
`C:\Program Files\WindowsApps` 路径。Windows Terminal 配置不能再硬编码
`C:\Program Files\PowerShell\7\pwsh.exe`，应使用应用执行别名：

```json
"commandline": "pwsh.exe"
```

### SSH 登录后仍然进入 cmd.exe

修改 `HKLM\SOFTWARE\OpenSSH\DefaultShell` 在部分 Windows 11/OpenSSH 环境会被拒绝。
安装脚本不把这个系统级修改作为部署前提。SSH 登录后执行：

```cmd
pwsh
```

即可加载 `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`。

### Neovim 配置目录放错

Windows 上当前 Neovim 的 `stdpath("config")` 是：

```text
%LOCALAPPDATA%\nvim
```

旧脚本链接到 `%APPDATA%\nvim`，导致 Neovim 可以启动，但完全没有读取 dotfiles。部署脚本
现在只把有效配置链接到 `%LOCALAPPDATA%\nvim`。

可以验证：

```powershell
nvim --clean --headless `
  -c "lua print(vim.fn.stdpath('config'))" `
  -c qa
```

### Tree-sitter 尝试执行 cl.exe

当前 pinned `nvim-treesitter` 调用 `tree-sitter build` 编译 parser。Windows 默认生成
`cl.exe` 命令，但普通 Scoop 环境没有 Visual Studio Build Tools，因此报告：

```text
Error: program not found
```

只设置 `CC=clang` 也不够：Scoop LLVM 使用 MSVC target，但没有 Windows SDK/UCRT headers，
会继续报告 `stdlib.h` 或 `stdio.h` 不存在。

`nvim/lua/usr/nvim-treesitter.lua` 的 Windows 配置会在 GCC 可用时设置：

```lua
vim.env.CC = "gcc"
vim.env.CXX = "g++"
```

Scoop GCC 自带 MinGW headers，可以直接生成 Neovim 使用的 parser 动态库。重新安装单个
parser 可使用：

```vim
:TSInstall! scala
```

### Yarn 安装时找不到 node

Yarn 的 Scoop post-install 会调用 `node`。旧清单只安装 Yarn，新清单会先安装
`nodejs-lts`，再安装 Yarn。

### Profile 命令依赖不完整

PowerShell profile 会直接调用或导入 `starship`、`zoxide`、`zellij`、`gitui`、`lsd`
和 `git-aliases`。这些现在都是部署脚本的显式依赖，避免 profile 启动时逐项报错。

## 验证

```powershell
pwsh -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion'
pwsh -NoLogo -Command 'Get-Alias v; Get-Alias ls'
nvim --version
nvim --headless "+checkhealth vim.deprecated" "+qa"
git -C "$HOME\.dotfiles" status --short
```

PowerShell profile 正常时，`v` 指向 `nvim`，`ls` 指向 `lsd`。

## 日常环境设置

### 字体和终端复用

部署脚本会从 Scoop 的 `nerd-fonts` bucket 安装 Hack Nerd Font 和 FiraCode Nerd Font。
如果需要手工安装其他字体，可以从 [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
下载、解压后安装。

Windows Terminal 本身支持 pane，复杂的会话管理继续使用 Zellij。Visual Studio 中使用
VsVim，系统级键盘映射使用 PowerToys。微信占用 PowerToys 映射键时，可以将冲突的
`Fn22` 映射为 Disable。

### OpenSSH Server

管理员 PowerShell 中查看并安装 OpenSSH Server：

```powershell
Get-WindowsCapability -Online | Where-Object Name -Like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service sshd -StartupType Automatic
Start-Service sshd
```

域用户登录名可以先用 `whoami` 查看。用户名包含反斜杠时，从 Linux 登录需要引用完整的
`user@host` 参数，例如：

```bash
ssh 'martins3\97936@10.0.0.8'
```

### 桌面和键盘

- 窗口管理可尝试 [GlazeWM](https://github.com/glzr-io/glazewm)，配置目录是
  `~/.glzr/glazewm`；使用时建议关闭动画。
- 虚拟桌面快捷键可参考
  [windows-desktop-switcher](https://github.com/pmb6tz/windows-desktop-switcher)。
- 桌面计时器使用 [Catime](https://vladelaina.github.io/Catime/)。

将键盘重复延迟和速度调到常用值：

```powershell
$path = 'HKCU:\Control Panel\Keyboard'
Set-ItemProperty -Path $path -Name KeyboardDelay -Value '0'
Set-ItemProperty -Path $path -Name KeyboardSpeed -Value '31'
```

重新登录后设置会稳定生效。需要立即广播设置变化时，再调用 `SystemParametersInfo`。

### 常见环境问题

- `git sync` 明显慢于 `git pull` 时，先检查代理规则；曾遇到 Gitee 也被错误送入代理。
- Vim 或 Neovim 首次启动很慢时，先用无配置模式区分编辑器启动与插件安装/更新。
- Marksman 在 Windows 上可以运行，但交互曾有卡顿，仍需单独定位 LSP、文件监控或终端延迟。
- Python 的 uv 虚拟环境在 PowerShell 中通过 `.\.venv\Scripts\Activate.ps1` 激活。
- 查看 C 盘空间分布可运行 `gdu C:\`。
- 查看某个进程加载的模块：

```powershell
Get-Process nvim |
  Select-Object -ExpandProperty Modules |
  Select-Object ModuleName, FileName
```

### Windows 包管理工具

| 工具 | 主要用途 | 管理对象 |
| --- | --- | --- |
| `winget` | 系统应用安装器 | 桌面软件、CLI 工具、运行时 |
| `scoop` | 开发者命令行包管理器 | CLI 工具、portable app、开发工具 |
| `nuget` | .NET 包管理器 | C# / .NET 项目依赖 |
| `vcpkg` | C/C++ 库包管理器 | C/C++ 第三方库 |

`winget` 和 `scoop` 安装工具与应用；`nuget` 和 `vcpkg` 管理项目依赖。本仓库的部署脚本
以 `winget` 安装 PowerShell，以 Scoop 安装便携式开发工具。

## Windows 文件链接

Windows 支持 symbolic link，也支持目录 junction。创建 symbolic link 通常需要管理员权限
或开启 Developer Mode；junction 兼容性更好，创建目录链接时不要求相同的符号链接权限。
因此部署脚本使用 junction 管理 Neovim、gitui 和 Zellij 配置，并在替换已有目标前备份。

## 相关文档

- [Windows 驱动开发环境](./windows-driver.md)
- [PowerShell 常用命令](./windows-powershell.md)
- [Visual Studio 简记](./windows-visual-studio.md)
- [使用 Windows 作为开发机的背景](./windows-why.md)
- 从 vn 无损迁移的原始记录：[环境搭建](./windows-notes/setup-env.md)、
  [PowerShell](./windows-notes/pwsh.md)、[Visual Studio](./windows-notes/vs.md)、
  [使用背景](./windows-notes/why.md)
- [Neovim 配置](./nvim.md)
- [Windows 终端配置](./terminals.md)
