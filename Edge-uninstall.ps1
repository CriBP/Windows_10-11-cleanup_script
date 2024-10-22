#Disables Microsoft Telemetry. Note: This will lock many Edge Browser settings. Microsoft spies heavily on you when using the Edge browser.
bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
  If ((get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
Do {
    Start-Sleep -Milliseconds 100
    $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
} Until ($preferences)
Stop-Process $taskmgr
$preferences.Preferences[28] = 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
  }
  Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

  # Fix Managed by your organization in Edge if regustry path exists then remove it

  If (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge") {
Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse -ErrorAction SilentlyContinue
  }

  # Group svchost.exe processes
  $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
  Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

  $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
  If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
  }
  icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

  # Disable Defender Auto Sample Submission
  Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue | Out-Null

# Remove Microsoft Edge	- Removes MS Edge when it gets reinstalled by updates. Credit: Techie Jack
Function Uninstall-WinUtilEdgeBrowser {
<#
    .SYNOPSIS
  This will uninstall edge by changing the region to Ireland and uninstalling edge the changing it back
#>
$msedgeProcess = Get-Process -Name "msedge" -ErrorAction SilentlyContinue
$widgetsProcess = Get-Process -Name "widgets" -ErrorAction SilentlyContinue
# Checking if Microsoft Edge is running
if ($msedgeProcess) {
    Stop-Process -Name "msedge" -Force
} else {
    Write-Output "msedge process is not running."
}
# Checking if Widgets is running
if ($widgetsProcess) {
    Stop-Process -Name "widgets" -Force
} else {
    Write-Output "widgets process is not running."
}

function Uninstall-Process {
    param (
  [Parameter(Mandatory = $true)]
  [string]$Key
    )

    $originalNation = [microsoft.win32.registry]::GetValue('HKEY_USERS\.DEFAULT\Control Panel\International\Geo', 'Nation', [Microsoft.Win32.RegistryValueKind]::String)

    # Set Nation to 84 (France) temporarily
    [microsoft.win32.registry]::SetValue('HKEY_USERS\.DEFAULT\Control Panel\International\Geo', 'Nation', 68, [Microsoft.Win32.RegistryValueKind]::String) | Out-Null

    # credits to he3als for the Acl commands
    $fileName = "IntegratedServicesRegionPolicySet.json"
    $pathISRPS = [Environment]::SystemDirectory + "\" + $fileName
    $aclISRPS = Get-Acl -Path $pathISRPS
    $aclISRPSBackup = [System.Security.AccessControl.FileSecurity]::new()
    $aclISRPSBackup.SetSecurityDescriptorSddlForm($acl.Sddl)
    if (Test-Path -Path $pathISRPS) {
  try {
$admin = [System.Security.Principal.NTAccount]$(New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')).Translate([System.Security.Principal.NTAccount]).Value

$aclISRPS.SetOwner($admin)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admin, 'FullControl', 'Allow')
$aclISRPS.AddAccessRule($rule)
Set-Acl -Path $pathISRPS -AclObject $aclISRPS

Rename-Item -Path $pathISRPS -NewName ($fileName + '.bak') -Force
  }
  catch {
Write-Error "[$Mode] Failed to set owner for $pathISRPS"
  }
    }

    $baseKey = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate'
    $registryPath = $baseKey + '\ClientState\' + $Key

    if (!(Test-Path -Path $registryPath)) {
  Write-Host "[$Mode] Registry key not found: $registryPath"
  return
    }

    Remove-ItemProperty -Path $registryPath -Name "experiment_control_labels" -ErrorAction SilentlyContinue | Out-Null

    $uninstallString = (Get-ItemProperty -Path $registryPath).UninstallString
    $uninstallArguments = (Get-ItemProperty -Path $registryPath).UninstallArguments

    if ([string]::IsNullOrEmpty($uninstallString) -or [string]::IsNullOrEmpty($uninstallArguments)) {
  Write-Host "[$Mode] Cannot find uninstall methods for $Mode"
  return
    }

    $uninstallArguments += " --force-uninstall --delete-profile"

    # $uninstallCommand = "`"$uninstallString`"" + $uninstallArguments
    if (!(Test-Path -Path $uninstallString)) {
  Write-Host "[$Mode] setup.exe not found at: $uninstallString"
  return
    }
    Start-Process -FilePath $uninstallString -ArgumentList $uninstallArguments -Wait -NoNewWindow -Verbose

    # Restore Acl
    if (Test-Path -Path ($pathISRPS + '.bak')) {
  Rename-Item -Path ($pathISRPS + '.bak') -NewName $fileName -Force
  Set-Acl -Path $pathISRPS -AclObject $aclISRPSBackup
    }

    # Restore Nation
    [microsoft.win32.registry]::SetValue('HKEY_USERS\.DEFAULT\Control Panel\International\Geo', 'Nation', $originalNation, [Microsoft.Win32.RegistryValueKind]::String) | Out-Null

    if ((Get-ItemProperty -Path $baseKey).IsEdgeStableUninstalled -eq 1) {
  Write-Host "[$Mode] Edge Stable has been successfully uninstalled"
    }
}

function Uninstall-Edge {
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" -Name "NoRemove" -ErrorAction SilentlyContinue | Out-Null

    [microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev", "AllowUninstall", 1, [Microsoft.Win32.RegistryValueKind]::DWord) | Out-Null

    Uninstall-Process -Key '{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}'

    @( "$env:ProgramData\Microsoft\Windows\Start Menu\Programs",
 "$env:PUBLIC\Desktop",
 "$env:USERPROFILE\Desktop" ) | ForEach-Object {
  $shortcutPath = Join-Path -Path $_ -ChildPath "Microsoft Edge.lnk"
  if (Test-Path -Path $shortcutPath) {
Remove-Item -Path $shortcutPath -Force
  }
    }

}

function Uninstall-WebView {
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView" -Name "NoRemove" -ErrorAction SilentlyContinue | Out-Null

    # Force to use system-wide WebView2
    # [microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\WebView2\BrowserExecutableFolder", "*", "%%SystemRoot%%\System32\Microsoft-Edge-WebView")

    Uninstall-Process -Key '{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}'
}

function Uninstall-EdgeUpdate {
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" -Name "NoRemove" -ErrorAction SilentlyContinue | Out-Null

    $registryPath = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate'
    if (!(Test-Path -Path $registryPath)) {
  Write-Host "Registry key not found: $registryPath"
  return
    }
    $uninstallCmdLine = (Get-ItemProperty -Path $registryPath).UninstallCmdLine

    if ([string]::IsNullOrEmpty($uninstallCmdLine)) {
  Write-Host "Cannot find uninstall methods for $Mode"
  return
    }

    Write-Output "Uninstalling: $uninstallCmdLine"
    Start-Process cmd.exe "/c $uninstallCmdLine" -WindowStyle Hidden -Wait
}

Uninstall-Edge
    # "WebView" { Uninstall-WebView }
    # "EdgeUpdate" { Uninstall-EdgeUpdate }
}
Uninstall-WinUtilEdgeBrowser

