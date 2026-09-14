# Windows 驱动开发环境

## 安装

统一安装入口：

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass `
  -File "$HOME\.dotfiles\scripts\windows-driver-setup.ps1"
```

全新 Windows 只有 Windows PowerShell 和 WinGet 时，先安装脚本依赖，再重新打开终端：

```powershell
winget install --id Microsoft.PowerShell --exact `
  --accept-package-agreements --accept-source-agreements
winget install --id Git.Git --exact `
  --accept-package-agreements --accept-source-agreements
```

不使用 dotfiles 脚本时，等价的官方 WDK 环境下载入口是：

```powershell
$configurationUri = 'https://raw.githubusercontent.com/microsoft/Windows-driver-samples/main/_wdk_utils/winget/configs/wdk-vscommunity.dsc.yaml'

# 只在 WinGet Configuration 尚未启用时执行一次。
winget configure --enable

winget configure -f $configurationUri `
  --accept-configuration-agreements `
  --disable-interactivity

winget install --id Microsoft.WinDbg --exact `
  --accept-package-agreements `
  --accept-source-agreements

New-Item -ItemType Directory -Force -Path "$HOME\data" | Out-Null
git clone --depth 1 `
  https://github.com/microsoft/Windows-driver-samples.git `
  "$HOME\data\Windows-driver-samples"
```

官方 WinGet 配置会跟随 Microsoft 更新。安装完成后，应记录实际 SDK、WDK 和 Visual Studio
版本，不要只依赖文档中的历史版本号。

脚本使用 Microsoft `Windows-driver-samples` 仓库提供的官方 WinGet 配置，安装：

- Visual Studio 2026 Community；
- Desktop development with C++、MSBuild、Spectre 和 DriverKit 组件；
- Windows SDK 28000；
- Windows WDK 28000；
- WinDbg；
- `~/data/Windows-driver-samples`。

官方说明：

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install-the-wdk-using-winget>
- <https://learn.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk>

SDK 和 WDK 的 build number 必须一致，QFE 可以不同。当前环境是 SDK
`10.0.28000.2114` 和 WDK `10.1.28000.2526`，共同使用 `10.0.28000.0` 工具目录。

## 构建 KMDF Echo 示例

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass `
  -File "$HOME\.dotfiles\scripts\windows-driver-build.ps1"
```

默认构建：

```text
~/data/Windows-driver-samples/general/echo/kmdf/kmdfecho.sln
Debug | x64 | Rebuild
```

输出包括：

- `driver/AutoSync/x64/Debug/echo.sys`；
- `driver/AutoSync/x64/Debug/echo/echo.inf`；
- `driver/AutoSync/x64/Debug/echo/kmdfsamples.cat`；
- `driver/DriverSync/x64/Debug/echo_2.sys`；
- `exe/x64/Debug/echoapp.exe`。

构建过程完成 INF verification、API validation、catalog generation 和测试签名。

## WDK 28000 必须使用 64 位 MSBuild

不要使用 `vswhere -find 'MSBuild\**\Bin\MSBuild.exe'` 返回的第一个结果，它通常是 32 位：

```text
MSBuild\Current\Bin\MSBuild.exe
```

WDK 28000 已没有完整的 x86 内核驱动验证链。32 位 MSBuild 会出现：

```text
INF verification exception: 无法加载 DLL“x86\InfVerif.dll”
ApiValidation: aitstatic is returned exit code 193
```

必须显式使用：

```text
MSBuild\Current\Bin\amd64\MSBuild.exe
```

构建脚本不会回退到 32 位 MSBuild。

## INF verification 1199

使用 Driver Store `DIRID 13` 时，INF 必须把 DDInstall section 限制到 Windows 10
build 16299 或更高。下面的 decoration 仍然过宽：

```ini
%ManufacturerName%=Standard,NTamd64.10.0
```

WDK 会报告：

```text
error 1199: The syntax 'DIRID 13 (CopyFiles)' was introduced in OS version 10.0.16299
```

应写成：

```ini
%ManufacturerName%=Standard,NTamd64.10.0...16299

