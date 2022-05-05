#This function finds any AppX/AppXProvisioned package and uninstalls it, except for Freshpaint, Windows Calculator, Windows Store, and Windows Photos.
#Scripts may be blocked in the system, to get status: Get-ExecutionPolicy -List
#In order to run this script we need to Enable PowerShell execution: Set-ExecutionPolicy Unrestricted -Force

#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
Start-Sleep 1
Write-Host "   3"
Start-Sleep 1
Write-Host "   2"
Start-Sleep 1
Write-Host "   1"
Start-Sleep 1
Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
Exit
}

$DebloatFolder = "C:\Temp\Windows10Debloater"
If (Test-Path $DebloatFolder) {
Write-Output "$DebloatFolder exists. Skipping."
}
Else {
Write-Output "The folder '$DebloatFolder' doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
Start-Sleep 1
New-Item -Path "$DebloatFolder" -ItemType Directory
Write-Output "The folder $DebloatFolder was successfully created."
}

Start-Transcript -OutputDirectory "$DebloatFolder"

Add-Type -AssemblyName PresentationCore, PresentationFramework

Write-Output "Initiating Sysprep"
Write-Verbose -Message ('Starting Sysprep Fixes')
 
#Creates a PSDrive to be able to access the 'HKCR' tree
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

Write-Output "Stopping telemetry, disabling unneccessary scheduled tasks, and preventing bloatware from returning."
#Settings » privacy » general » app permissions
Write-Output "Setting App Permissions."
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 'Allow' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;

# Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016
# Tutorial: http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html
Write-Output "Turn off Background Apps."
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\System\GameConfigStore") -ne $true) {  New-Item "HKCU:\System\GameConfigStore" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}' -Name 'Value' -Value 'Deny' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 0 -PropertyType DWord -Force -ea Continue;

#Settings » privacy » general » windows permissions
Write-Output "Setting General Windows Permissions."
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Speech_OneCore\Preferences") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Speech_OneCore\Preferences" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Speech_OneCore\Preferences' -Name 'VoiceActivationOn' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Speech_OneCore\Preferences' -Name 'ModelDownloadAllowed' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessCamera' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessLocation' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessMicrophone' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessNotifications' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessContacts' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessCalendar' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessCallHistory' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessEmail' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessMessaging' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessRadios' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsSyncWithDevices' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'DoNotShowFeedbackNotifications' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessTasks' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsGetDiagnosticInfo' -Value 2 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsRunInBackground' -Value 2 -PropertyType DWord -Force -ea Continue;

