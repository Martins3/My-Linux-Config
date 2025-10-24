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

# Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# oh-my-posh init pwsh | Invoke-Expression

Import-Module PSReadline
Set-PSReadLineOption -EditMode Emacs