[Standard.NTamd64.10.0...16299]
```

## WDK 28000 工具位置

常用路径：

```text
C:\Program Files (x86)\Windows Kits\10\bin\10.0.28000.0\x64\signtool.exe
C:\Program Files (x86)\Windows Kits\10\bin\10.0.28000.0\x64\stampinf.exe
C:\Program Files (x86)\Windows Kits\10\bin\10.0.28000.0\x86\Inf2Cat.exe
C:\Program Files (x86)\Windows Kits\10\Tools\10.0.28000.0\x64\infverif.exe
C:\Program Files (x86)\Windows Kits\10\build\10.0.28000.0\WindowsDriver.Common.targets
```

`Inf2Cat.exe` 虽然位于 `x86` 目录，但二进制本身是 x64。不要根据目录名猜测 PE 架构。

## 加载和调试边界

编译和测试签名可以在开发机完成。驱动加载、`TESTSIGNING`、Driver Verifier 和内核调试应放在
可回滚快照的独立测试 VM 中；不要直接在日常使用的 Windows 开发机加载示例内核驱动。

MSBuild 会创建 `WDKTestCert` 并签署 SYS/CAT，但开发机没有信任这个自签名根证书。因此
`SignTool verify /kp` 能显示签名链，同时返回 `root certificate which is not trusted`。这是当前
安全边界的预期结果；不要为了让验证命令变绿而把测试证书加入日常系统的 Trusted Root。

下一步是准备独立 target VM，通过 WinDbg 进行 host/target 内核调试：

当前 Windows 开发机本身是 QEMU `Standard PC (Q35 + ICH9, 2009)` guest，并且
`HypervisorPresent=True`。不要默认依赖 guest 内再运行 Hyper-V；优先从外层虚拟化环境创建
第二台 Windows target VM。

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/setting-up-kernel-mode-debugging-over-a-network-cable-manually>

## 将 KmdfHello 安装到测试 VM

目前完成的是“构建并由 WDK 测试签名”，不是“驱动已安装”。测试签名的内核驱动还需要目标机
信任测试证书、启用 `TESTSIGNING`、重启并创建匹配 INF hardware ID 的设备实例。它们会改变
系统信任、启动配置和内核状态，所以只应在有控制台和可回滚快照的测试 VM 中执行。

推荐顺序：

```text
构建 -> 创建 VM 快照 -> 导出并复制证书和驱动包 -> 信任证书
     -> 启用 TESTSIGNING -> 重启 -> 连接 WinDbg -> 创建设备并安装
     -> 验证 -> 删除设备和驱动包，或恢复快照
```

如果当前 QEMU Windows guest 已经是一次性测试 VM，并且能从外层创建快照和访问控制台，也可以
把它直接作为 target；不必为了形式再嵌套一台 VM。

### 1. 构建驱动和 DevCon

在 build machine 上构建 `KmdfHello`：

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass `
  -File "$HOME\.dotfiles\scripts\windows-driver-build.ps1" `
  -Solution "$HOME\data\kmdf-hello\kmdf-hello.vcxproj"
```

驱动包目录是：

```text
C:\Users\97936\data\kmdf-hello\build\x64\Debug\kmdf-hello
```

其中必须同时存在 `KmdfHello.sys`、`kmdf-hello.inf` 和 `KmdfHello.cat`。不要只复制 SYS。

当前 WDK 28000 没有预装 `devcon.exe`，需要从已经下载的官方 samples 构建：

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass `
  -File "$HOME\.dotfiles\scripts\windows-driver-build.ps1" `
  -Solution "$HOME\data\Windows-driver-samples\setup\devcon\devcon.vcxproj" `
  -Configuration Debug `
  -Platform x64

$devcon = Get-ChildItem `
  "$HOME\data\Windows-driver-samples\setup\devcon" `
  -Filter devcon.exe -Recurse |
  Where-Object FullName -Match '\\x64\\' |
  Sort-Object FullName -Descending |
  Select-Object -First 1

if (-not $devcon) {
  throw 'x64 devcon.exe was not found after the build'
}

$devcon.FullName
```

已验证的输出路径是
`C:\Users\97936\data\Windows-driver-samples\setup\devcon\x64\Debug\devcon.exe`。

Microsoft 通常建议使用 PnPUtil 管理驱动包。不过 `pnputil /add-driver` 不会凭空创建这里所需的
root-enumerated devnode；`devcon install` 会同时创建根设备并安装匹配的驱动，因此本例需要
DevCon。后续删除 Driver Store 中的包仍使用 PnPUtil。

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/devcon>
- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/using-the-devcon-tool-to-install-a-driver-package>
- <https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil-command-syntax>

### 2. 导出 WDKTestCert 并复制完整测试包

在 build machine 上从 catalog 签名中动态取得证书，不要把某一次构建生成的 thumbprint
硬编码到脚本：

```powershell
$package = "$HOME\data\kmdf-hello\build\x64\Debug\kmdf-hello"
$catalog = Join-Path $package 'KmdfHello.cat'
$certificatePath = Join-Path $package 'WDKTestCert.cer'
$signature = Get-AuthenticodeSignature -FilePath $catalog

