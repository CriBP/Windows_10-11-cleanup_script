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
