#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
function Invoke-SshScript {
    param(
        [switch]$c
    )
    & "C:\Users\97936\data\vn\smartx\ssh.ps1" @PSBoundParameters
}
Set-Alias s Invoke-SshScript

function gsy(){
  git pull --rebase --autostash
  git commit -s -m "double win"
  git push
}

function rmrf(){
  Remove-Item @args -Recurse -Force
}

function q { exit }
function gg { gitui --watcher }
function fedora { wsl --user martins3 -d FedoraLinux-42 }
Set-Alias ls lsd
function l { lsd -lah  @args }
Set-Alias c Clear-Host
Set-Alias v nvim
Set-Alias gs gitui

$env:SHELL_ARCH = "🌳"
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# oh-my-posh init pwsh | Invoke-Expression

Import-Module PSReadline
Set-PSReadLineOption -EditMode Emacs

$env:Path = "C:\Users\97936\.local\bin;$env:Path"

function Ssh-ToMac {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$MacAddress,
        
        [string]$Username = "martins3",
        
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$SshOptions
    )

    # Normalize MAC address
    $normalizedMac = $MacAddress.Trim() -replace '[:\-]', '-' -replace '\s', ''
    
    Write-Host "Searching for MAC: $MacAddress ..." -ForegroundColor Cyan
    
    # Find IP using Get-NetNeighbor
    $result = Get-NetNeighbor | Where-Object { 
        $_.LinkLayerAddress -and 
        ($_.LinkLayerAddress -replace '[:\-]', '-' -replace '\s', '') -ieq $normalizedMac 
    } | Select-Object -First 1

    # Fallback to arp
    if (-not $result) {
        $arpResult = arp -a | ForEach-Object {
            if ($_ -match '^\s+(\d+\.\d+\.\d+\.\d+)\s+([\w\-]+)') {
                $ip = $matches[1]
                $mac = $matches[2]
                if (($mac -replace '-', '-') -ieq $normalizedMac) {
                    [PSCustomObject]@{ IPAddress = $ip }
                }
            }
        } | Select-Object -First 1
        $result = $arpResult
    }

    if (-not $result) {
        Write-Error "IP not found for MAC: $MacAddress"
        return
    }

    $targetIp = $result.IPAddress
    Write-Host "Found IP: $targetIp" -ForegroundColor Green
    Write-Host "Connecting to ${Username}@${targetIp} ..." -ForegroundColor Yellow

    # Execute SSH
    $sshCommand = "ssh"
    $sshArgs = @("${Username}@${targetIp}") + $SshOptions
    
    & $sshCommand @sshArgs
}

# Alias
Set-Alias -Name sshmac -Value Ssh-ToMac

function ge {
    Ssh-ToMac 00-15-5d-00-08-04
}

# Test message
if ($MyInvocation.InvocationName -ne '.') {
    Write-Host "=== Ssh-ToMac Function Loaded ===" -ForegroundColor Cyan
    Write-Host "Usage: Ssh-ToMac <MAC> [ -Username <user> ] [ssh-options]" -ForegroundColor Green
    Write-Host "Examples:" -ForegroundColor Gray
    Write-Host "  Ssh-ToMac 00-15-5d-00-08-04"
    Write-Host "  sshmac 00:15:5d:00:08:04"
    Write-Host "  Ssh-ToMac 00155d000804 -Username root"
}

Import-Module git-aliases -DisableNameChecking