if (-not $signature.SignerCertificate) {
  throw "No signer certificate was found in $catalog"
}

Export-Certificate `
  -Cert $signature.SignerCertificate `
  -FilePath $certificatePath `
  -Force

$signature.SignerCertificate |
  Format-List Subject, Thumbprint, NotBefore, NotAfter
```

把整个 `$package` 目录复制到 target，例如 `C:\driver-test\kmdf-hello`。如果 WinDbg 运行在
另一台机器上，还要把 build 输出中的 `KmdfHello.pdb` 复制到 debugger host 的私有符号目录。

### 3. 修改 target 前的检查

下面开始的命令都必须在 target 的管理员 PowerShell 中执行。执行前先：

- 在外层 QEMU/libvirt 管理端创建并确认可恢复的 VM 快照；
- 确认即使网络或 SSH 失效，仍可使用图形或串口控制台；
- 如果系统盘启用了 BitLocker，先保存 recovery key，并按环境策略处理下一次重启的保护；
- 检查 Secure Boot。Secure Boot policy 可能拒绝修改 `TESTSIGNING`，不要绕过生产机策略。

只读检查：

```powershell
Confirm-SecureBootUEFI
Get-BitLockerVolume -MountPoint 'C:'
bcdedit /enum '{current}'
```

`Confirm-SecureBootUEFI` 在传统 BIOS 环境可能报告不支持；这不等于检查失败。若 BCDEdit 返回
`The value is protected by Secure Boot policy`，应回到 VM 固件设置处理 Secure Boot，而不是继续
尝试安装。

### 4. 在 target 信任测试证书

```powershell
$package = 'C:\driver-test\kmdf-hello'
$certificatePath = Join-Path $package 'WDKTestCert.cer'
$certificate = Get-PfxCertificate -FilePath $certificatePath
$thumbprint = $certificate.Thumbprint

Import-Certificate `
  -FilePath $certificatePath `
  -CertStoreLocation 'Cert:\LocalMachine\Root'

Import-Certificate `
  -FilePath $certificatePath `
  -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'

foreach ($store in 'Root', 'TrustedPublisher') {
  Get-Item "Cert:\LocalMachine\$store\$thumbprint" |
    Format-List Subject, Thumbprint, NotAfter
}
```

PnP 驱动安装读取 Local Machine certificate stores。测试证书需要同时进入 `Trusted Root
Certification Authorities` 和 `Trusted Publishers`；只导入当前用户证书库不够。

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/installing-a-test-certificate-on-a-test-computer>
- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/local-machine-and-current-user-certificate-stores>

### 5. 启用 TESTSIGNING 并重启 target

```powershell
bcdedit /set testsigning on
bcdedit /enum '{current}' | Select-String -Pattern 'testsigning'
Restart-Computer
```

重新登录后再次确认：

```powershell
bcdedit /enum '{current}' | Select-String -Pattern 'testsigning'
```

只有 BCDEdit 成功并且 target 已经重启，新的代码完整性策略才会生效。桌面通常也会显示 Test
Mode 水印。

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/the-testsigning-boot-configuration-option>
- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/installing-test-signed-driver-packages>

### 6. 先连接 WinDbg，再安装驱动

若要捕获 `DriverEntry()`，必须先完成 target 的 kernel debugging 配置并让 debugger host 上的
WinDbg 连入，再创建设备。WinDbg 命令示例：

```text
.symfix
.sympath+ D:\symbols\kmdf-hello
.reload
ed nt!Kd_IHVDRIVER_Mask 0xffffffff
bu KmdfHello!DriverEntry
bu KmdfHello!KmdfHelloEvtDeviceAdd
g
```

`D:\symbols\kmdf-hello` 应替换为 debugger host 上包含 `KmdfHello.pdb` 的目录。源码使用
`DPFLTR_IHVDRIVER_ID` 和 `KdPrintEx()`，所以上面的 mask 会显示：

```text
KmdfHello: DriverEntry
KmdfHello: EvtDeviceAdd
```

如果只想观察打印而不下断点，可在 WinDbg 中使用 `!dbgprint`。网络内核调试的 host/target
配置见本节开头的 Microsoft 文档。

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/reading-and-filtering-debugging-messages>

### 7. 创建 ROOT 设备并安装驱动

在 target 的管理员 PowerShell 中定位或复制 x64 DevCon，然后执行：