#Created by: Shawn Brink on: April 27th 2017; Tutorial: https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html
Write-Output "Turn Off Website Access of Language List."
if((Test-Path -LiteralPath "HKCU:\Control Panel\International\User Profile") -ne $true) {  New-Item "HKCU:\Control Panel\International\User Profile" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\International\User Profile' -Name 'HttpAcceptLanguageOptOut' -Value 1 -PropertyType DWord -Force -ea Continue;

#Created by: Shawn Brink on: March 8th 2018; Tutorial: https://www.tenforums.com/tutorials/128523-enable-disable-app-launch-tracking-windows-10-a.html
Write-Output "Disable App Launch Tracking."
if((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI") -ne $true) {  New-Item "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\EdgeUI' -Name 'DisableMFUTracking' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI' -Name 'DisableMFUTracking' -Value 1 -PropertyType DWord -Force -ea Continue;

#Created by: Shawn Brink; Created on: December 17th 2017; Updated on: June 11th 2018; Tutorial: https://www.tenforums.com/tutorials/100541-turn-off-suggested-content-settings-app-windows-10-a.html
Write-Output "Turn Off Suggested Content in Settings."
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353694Enabled' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353696Enabled' -Value 0 -PropertyType DWord -Force -ea Continue;

Write-Output "Removing bloatware apps."
#Credit to Reddit user /u/GavinEke for a modified version of my whitelist code
[regex]$WhitelistedApps = 'Microsoft.ScreenSketch|Microsoft.WindowsCalculator|Microsoft.WindowsStore|Microsoft.Windows.Photos|CanonicalGroupLimited.UbuntuonWindows|`
Microsoft.MSPaint|Microsoft.WindowsCamera|.NET|Framework|Microsoft.HEIFImageExtension|Microsoft.ScreenSketch|Microsoft.StorePurchaseApp|Microsoft.AccountsControl|`
Microsoft.VP9VideoExtensions|Microsoft.WebMediaExtensions|Microsoft.WebpImageExtension|Microsoft.Windows.Search|Windows.PrintDialog|Microsoft.WindowsTerminal'
Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $WhitelistedApps} | Remove-AppxPackage -ErrorAction Continue
# Run this again to avoid error on 1803 or having to reboot.
Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $WhitelistedApps} | Remove-AppxPackage -ErrorAction Continue
$AppxRemoval = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch $WhitelistedApps} 
ForEach ( $App in $AppxRemoval) {
Remove-AppxProvisionedPackage -Online -PackageName $App.PackageName 
Get-AppxPackage | Where-Object {$_.Name -NotMatch $WhitelistedApps} | Remove-AppxPackage
}

Write-Output "Checking to see if any Whitelisted Apps were removed, and if so re-adding them."
#This includes fixes by xsisbest
If(!(Get-AppxPackage -AllUsers | Select Microsoft.MSPaint, Microsoft.WindowsCalculator, Microsoft.WindowsStore, Microsoft.WindowsSoundRecorder, Microsoft.Windows.Photos, Microsoft.WindowsTerminal)) {
#Credit to abulgatz for the 4 lines of code
Get-AppxPackage -allusers Microsoft.MSPaint | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
Get-AppxPackage -allusers Microsoft.WindowsCalculator | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
Get-AppxPackage -allusers Microsoft.WindowsStore | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
Get-AppxPackage -allusers Microsoft.WindowsSoundRecorder | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
Get-AppxPackage -allusers Microsoft.Windows.Photos | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"} }
Write-Output "White listed Apps Fixed"
Write-Output "All Apps remaining:..."
Get-AppxPackage -AllUsers | Select Name, PackageFullName

#Disables Windows Feedback Experience
Write-Output "Disabling Windows Feedback Experience program"
$Advertising = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
If (Test-Path $Advertising) {
Set-ItemProperty $Advertising -Name Enabled -Value 0 -Verbose
}

#Stops Cortana from being used as part of your Windows Search Function
Write-Output "Stopping Cortana from being used as part of your Windows Search Function"
$Search = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
If (Test-Path $Search) {
Set-ItemProperty $Search -Name AllowCortana -Value 0 -Verbose
}

#Stops the Windows Feedback Experience from sending anonymous data
Write-Output "Stopping the Windows Feedback Experience program"
$Period1 = 'HKCU:\Software\Microsoft\Siuf'
$Period2 = 'HKCU:\Software\Microsoft\Siuf\Rules'
$Period3 = 'HKCU:\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds'
If (!(Test-Path $Period3)) { 
mkdir $Period1 -ErrorAction Continue
mkdir $Period2 -ErrorAction Continue
mkdir $Period3 -ErrorAction Continue
New-ItemProperty $Period3 -Name PeriodInNanoSeconds -Value 0 -Verbose -ErrorAction Continue
}
   
Write-Output "Adding Registry key to prevent bloatware apps from returning"
#Prevents bloatware applications from returning
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
If (!(Test-Path $registryPath)) {
mkdir $registryPath -ErrorAction Continue
New-ItemProperty $registryPath -Name DisableWindowsConsumerFeatures -Value 1 -Verbose -ErrorAction Continue
}  

Write-Output "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
$Holo = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic'
If (Test-Path $Holo) {
Set-ItemProperty $Holo -Name FirstRunSucceeded -Value 0 -Verbose
}

#Disables live tiles
Write-Output "Disabling live tiles"
$Live = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'
If (!(Test-Path $Live)) {
mkdir $Live -ErrorAction Continue 
New-ItemProperty $Live -Name NoTileApplicationNotification -Value 1 -Verbose
}

#Turns off Data Collection via the AllowTelemtry key by changing it to 0
Write-Output "Turning off Data Collection"
$DataCollection = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'
If (Test-Path $DataCollection) {
Set-ItemProperty $DataCollection -Name AllowTelemetry -Value 0 -Verbose
}

#Disables People icon on Taskbar
Write-Output "Disabling People icon on Taskbar"
$People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
If (Test-Path $People) {
Set-ItemProperty $People -Name PeopleBand -Value 0 -Verbose
}

#Disables suggestions on start menu
Write-Output "Disabling suggestions on the Start Menu"
$Suggestions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
If (Test-Path $Suggestions) {
Set-ItemProperty $Suggestions -Name SystemPaneSuggestionsEnabled -Value 0 -Verbose
}

Write-Output "Removing CloudStore from registry if it exists"
$CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
If (Test-Path $CloudStore) {
Stop-Process -Name explorer -Force
Remove-Item $CloudStore -Recurse -Force
Start-Process Explorer.exe -Wait
}

#Disables scheduled tasks that are considered unnecessary 
Write-Output "Disabling scheduled tasks"
Get-ScheduledTask -TaskName Xbl* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask
Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask
Get-ScheduledTask -TaskName DmClient* | Disable-ScheduledTask
Get-ScheduledTask -TaskName "EDP Policy Manager" | Disable-ScheduledTask
Get-ScheduledTask -TaskName SmartScreenSpecific* | Disable-ScheduledTask
Get-ScheduledTask -TaskName AitAgent* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Microsoft* | Disable-ScheduledTask
Get-ScheduledTask -TaskName ProgramDataUpdater | Disable-ScheduledTask
Get-ScheduledTask -TaskName StartupAppTask | Disable-ScheduledTask
Get-ScheduledTask -TaskName CleanupTemporaryState | Disable-ScheduledTask
Get-ScheduledTask -TaskName DsSvcCleanup | Disable-ScheduledTask
Get-ScheduledTask -TaskName Proxy | Disable-ScheduledTask
Get-ScheduledTask -TaskName License* | Disable-ScheduledTask
Get-ScheduledTask -TaskName CreateObjectTask | Disable-ScheduledTask
Get-ScheduledTask -TaskName BthSQM* | Disable-ScheduledTask
Get-ScheduledTask -TaskName KernelCeipTask* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Uploader* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Microsoft-Windows-DiskDiagnosticDataCollector | Disable-ScheduledTask
Get-ScheduledTask -TaskName Diagnostics | Disable-ScheduledTask
Get-ScheduledTask -TaskName File* | Disable-ScheduledTask
Get-ScheduledTask -TaskName TempSignedLicenseExchange | Disable-ScheduledTask
Get-ScheduledTask -TaskName Notifications | Disable-ScheduledTask
Get-ScheduledTask -TaskName WindowsActionDialog | Disable-ScheduledTask
Get-ScheduledTask -TaskName WinSAT | Disable-ScheduledTask
Get-ScheduledTask -TaskName Maps* | Disable-ScheduledTask
Get-ScheduledTask -TaskName ProcessMemoryDiagnosticEvents | Disable-ScheduledTask
Get-ScheduledTask -TaskName RunFullMemoryDiagnostic | Disable-ScheduledTask
Get-ScheduledTask -TaskName MNO* | Disable-ScheduledTask
Get-ScheduledTask -TaskName SystemSoundsService | Disable-ScheduledTask
Get-ScheduledTask -TaskName Sqm-Tasks | Disable-ScheduledTask
Get-ScheduledTask -TaskName AnalyzeSystem | Disable-ScheduledTask
Get-ScheduledTask -TaskName Log* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Registration | Disable-ScheduledTask
Get-ScheduledTask -TaskName Verified* | Disable-ScheduledTask
Get-ScheduledTask -TaskName RemoteAssistanceTask | Disable-ScheduledTask
Get-ScheduledTask -TaskName Background* | Disable-ScheduledTask
Get-ScheduledTask -TaskName BackupTask* | Disable-ScheduledTask
Get-ScheduledTask -TaskName NetworkStateChangeTask | Disable-ScheduledTask
Get-ScheduledTask -TaskName Family* | Disable-ScheduledTask
Get-ScheduledTask -TaskName IndexerAutomaticMaintenance | Disable-ScheduledTask
Get-ScheduledTask -TaskName EnableLicense* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Policy* | Disable-ScheduledTask
Get-ScheduledTask -TaskName SR | Disable-ScheduledTask
Get-ScheduledTask -TaskName Queue* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Automatic* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Work* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Badge* | Disable-ScheduledTask
Get-ScheduledTask -TaskName "Sync Licenses*" | Disable-ScheduledTask
Get-ScheduledTask -TaskName WSRefresh* | Disable-ScheduledTask
Get-ScheduledTask -TaskName WSTask* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Hive* | Disable-ScheduledTask
Get-ScheduledTask -TaskName Speech* | Disable-ScheduledTask

#Stopping Edge from taking over as the default PDF Viewer.
Write-Output "Stopping Edge from taking over as the default PDF Viewer."
Get-AppxPackage *Edge* | Remove-AppxPackage
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
InitialDirectory = [Environment]::GetFolderPath('CommonProgramFilesX86''\Microsoft\Edge\Application\') 
Filter = 'executable (*.exe)'
}
$null = $FileBrowser.ShowDialog('setup.exe --uninstall --system-level --verbose-logging --force-uninstall')
$NoPDF = "HKCR:\.pdf"
$NoProgids = "HKCR:\.pdf\OpenWithProgids"
$NoWithList = "HKCR:\.pdf\OpenWithList" 
If (!(Get-ItemProperty $NoPDF  NoOpenWith)) {
New-ItemProperty $NoPDF NoOpenWith 
}
If (!(Get-ItemProperty $NoPDF  NoStaticDefaultVerb)) {
New-ItemProperty $NoPDF  NoStaticDefaultVerb 
}
If (!(Get-ItemProperty $NoProgids  NoOpenWith)) {
New-ItemProperty $NoProgids  NoOpenWith 
}
If (!(Get-ItemProperty $NoProgids  NoStaticDefaultVerb)) {
New-ItemProperty $NoProgids  NoStaticDefaultVerb 
}
If (!(Get-ItemProperty $NoWithList  NoOpenWith)) {
New-ItemProperty $NoWithList  NoOpenWith
}
If (!(Get-ItemProperty $NoWithList  NoStaticDefaultVerb)) {
New-ItemProperty $NoWithList  NoStaticDefaultVerb 
}

#Appends an underscore '_' to the Registry key for Edge
$Edge = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723"
If (Test-Path $Edge) {
Set-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ 
}

#Removes 3D Objects from the 'My Computer' submenu in explorer
Write-Host "Removing 3D Objects from the 'My Computer' submenu in explorer"
$Objects32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
$Objects64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
If (Test-Path $Objects32) {
Remove-Item $Objects32 -Recurse 
}
If (Test-Path $Objects64) {
Remove-Item $Objects64 -Recurse 
}
Start-Sleep 1

#Cleanup Start Menu
Write-Output "Cleaning up the Start Menu Apps"
# https://superuser.com/a/1442733 #Requires -RunAsAdministrator

$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6">
        <start:Group Name="Productivity">
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Paint.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Wordpad.lnk" />
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Publisher.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Snipping Tool.lnk" />
        </start:Group>
        <start:Group Name="Explore">
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\BPBiblePortable.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\GoogleChromePortable.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\MuseScorePortable.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\VLCPortable.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\TeamViewerPortable.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\FirefoxPortable.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="4" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\Start.lnk" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

$layoutFile="C:\Windows\StartMenuLayout.xml"

#Delete layout file if it already exists
If(Test-Path $layoutFile)
{
    Remove-Item $layoutFile
}

#Creates the blank layout file
$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

$regAliases = @("HKLM", "HKCU")

#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    IF(!(Test-Path -Path $keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}

#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
Stop-Process -name explorer
Start-Sleep -s 5
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

#Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

#Restart Explorer and delete the layout file
Stop-Process -name explorer

# Uncomment the next line to make clean start menu default for all new users
Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

Remove-Item $layoutFile

#Disable Cortana
Write-Output "Disabling Cortana"
Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
Get-AppxPackage *549981C3F5F10* | Remove-AppxPackage
Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -name "*Microsoft.549981C3F5F10*" | Remove-AppxPackage -AllUsers
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowCortanaButton' -Value 0 -PropertyType DWord -Force -ea Continue;

#Remove Optional Features
Write-Host "Remove Windows Media Player:"
Get-WindowsPackage -Online | Where PackageName -like *MediaPlayer* | Remove-WindowsPackage -Online -NoRestart
Get-WindowsCapability -online | ? {$_.Name -like '*WindowsMediaPlayer*'} | Remove-WindowsCapability -online
Write-Host "Remove Quick Assist:"
Get-WindowsPackage -Online | Where PackageName -like *QuickAssist* | Remove-WindowsPackage -Online -NoRestart
Get-WindowsCapability -online | ? {$_.Name -like '*QuickAssist*'} | Remove-WindowsCapability -online
Write-Host "Remove Hello Face:"
Get-WindowsPackage -Online | Where PackageName -like *Hello-Face* | Remove-WindowsPackage -Online -NoRestart
Get-WindowsCapability -online | ? {$_.Name -like '*Hello.Face*'} | Remove-WindowsCapability -online
Write-Host "Remove Internet Printing:"
Get-WindowsCapability -online | ? {$_.Name -like '*InternetPrinting*'} | Remove-WindowsCapability -online
Write-Host "Remove Work Folders:"
Get-WindowsCapability -online | ? {$_.Name -like '*WorkFolders*'} | Remove-WindowsCapability -online
Write-Host "Remove Contact Support:"
Get-WindowsCapability -online | ? {$_.Name -like '*ContactSupport*'} | Remove-WindowsCapability -online
Write-Host "Remove Language Speech:"
Get-WindowsCapability -online | ? {$_.Name -like '*Language.Speech*'} | Remove-WindowsCapability -online
Write-Host "Remove Math Recognizer:"
Get-WindowsCapability -online | ? {$_.Name -like '*MathRecognizer*'} | Remove-WindowsCapability -online

#  Disabling Windows 10 Notifications
Write-Output "Disabling Windows 10 Notifications"
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\InputPersonalization") -ne $true) {  New-Item "HKCU:\Software\Microsoft\InputPersonalization" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore") -ne $true) {  New-Item "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'DatabaseMigrationCompleted' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoCloudApplicationNotification' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization' -Name 'AcceptedPrivacyPolicy' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -Value 0 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Value 0 -PropertyType DWord -Force -ea Continue;

# Created by: Shawn Brink - Restore Windows Photo Viewer # Created on: August 8th 2015 # Updated on: August 5th 2018  #  Tutorial: https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html
Write-Output "Restore Windows Photo Viewer"
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\jpegfile\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\jpegfile\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\pngfile\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\pngfile\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\SystemFileAssociations\image\shell\Image Preview\command") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\SystemFileAssociations\image\shell\Image Preview\command" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\SystemFileAssociations\image\shell\Image Preview\DropTarget") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\SystemFileAssociations\image\shell\Image Preview\DropTarget" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" -force -ea Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\jpegfile\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\pngfile\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open' -Name 'MuiVerb' -Value '@photoviewer.dll,-3043' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap' -Name 'ImageOptionFlags' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap' -Name 'FriendlyTypeName' -Value '@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3056' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\imageres.dll,-70' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print' -Name 'NeverDefault' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget' -Name 'Clsid' -Value '{60fd46de-f830-4894-a628-6fa81bc0190d}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF' -Name 'EditFlags' -Value 65536 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF' -Name 'ImageOptionFlags' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF' -Name 'FriendlyTypeName' -Value '@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\imageres.dll,-72' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open' -Name 'MuiVerb' -Value '@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg' -Name 'EditFlags' -Value 65536 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg' -Name 'ImageOptionFlags' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg' -Name 'FriendlyTypeName' -Value '@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\imageres.dll,-72' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open' -Name 'MuiVerb' -Value '@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif' -Name 'ImageOptionFlags' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif' -Name 'FriendlyTypeName' -Value '@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\imageres.dll,-83' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png' -Name 'ImageOptionFlags' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png' -Name 'FriendlyTypeName' -Value '@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\imageres.dll,-71' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp' -Name 'EditFlags' -Value 65536 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp' -Name 'ImageOptionFlags' -Value 1 -PropertyType DWord -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\wmphoto.dll,-400' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open' -Name 'MuiVerb' -Value '@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget' -Name 'Clsid' -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\image\shell\Image Preview\command' -Name '(default)' -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\image\shell\Image Preview\DropTarget' -Name '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities' -Name 'ApplicationDescription' -Value '@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3069' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities' -Name 'ApplicationName' -Value '@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3009' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.cr2' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jpg' -Value 'PhotoViewer.FileAssoc.Jpeg' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.wdp' -Value 'PhotoViewer.FileAssoc.Wdp' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jfif' -Value 'PhotoViewer.FileAssoc.JFIF' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.dib' -Value 'PhotoViewer.FileAssoc.Bitmap' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.png' -Value 'PhotoViewer.FileAssoc.Png' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jxr' -Value 'PhotoViewer.FileAssoc.Wdp' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.bmp' -Value 'PhotoViewer.FileAssoc.Bitmap' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jpe' -Value 'PhotoViewer.FileAssoc.Jpeg' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jpeg' -Value 'PhotoViewer.FileAssoc.Jpeg' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.gif' -Value 'PhotoViewer.FileAssoc.Gif' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.tif' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.tiff' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force -ea Continue;

# Remove sounds
Write-Output "Change to no sounds theme"
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Close") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Close" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Close\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Close\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Close\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Close\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Close\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Close\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Open") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Open" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Open\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Open\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Open\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Open\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Open\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Open\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExit") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExit" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExit\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExit\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExit\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExit\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogoff") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogoff" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogoff\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogoff\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogoff\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogoff\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.Current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.None" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Names") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Names" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Names\.Default") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Names\.Default" -force -ea Continue };
if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Names\.None") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Names\.None" -force -ea Continue };
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes' -Name '(default)' -Value '.None' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default' -Name '(default)' -Value 'Windows' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default' -Name 'DispFileName' -Value '@mmres.dll,-5856' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Background.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\AppGPFault\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\CCSelect\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ChangeTheme\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Close\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Close\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Close\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Foreground.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Hardware Insert.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Hardware Remove.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Hardware Fail.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify Email.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Background.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify Email.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Maximize\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MenuCommand\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MenuPopup\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Message Nudge.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Minimize\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify System Generic.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify Messaging.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm01.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm01.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm10.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm10.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm02.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm02.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm03.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm03.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm04.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm04.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm05.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm05.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm06.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm06.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm07.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm07.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm08.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm08.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Current' -Name '(default)' -Value '%SystemRoot%\media\Alarm09.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Default' -Name '(default)' -Value '%SystemRoot%\media\Alarm09.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring01.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring01.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring10.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring10.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring02.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring02.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring03.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring03.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring04.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring04.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring05.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring05.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring06.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring06.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring07.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring07.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring08.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring08.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Current' -Name '(default)' -Value '%SystemRoot%\media\Ring09.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Default' -Name '(default)' -Value '%SystemRoot%\media\Ring09.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify Email.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Proximity Notification.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify Calendar.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Notify Messaging.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Open\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Open\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\Open\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\PrintComplete\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Proximity Connection.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\RestoreDown\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\RestoreUp\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\ShowBand\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Background.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Background.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Foreground.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows Background.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\SystemQuestion\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Current' -Name '(default)' -Value '%SystemRoot%\media\Windows Logon.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Default' -Name '(default)' -Value '%SystemRoot%\media\Windows Logon.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Default' -Name '(default)' -Value 'C:\Windows\media\Windows User Account Control.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Current' -Name '(default)' -Value '%SystemRoot%\media\Windows Unlock.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Default' -Name '(default)' -Value '%SystemRoot%\media\Windows Unlock.wav' -PropertyType ExpandString -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer' -Name '(default)' -Value 'File Explorer' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer' -Name 'DispFileName' -Value '@mmres.dll,-5854' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.Current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.Default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\Navigating\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.default' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\Explorer\SecurityBand\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr' -Name '(default)' -Value 'Speech Recognition' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr' -Name 'DispFileName' -Value '@C:\Windows\System32\speech\speechux\sapi.cpl,-5555' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.default' -Name '(default)' -Value 'C:\Windows\media\Speech Disambiguation.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.default' -Name '(default)' -Value 'C:\Windows\media\Speech Off.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.default' -Name '(default)' -Value 'C:\Windows\media\Speech On.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.default' -Name '(default)' -Value 'C:\Windows\media\Speech Sleep.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.default' -Name '(default)' -Value 'C:\Windows\media\Speech Misrecognition.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.default' -Name '(default)' -Value 'C:\Windows\media\Speech Disambiguation.wav' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.None' -Name '(default)' -Value '' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Names\.Default' -Name '(default)' -Value 'Windows Default' -PropertyType String -Force -ea Continue;
New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes\Names\.None' -Name '(default)' -Value 'No Sounds' -PropertyType String -Force -ea Continue;

Write-Host "Restore InstallService"
If (Get-Service -Name InstallService | Where-Object {$_.Status -eq "Stopped"}) {  
Start-Service -Name InstallService
Set-Service -Name InstallService -StartupType Automatic 
}

#Loads the registry keys/values below into the NTUSER.DAT file which prevents the apps from redownloading. Credit to a60wattfish
reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
reg unload HKU\Default_User

Write-Host "Unloading the HKCR drive..."
Remove-PSDrive HKCR 
Start-Sleep 1
Write-Output "Finished all tasks"
Stop-Transcript
Start-Sleep 2
