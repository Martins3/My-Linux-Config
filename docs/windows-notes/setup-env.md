# windows 环境搭建

## 字体安装
安装字体:
https://www.nerdfonts.com/font-downloads
解压，右键，里面有安装

但是这个东西似乎安装了也没有效果啊:
```txt
https://github.com/tonsky/FiraCode/wiki/Installing
```

## 终端复用
之前尝试过 windows terminal tmux 类似的效果
- https://learn.microsoft.com/en-us/windows/terminal/panes

发现 zellij 已经可以用了，简直完美

## 一些技巧
- vsVim : Visual Studio 的 vim 模式
- PowerToys 来切换键盘的键位映射

## 打开 ssh 功能
- https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell&pivots=windows-11


Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
```txt
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service sshd -StartupType Automatic
Start-Service sshd
```

使用 powershell ，安装 server 似乎过程很慢

在 powershell 中可以用这个登录，这个用户名是通过 `WHOAMI` 获取的
```txt
ssh "martins3\97936@10.0.0.8"
```
但是在 linux 中需要添加双引号

## 构建 qemu
并不容易，也不原生，不知道那些 virt-manager 之类的工具都是如何解决的:
https://stackoverflow.com/questions/53084815/compile-qemu-under-windows-10-64-bit-for-windows-10-64-bit


## 已经解决的
### 为什么我的 git sync 很慢

观察到了一个非常奇怪的事情，就是在 windows 上使用 gsy 特别慢

无论是 windows 的 wsl / hyper-v manager 虚拟机中，还是物理机中

但是 git pull 很快?

哦，是代理有问题，导致走 gitee 也是走代理了

### 微信和 powertoys 的冲突问题
参考:
https://github.com/microsoft/PowerToys/issues/21877#issuecomment-1876571225

将 Fn22 映射为 Disable

### hyperv 虚拟机的网卡 ip
固定 mac 地址

如果不行，继续看看:
https://superuser.com/questions/1526309/hyper-v-default-switch-static-ip

最后结局办法是定义一个工具在 powershell 中的

## 还没解决的问题

### vim 首次 启动太慢了
如果遇到，那么在环境调试

### windows 桌面环境基本配置
https://github.com/glzr-io/glazewm

配置文件在:
C:\Users\97936\.glzr\glazewm

似乎还不错，需要将 animation 关闭掉

参考这个试试吧:
- https://superuser.com/questions/940342/how-to-change-shortcut-key-for-switching-between-virtual-desktops-in-windows-10
  - 参考这个答案 : https://superuser.com/a/1050690
    - 这个配置也是有 bug 的
- https://github.com/pmb6tz/windows-desktop-switcher

## 关闭动画
https://guanjia.qq.com/knowledge-base/content/1127?from=clinic

## 控制键盘速度
```powershell
$path = 'HKCU:\Control Panel\Keyboard'
Set-ItemProperty -Path $path -Name KeyboardDelay -Value '0'
Set-ItemProperty -Path $path -Name KeyboardSpeed -Value '31'

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class KeyboardNative {
  [DllImport("user32.dll", SetLastError=true)]
  public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);
}
'@

$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

[KeyboardNative]::SystemParametersInfo(0x0017, 0, [IntPtr]::Zero, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE) | Out-Null
[KeyboardNative]::SystemParametersInfo(0x000B, 31, [IntPtr]::Zero, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE) | Out-Null

Get-ItemProperty -Path $path | Select-Object KeyboardDelay, KeyboardSpeed, InitialKeyboardIndicators

更简单的复现版本也可以只执行：

Set-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name KeyboardDelay -Value '0'
Set-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name KeyboardSpeed -Value '31'
```

## 有趣的软件
- https://vladelaina.github.io/Catime/

## 参考
- https://github.com/jayharris/dotfiles-windows
- [I Fixed Windows Native Development](https://news.ycombinator.com/item?id=47022891)

## Windows 包管理工具

参考 codex 的，但是实话实话，我感觉一般
前三个都是会提供的

| 工具 | 主要用途 | 管理对象 | 常见场景 |
| --- | --- | --- | --- |
| `winget` | Windows 应用安装器 | 桌面软件、CLI 工具、运行时 | 安装 VS Code、Git、CMake、Visual Studio、7-Zip |
| `scoop` | 面向开发者的命令行包管理器 | CLI 工具、portable app、开发工具 | 安装 `ripgrep`、`fd`、`ninja`、`llvm` |
| `nuget` | .NET 包管理器 | C# / .NET 项目依赖 | 在 `.csproj` / `.sln` 中引用 .NET 库 |
| `vcpkg` | C/C++ 库包管理器 | C/C++ 第三方库 | 在 CMake / MSBuild 项目中引用 `fmt`、`boost`、`openssl` |

大致可以按层级区分：

- `winget` / `scoop` 用来安装工具和应用。
- `nuget` / `vcpkg` 用来管理项目代码依赖。

选择建议：

- 装系统级软件或 GUI 应用，优先看 `winget`。
- 装开发 CLI 工具，`scoop` 通常更轻量、目录更干净。
- 写 C# / .NET 项目，用 `nuget`。
- 写 C/C++ 项目，用 `vcpkg`。

