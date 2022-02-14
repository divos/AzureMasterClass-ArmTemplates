
param([string]$DNS) 
param([string]$OWNER)

Function New-RegKey {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String]$Path,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String]$Name,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String]$Value,
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String]$Type
    )
    IF (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
    }
    ELSE {
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
    }
}
function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    #Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
function Enable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 1
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 1
    #Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been enabled." -ForegroundColor Green
}
function Disable-UserAccessControl {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
    Write-Host "User Access Control (UAC) has been disabled." -ForegroundColor Green    
}

New-RegKey -Path HKLM:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -Type DWORD -Value "0x1"

#Disable UAC and IE enhanced security
#Disable-UserAccessControl
#Disable-InternetExplorerESC

if ($DNS -ne "") {
    Write-Host "Reset DNS = '$DNS'" 
    Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter -physical).ifIndex[0] -ServerAddresses( $DNS )
}
else {
    Write-Host "no need to reset DNS. " 
}

#### needed for windows 2016/2012
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Requires TLS 1.2, run this command to ensure PowerShell uses TLS 1.2: 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12;

# Main Command to Install
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://isops-static.quest.com/downloads/quest/kace/smaagent/win/Install_KSMAAgent_Lab.ps1.txt'))

# iex ((New-Object System.Net.WebClient).DownloadString("https://isops-static.quest.com/downloads/quest/kace/smaagent/win/Install_KSMAAgent_Lab.ps1.txt"))
# iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
cmdkey /add:`"10.250.5.8`" /user:`"Azure\saquestitlabsshare`" /pass:`"/0FAmAoVjcUDc3EMclEVhqfrzYgdG1AoR7SGk6CWc50w+2x5shN75vqfqhDaW6Sa8TLunD7p7H85CQDlJt/8Pw==`"
New-PSDrive -Name "W" -Root "\\10.250.5.8\internal-share" -Persist -PSProvider "FileSystem"