```powershell
$package = 'C:\driver-test\kmdf-hello'
$inf = Join-Path $package 'kmdf-hello.inf'
$devcon = 'C:\driver-test\tools\devcon.exe'

if (-not (Test-Path -LiteralPath $inf)) {
  throw "INF was not found: $inf"
}
if (-not (Test-Path -LiteralPath $devcon)) {
  throw "DevCon was not found: $devcon"
}

& $devcon install $inf 'ROOT\MARTINS3_KMDF_HELLO'
if ($LASTEXITCODE -ne 0) {
  throw "DevCon failed with exit code $LASTEXITCODE"
}
```

如果 build machine 和 target 是同一台 VM，可直接把 `$devcon` 改成第 1 步找到的路径。安装
成功后 INF 中的服务名是 `Martins3KmdfHello`，内核模块名是 `KmdfHello.sys`。

### 8. 验证设备、服务、签名和调试输出

```powershell
$package = 'C:\driver-test\kmdf-hello'
$device = Get-PnpDevice |
  Where-Object InstanceId -Like 'ROOT\MARTINS3_KMDF_HELLO*'

if (-not $device) {
  throw 'ROOT\MARTINS3_KMDF_HELLO device was not found'
}

$device | Format-List Status, Class, FriendlyName, InstanceId
$instanceId = $device.InstanceId
pnputil /enum-devices /instanceid $instanceId /drivers /services
sc.exe query Martins3KmdfHello
sc.exe qc Martins3KmdfHello
Get-CimInstance Win32_SystemDriver `
  -Filter "Name='Martins3KmdfHello'" |
  Format-List Name, State, StartMode, PathName
driverquery /v /fo list |
  Select-String -Pattern 'KmdfHello|Martins3KmdfHello'

Get-AuthenticodeSignature "$package\KmdfHello.sys" |
  Format-List Status, StatusMessage, SignerCertificate
Get-AuthenticodeSignature "$package\KmdfHello.cat" |
  Format-List Status, StatusMessage, SignerCertificate
```

如果 target 安装了 WDK，还可以使用 kernel-policy verification：

```powershell
$signtool = Get-ChildItem `
  "${env:ProgramFiles(x86)}\Windows Kits\10\bin" `
  -Filter signtool.exe -Recurse |
  Where-Object FullName -Match '\\x64\\signtool.exe$' |
  Sort-Object FullName -Descending |
  Select-Object -First 1

if (-not $signtool) {
  throw 'x64 signtool.exe was not found'
}

$signtoolPath = $signtool.FullName
& $signtoolPath verify /kp /v "$package\KmdfHello.sys"
& $signtoolPath verify /kp /v "$package\KmdfHello.cat"
```

WinDbg 中进一步检查：

```text
lm m KmdfHello
!drvobj Martins3KmdfHello 7
!dbgprint
```

成功标准是：设备状态正常、服务/driver object 存在、模块已加载、签名链可信，并且 WinDbg
能看到 `DriverEntry()` 与 `KmdfHelloEvtDeviceAdd()` 的断点或打印。

### 9. 清理和回滚

最干净的做法是关闭 target 并恢复安装前快照。若要手工清理，先删除精确设备实例：

```powershell
$devcon = 'C:\driver-test\tools\devcon.exe'
$device = Get-PnpDevice |
  Where-Object InstanceId -Like 'ROOT\MARTINS3_KMDF_HELLO*' |
  Select-Object -First 1

if ($device) {
  & $devcon remove "@$($device.InstanceId)"
}
```

然后运行 `pnputil /enum-drivers /class System /files`，按 original name `kmdf-hello.inf` 和
provider `Martins3` 确认其 published name，只删除精确匹配的 `oemNN.inf`：

```powershell
pnputil /delete-driver oemNN.inf /uninstall /force
```

最后删除本次测试证书、关闭测试签名并重启：

```powershell
$certificatePath = 'C:\driver-test\kmdf-hello\WDKTestCert.cer'
$thumbprint = (Get-PfxCertificate -FilePath $certificatePath).Thumbprint

foreach ($store in 'Root', 'TrustedPublisher') {
  Get-Item "Cert:\LocalMachine\$store\$thumbprint" `
    -ErrorAction SilentlyContinue |
    Remove-Item
}

bcdedit /set testsigning off
Restart-Computer
```

`oemNN.inf` 和 `$thumbprint` 必须来自前面步骤的实际查询结果，不能照抄占位符。重启后检查
`bcdedit /enum '{current}'`、设备列表和证书库；生产环境应使用符合 Windows 发布策略的正式
签名，不应分发或长期信任 `WDKTestCert`。

- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/introduction-to-test-signing>
- <https://learn.microsoft.com/en-us/windows-hardware/drivers/install/using-device-manager-to-uninstall-devices-and-driver-packages>
