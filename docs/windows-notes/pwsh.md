# windows powershell 基本命令
<!-- 206880f9-8bf2-4cd3-b7c7-42f949f5df88 -->

```txt
# 获取 ip
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike "*Loopback*"} | Select-Object InterfaceAlias, IPAddress, PrefixLength, AddressFamily

# 枚举 pci
Get-PnpDevice | Where-Object {$_.InstanceId -like "PCI\*"} | Select-Object FriendlyName, InstanceId, Status

# 枚举 usb
Get-PnpDevice -Class USB | Select-Object FriendlyName, InstanceId, Status

# 磁盘
Get-Disk | Select-Object Number, FriendlyName, Size, BusType, PartitionStyle, OperationalStatus
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, Size, BusType, HealthStatus

# 磁盘容量
Get-Volume | Where-Object {$_.DriveLetter} | Select-Object DriveLetter, FileSystemLabel, FileSystem, Size, SizeRemaining, DriveType

# 重启
Restart-Computer

# 在 powershell 中打开文件浏览器
ii .
```

Get-PSDrive 中的 Temp 如何理解?
```txt
Get-PSDrive -PSProvider FileSystem

Name           Used (GB)     Free (GB) Provider      Root                                                                                             CurrentLocation
----           ---------     --------- --------      ----                                                                                             ---------------
C                 773.78        180.07 FileSystem    C:\                                                                                        Users\97936\data\case
Temp              773.78        180.07 FileSystem    C:\Users\97936\AppData\Local\Temp\
```
更加简单的是使用 duf

WHOAMI 来获取当前用户:

这个居然可以直接执行:
```ps1
[guid]::NewGuid().ToString()
```

获取开机时间:
```txt
(Get-CimInstance -Class Win32_OperatingSystem).LastBootUpTime
```
获取系统日志:
```txt
Get-WinEvent -LogName System
```

## 才发现是有两个 powershell 的版本的
$PSVersionTable

| 环境                   | 启动方式                               | 使用的配置文件路      |
| Windows PowerShell 5.1 | 搜索“PowerShell”或运行 powershell.exe, | ...\WindowsPowerShell |
| PowerShell 7+          | 搜索“PowerShell 7”或运行 pwsh.exe,     | ...\PowerShell        |

ssh 过去之后的 pwsh 脚本为:
```txt
C:\Users\97936\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

但是如果直接打开的之后，结果为:
```txt
C:\Users\97936\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

原来是 windows termianl 默认配置错误了

## Sysinternals 中到底包含什么工具
<!-- 6a7ec985-b4be-47a6-a737-9e79a3861df3 -->

https://learn.microsoft.com/en-us/sysinternals/downloads/file-and-disk-utilities

- perfmon
- procmon : 关联项目 ProcMon-for-Linux

## 看看
https://learn.microsoft.com/zh-cn/sysinternals/
https://github.com/ZoloZiak/WinNT4 : nt 的源码

## 逆天工具
https://rweverything.com/

## 其实 windows 真的就是什么都有，就是有点乱
https://learn.microsoft.com/zh-tw/windows/win32/ndf/using-netsh-to-manage-traces

## 原来如此

一些我发现只有 Linux 才有的，我以为所有机器都是如此的:

1. 这是 posix shell 的语法
```txt
mkdir build && cd build
```
2. rm mv cd 都是没有的

2026-06-09 : https://learn.microsoft.com/en-us/windows/core-utils/overview
