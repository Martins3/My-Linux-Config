# PowerShell 常用命令

## 系统信息

```powershell
# IPv4 地址
Get-NetIPAddress |
  Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike '*Loopback*' } |
  Select-Object InterfaceAlias, IPAddress, PrefixLength, AddressFamily

# PCI 和 USB 设备
Get-PnpDevice |
  Where-Object { $_.InstanceId -like 'PCI\*' } |
  Select-Object FriendlyName, InstanceId, Status
Get-PnpDevice -Class USB | Select-Object FriendlyName, InstanceId, Status

# 磁盘、物理磁盘和卷
Get-Disk | Select-Object Number, FriendlyName, Size, BusType, PartitionStyle, OperationalStatus
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, Size, BusType, HealthStatus
Get-Volume |
  Where-Object DriveLetter |
  Select-Object DriveLetter, FileSystemLabel, FileSystem, Size, SizeRemaining, DriveType

# 当前用户、GUID、开机时间和系统事件
whoami
[guid]::NewGuid().ToString()
(Get-CimInstance -Class Win32_OperatingSystem).LastBootUpTime
Get-WinEvent -LogName System

# 重启和打开当前目录
Restart-Computer
Invoke-Item .
```

`ii` 是 `Invoke-Item` 的别名。`Get-PSDrive -PSProvider FileSystem` 显示的 `Temp` 是映射到
`$env:TEMP` 的 PowerShell drive，不是独立分区，所以它与 C 盘显示相同的已用和可用空间。

## Windows PowerShell 5.1 与 PowerShell 7

先用 `$PSVersionTable` 确认当前版本：

| 环境 | 可执行文件 | Profile 目录 |
| --- | --- | --- |
| Windows PowerShell 5.1 | `powershell.exe` | `~/Documents/WindowsPowerShell` |
| PowerShell 7+ | `pwsh.exe` | `~/Documents/PowerShell` |

本仓库只部署 PowerShell 7 profile：

```text
C:\Users\<user>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

Windows Terminal 应使用 `pwsh.exe`，否则会进入 5.1 并读取另一份 profile。OpenSSH 默认
shell 仍是 `cmd.exe` 时，登录后手工执行 `pwsh`。

## Python 虚拟环境

uv 创建的虚拟环境在 PowerShell 中这样激活：

```powershell
.\.venv\Scripts\Activate.ps1
```

## Sysinternals 和诊断工具

- [Sysinternals](https://learn.microsoft.com/en-us/sysinternals/) 包含 Process Monitor、
  Process Explorer 等系统诊断工具；本仓库会通过 Scoop 安装它。
- [RWEverything](https://rweverything.com/) 用于底层硬件和寄存器观察，使用时需要谨慎。
- `netsh trace` 可以采集 Windows 网络诊断跟踪。
- [PowerShell](https://github.com/PowerShell/PowerShell) 本身是开源项目。

查看进程加载的动态库：

```powershell
Get-Process nvim |
  Select-Object -ExpandProperty Modules |
  Select-Object ModuleName, FileName
```

## 与 POSIX shell 的差异

`mkdir build && cd build` 是 POSIX shell 风格。PowerShell 7 支持部分熟悉的别名，但其对象
管道和命令语义并不等同于 Bash。新版本 Windows 也提供微软维护的
[Windows Coreutils](https://learn.microsoft.com/en-us/windows/core-utils/overview)。
