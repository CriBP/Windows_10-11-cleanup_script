msg "%username%" Please make sure you: `Read_First.txt
Notepad "`Read_First.txt"
systeminfo
:: Rename C: Drive to Windows-OS
label C: Windows-OS

:: Set Time to UTC (Dual Boot) Essential for computers that are dual booting. Fixes the time sync with Linux Systems.
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /f /v RealTimeIsUniversal /t REG_DWORD /d 1

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
:: Rename computer to Work-PC
rem wmic computersystem rename Work-PC
:: Add comments with :: or REM at beginning, if they are not in the beginning of line, then add & character: your commands here & :: comment

:: Disable Hyper-V:
:: bcdedit /set hypervisorlaunchtype off
:: DISM /Online /Disable-Feature:Microsoft-Hyper-V

:: Microsoft Edge uninstall
powershell.exe -ExecutionPolicy Bypass -File ./Edge-uninstall.ps1

:: Microsoft OneDrive uninstall
powershell.exe -ExecutionPolicy Bypass -File ./OneDrive-uninstall.ps1
set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
:: Closing OneDrive process.
taskkill /f /im OneDrive.exe
ping 127.0.0.1 -n 5
if exist %x64% (
%x64% /uninstall
) else (
%x86% /uninstall
)
ping 127.0.0.1 -n 5
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
:: Removing OneDrive leftovers.
rd "%USERPROFILE%\OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S
:: Removing OneDrive from the Explorer Side Panel.
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
del /Q /F "%localappdata%\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe"
del /Q /F "%UserProfile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

:: Prefer IPv4 over IPv6: To set the IPv4 preference can have latency and security benefits on private networks where IPv6 is not configured.
reg add "HKLM\System\CurrentControlSet\Services\Tcpip6\Parameters" /f /v DisabledComponents /t REG_DWORD /d 255

:: Disable Wifi-Sense: Wifi Sense is a spying service that phones home all nearby scanned wifi networks and your current geo location.
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /f /v "Value" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /f /v "Value" /t REG_DWORD /d 0

:: Enable End Task With Right Click - Enables option to end task when right clicking a program in the taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /f /v TaskbarEndTask /t REG_DWORD /d 1

:: Remove Home and Gallery from explorer
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d "1"
	  
:: Turn Off System Protection for All Drives
:: Created by: Shawn Brink; Created on: December 27, 2021; Tutorial: https://www.elevenforum.com/t/turn-on-or-off-system-protection-for-drives-in-windows-11.3598/
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}"
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /f /v "RPSessionInterval" /t REG_DWORD /d "0"
wmic /Namespace:\\root\default Path SystemRestore Call Disable "C:\" & :: C-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "D:\" & :: D-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "E:\" & :: E-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "F:\" & :: F-drive

:: Disable Hybernation
powercfg -h off
powercfg.exe /hibernate off
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /f /v HibernateEnabled /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /f /v ShowHibernateOption /t REG_DWORD /d 0

:: Decrypt Bitlocker (useless resource hog abused by Microsoft, unless sensitive data has to be protected)
manage-bde -status
manage-bde -off C:
manage-bde -off D:
manage-bde -off E:
manage-bde -off F:

:: Disable Copilot
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsCopilot" /f /v TurnOffWindowsCopilot /t REG_DWORD /d 1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /f /v TurnOffWindowsCopilot /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowCopilotButton /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Edge" /f /v HubsSidebarEnabled" /t REG_DWORD /d 0

:: Disable Ads in Windows 11 - Source https://www.elevenforum.com/t/disable-ads-in-windows-11.8004/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowSyncProviderNotifications /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_IrisRecommendations /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_AccountNotifications /t REG_DWORD /d 0

:: Remove Settings Home page in Windows 11; Created by: Shawn Brink; Created on: June 30, 2023; Tutorial: https://www.elevenforum.com/t/add-or-remove-settings-home-page-in-windows-11.16017/
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "SettingsPageVisibility" /t REG_SZ /d "hide:home"

:: Turn Off Suggested Content in Settings: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-suggested-content-in-settings-in-windows-11.3791/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 :: Lock screen Spotlight - New backgrounds, tips, advertisements etc.
:: To Turn Off App Suggestions in Start: source https://forums.mydigitallife.net/threads/windows-10-guide-for-remove-and-stop-apps-bundle-and-more-tweaks.76030/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 :: OEM Preinstalled Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 :: Preinstalled Apps in Windows 10
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SystemPaneSuggestionsEnabled " /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 :: Windows Spotlight
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 :: Get fun facts, tips, tricks, and moe on your lock screen
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280810Enabled" /t REG_DWORD /d 0 :: SyncProviders - OneDrive
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280811Enabled" /t REG_DWORD /d 0 :: OneDrive
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280813Enabled" /t REG_DWORD /d 0 :: Windows Ink - StokedOnIt
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-202914Enabled" /t REG_DWORD /d 0 :: Windows Spotlight
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280815Enabled" /t REG_DWORD /d 0 :: Share - Facebook, Instagram and etc.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310091Enabled" /t REG_DWORD /d 0 :: 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310092Enabled" /t REG_DWORD /d 0 :: 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338380Enabled" /t REG_DWORD /d 0 :: 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-314559Enabled" /t REG_DWORD /d 0 :: BingWeather, Candy Crush and etc.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338381Enabled" /t REG_DWORD /d 0 :: Windows Maps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-314563Enabled" /t REG_DWORD /d 0 :: My People Suggested Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0 :: Timeline Suggestions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 :: Occasionally show suggestions in Start
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 :: Get tips, tricks and suggestion as you use Windows and Cortana
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 :: Show me suggested content in the Settings app
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-88000326Enabled" /t REG_DWORD /d 0
:: Disable Start Menu Suggestions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 :: Occassionally showing app suggestions in Start Menu
:: To Disable Automatically Installing Suggested Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 :: Automatically Installing Suggested Apps in Windows 10 Store Apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "FeatureManagementEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContentEnabled" /t REG_DWORD /d 0 :: Subsribed Content status Suggested Apps
:: Disable Spotlight
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SlideshowEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SoftLandingEnabled" /t REG_DWORD /d 0 :: Tips, tricks and suggestions while using Windows

:: Clear and Reset Quick Access Folders
del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms"

:: Increase the number of recent files displayed in the task bar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "JumpListItems_Maximum " /t REG_DWORD /d 30

:: Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Holographic" /f /v "FirstRunSucceeded " /t REG_DWORD /d 0

:: Remove Optional Features - List all Optional Features
dism /Online /Get-Capabilities
:: "Remove Windows Media Player:"
dism /Online /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0
:: "Remove Feature: Extended Inbox Theme Content:"
dism /Online /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~
dism /Online /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~0.0.1.0
:: "Remove Feature: Microsoft Quick Assist:"
dism /Online /Remove-Capability /CapabilityName:App.Support.QuickAssist~~~~0.0.1.0
:: "Remove Hello Face:"
dism /Online /Remove-Capability /CapabilityName:Hello.Face.18967~~~~0.0.1.0
dism /Online /Remove-Capability /CapabilityName:Hello.Face.Migration.18967~~~~0.0.1.0
dism /Online /Remove-Capability /CapabilityName:Hello.Face.20134~~~~0.0.1.0
:: "Remove Math Recognizer:"
dism /Online /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0
:: "Remove Onesync Feature: Exchange ActiveSync and Internet Mail Sync Engine:"
dism /Online /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~~~0.0.1.0
:: Turn off Steps Recorder - Source https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.ApplicationCompatibility::AppCompatTurnOffUserActionRecord
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /f /v "DisableUAR" /t REG_DWORD /d "1"
dism /Online /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0
:: Remove Feature: Windows Feature Experience Pack
dism /Online /Remove-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0
:: "Remove Internet Printing:"
:: "Remove Work Folders:"
:: "Remove Contact Support:"
:: "Remove Language Speech:"

:: Add Optional Features
:: Add Feature: Print Fax Scan
dism /Online /Add-Capability /CapabilityName:Print.Fax.Scan~~~~0.0.1.0
:: Add Feature: WMIC. A Windows Management Instrumentation (WMI) command-line utility.
dism /Online /Add-Capability /CapabilityName:WMIC~~~~
:: Add  .NET Framework
dism /Online /Add-Capability /CapabilityName:NetFX3~~~~

:: Enable High Performance Power Scheme
powercfg /l
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /x monitor-timeout-ac 10
powercfg /x monitor-timeout-dc 10
powercfg /x disk-timeout-ac 20
powercfg /x disk-timeout-dc 20
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 15
:: Critical battery action: No action is taken when the critical battery level is reached.
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 0 

:: Change to Dark Theme:
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "AppsUseLightTheme" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "SystemUsesLightTheme" /t REG_DWORD /d 0
reg add "HKCU\Control Panel\Colors" /f /v "Background" /t REG_SZ /d "0 0 0"
reg add "HKCU\Control Panel\Desktop" /f /v "WallPaper" /t REG_SZ /d "C:\Windows\web\wallpaper\Windows\img19.jpg"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "AppsUseLightTheme" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "ColorPrevalence" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "EnableTransparency" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "SystemUsesLightTheme" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentPalette" /t REG_BINARY /d "98abb6007d8d9600637077004a545900373f42002c3235001f23250000b7c300"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "StartColorMenu" /t REG_DWORD /d "4282531639"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentColorMenu" /t REG_DWORD /d "4284044362"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /f /v "BackgroundType" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "AccentColor" /t REG_DWORD /d "4284044362"
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "ColorizationAfterglow" /t REG_DWORD /d "3293205593"
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "ColorizationColor" /t REG_DWORD /d "3293205593"
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "ColorPrevalence" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "EnableWindowColorization" /t REG_DWORD /d 1

:: Quiet down Windows Security stopping unnecessary notifications
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableNotifications" /t REG_DWORD /d "1"
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableWindowsHelloNotifications" /t REG_DWORD /d "1"
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableDynamiclockNotifications" /t REG_DWORD /d "1"

:: Disable Collect Activity History: Created by: Shawn Brink on: December 14th 2017; Tutorial: https://www.tenforums.com/tutorials/100341-enable-disable-collect-activity-history-windows-10-a.html
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "EnableActivityFeed" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /f /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1

:: Add Windows Defender ExclusionPath to enable host protection:
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%UserProfile%\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath 'D:\Microsoft\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemRoot%\System32\drivers\etc\hosts'"

:: Transfer Hosts File:
copy /D /V /Y hosts %SystemRoot%\System32\drivers\etc\hosts

:: Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016: Tutorial: http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /f /v "GlobalUserDisabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /f /v "Value" /t REG_SZ /d "Deny"
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /f /v "VoiceActivationOn" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /f /v "ModelDownloadAllowed" /t REG_DWORD /d 0

:: Turn Off Website Access of Language List: Created by: Shawn Brink on: April 27th 2017; Tutorial: https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html
reg add "HKCU\Control Panel\International\User Profile" /f /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Language Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Layout Hotkey" /t REG_SZ /d "3"

:: Settings » privacy » general » app permissions: "Setting App Permissions."
:: Next statements will deny access to the following apps under Privacy - - Setting anyone of these back to allow allows toggle functionality
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /f /v "Value" /t REG_SZ /d Deny
::  Disable app diag info about your other apps
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access calendar
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access other devices
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access your file system
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access messaging
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access your contacts
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access Documents
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder" /f /v "Value" /t REG_SZ /d Deny
::  Do not Allow apps to access email 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice" /f /v "Value" /t REG_SZ /d Deny
:: Disable Location Tracking
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /f /v "SensorPermissionState" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\lfsvc\Service\Configuration" /f /v "Status" /t REG_DWORD /d 0
reg add "HKLM\System\Maps" /f /v "AutoUpdateEnabled" /t REG_DWORD /d 0
::  Do not allow apps to access microphone
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /f /v "Value" /t REG_SZ /d Allow
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access call history
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access Pictures
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /f /v "Value" /t REG_SZ /d Deny
::  Do Not allow apps to access radio
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access Account Information
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access tasks
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access Notifications
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access Videos
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /f /v "Value" /t REG_SZ /d Deny
::  App access turn off camera
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /f /v "Value" /t REG_SZ /d Allow
::  App access turn off WIFI
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect" /f /v "Value" /t REG_SZ /d Deny

:: Settings » privacy » general » windows permissions "Setting General Windows Permissions.": From https://admx.help/HKLM/Software/Policies/Microsoft/Windows/AppPrivacy
:: Windows apps access user movements while running in the background
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessBackgroundSpatialPerception" /t REG_DWORD /d 2
:: Windows apps activate with voice while the system is locked
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoiceAboveLock" /t REG_DWORD /d 2
:: Windows apps activate with voice
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoice" /t REG_DWORD /d 2
:: Windows apps access an eye tracker device
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGazeInput" /t REG_DWORD /d 2
:: Windows apps access diagnostic information about other apps
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d 2
:: Windows apps run in the background
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsRunInBackground" /t REG_DWORD /d 2
:: Windows apps access trusted devices
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTrustedDevices" /t REG_DWORD /d 2
:: Windows apps access Tasks
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTasks" /t REG_DWORD /d 2
:: Windows apps communicate with unpaired devices
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2
:: Windows apps control radios
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessRadios" /t REG_DWORD /d 2
:: Windows apps make phone calls
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessPhone" /t REG_DWORD /d 2
:: Windows apps access notifications
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessNotifications" /t REG_DWORD /d 2
:: Windows apps access motion
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMotion" /t REG_DWORD /d 2
:: Windows apps access the microphone
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMicrophone" /t REG_DWORD /d 0
:: Windows apps access messaging
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMessaging" /t REG_DWORD /d 2
:: Windows apps access location
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessLocation" /t REG_DWORD /d 2
:: Windows apps turn off the screenshot border
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureWithoutBorder" /t REG_DWORD /d 2
:: Windows apps take screenshots of various windows or displays
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureProgrammatic" /t REG_DWORD /d 2
:: Windows apps access email
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessEmail" /t REG_DWORD /d 2
:: Windows apps access contacts
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessContacts" /t REG_DWORD /d 2
:: Windows apps access the camera
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCamera" /t REG_DWORD /d 0
:: Windows apps access call history
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2
:: Windows apps access the calendar
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCalendar" /t REG_DWORD /d 2
:: Windows apps access account information
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 2

:: Disable App Launch Tracking: Created by: Shawn Brink; Created on: January 3, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-app-launch-tracking-in-windows-11.3727/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Start_TrackProgs" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1

:: Disabling Windows Notifications
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "DatabaseMigrationCompleted" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "ToastEnabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoCloudApplicationNotification" /t REG_DWORD /d 1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0

:: Removes 3D Objects from the 'My Computer' submenu in explorer
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f

:: settings » privacy » general » let apps use my ID ...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /f /v "DisabledByGroupPolicy" /t REG_DWORD /d 1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Id"

:: Turn Off Personal Inking and Typing Dictionary: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-personal-inking-and-typing-dictionary-in-windows-11.5564/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization" /f /v "Value" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /f /v "HarvestContacts" /t REG_DWORD /d 0

:: Disable Windows Search Box... and web search in the search box Created by: Shawn Brink on: May 4th 2019 Tutorial: https://www.tenforums.com/tutorials/2854-hide-show-search-box-search-icon-taskbar-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "BingSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlStatus" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlSecondaryStatus" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "SearchboxTaskbarMode" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "SearchOnTaskbarMode" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1

:: Enable Admin Shares...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\system" /f /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1

:: Remove the Limit local account use of blank passwords to console logon only...
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v "LimitBlankPasswordUse" /t REG_DWORD /d 0

:: Enable Local Security Authority Protection...
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v RunAsPPL /t REG_DWORD /d 1

:: Disable Windows Feedback...
reg add "HKCU\Software\Microsoft\Siuf\Rules" /f /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0
reg delete "HKCU\Software\Microsoft\Siuf\Rules" /f /v "PeriodInNanoSeconds"
reg add "HKLM\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f /v "Start" /t REG_DWORD /d 0
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
echo y|cacls  C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl  /d SYSTEM
rem reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKCU\Software\Microsoft\Internet Explorer\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "EnableSmartScreen" /t REG_DWORD /d 0

:: Disabling Cortana...
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCortana" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"  /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d  "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search  and Cortana  application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

:: Turn off Windows Error reporting...
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1

:: No license checking... removed now
rem reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f /v "NoGenTicket" /t REG_DWORD /d 1
reg delete "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f

:: Disable app access to Voice activation...
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d 0

:: Disable sync...
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSync" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 

:: No Windows Tips...
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableSoftLanding" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\WindowsInkWorkspace" /f /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d 0

:: Disabling live tiles...
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoTileApplicationNotification" /t REG_DWORD /d 1

:: Debloat Microsoft Edge using Registry - Disables various telemetry options, popups, and other annoyances in Edge.
reg add "HKLM\Software\Microsoft\EdgeUpdate" /f /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\EdgeUpdate" /f /v "CreateDesktopShortcutDefault" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "EdgeEnhanceImagesEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "PersonalizationReportingEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "ShowRecommendationsEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "HideFirstRunExperience" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "UserFeedbackAllowed" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "ConfigureDoNotTrack" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "AlternateErrorPagesEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "EdgeCollectionsEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "EdgeFollowEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "MicrosoftEdgeInsiderPromotionEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "PersonalizationReportingEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "ShowMicrosoftRewards" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "WebWidgetAllowed" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "DiagnosticData" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "EdgeAssetDeliveryServiceEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "EdgeCollectionsEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "CryptoWalletEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "ConfigureDoNotTrack" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Edge" /f /v "WalletDonationEnabled" /t REG_DWORD /d 0

:: settings » privacy » general » speech, inking, typing
reg add "HKCU\Software\Microsoft\Personalization\Settings" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" /f /v "AllowLinguisticDataCollection" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Input\TIPC" /f /v "Enabled" /t REG_DWORD /d 0

:: Disables Autoplay and Turn Off AutoRun in Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /f /v "DisableAutoplay" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"

:: Disable Low Disk Space Checks in Windows - https://www.lifewire.com/how-to-disable-low-disk-space-checks-in-windows-vista-2626331
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoLowDiskSpaceChecks" /t REG_DWORD /d 1

:: Windows 11 Explorer use compact mode and restore Classic Context Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v UseCompactMode /t REG_DWORD /d 1
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f

:: Disables Meet Now Chat and Microsoft Teams; Remove Chat from the taskbar in Windows 11
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f /v "com.squirrel.Teams.Teams"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarMn /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3

:: Turn off News and Interests
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /f /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarDa" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Feeds" /f /v "EnableFeeds" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Dsh" /f /v "AllowNewsAndInterests" /t REG_DWORD /d 0
powershell -noprofile -executionpolicy bypass -command "Get-AppxPackage -Name *WebExperience* | Foreach {Remove-AppxPackage $_.PackageFullName}"
powershell -noprofile -executionpolicy bypass -command "Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match 'WebExperience' } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }"

:: Turn off Suggest Ways I can finish setting up my device: Created by: Shawn Brink on: July 31, 2019; Tutorial: https://www.tenforums.com/tutorials/137645-turn-off-get-even-more-out-windows-suggestions-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /f /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0

:: Turn off Game Mode: Created by: Shawn Brink on: January 27th 2016; Updated on: November 6th 2017; Tutorial: https://www.tenforums.com/tutorials/75936-turn-off-game-mode-windows-10-a.html
reg add "HKCU\Software\Microsoft\GameBar" /f /v "AllowAutoGameMode" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\GameBar" /f /v "AutoGameModeEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /f /v "AppCaptureEnabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_Enabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /f /v "AllowGameDVR" /t REG_DWORD /d 0

:: Turn off Cloud Content Search for Microsoft Account: Created by: Shawn Brink on: September 18, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-cloud-content-search-in-windows-11.5378/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsAADCloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCloudSearch" /t REG_DWORD /d 0

:: Removing CloudStore from registry if it exists
taskkill /f /im explorer.exe
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore /f
start explorer.exe

:: Turn Off Device Search History: Created by: Shawn Brink on: September 18, 2020; Tutorial: https://www.tenforums.com/tutorials/133365-turn-off-device-search-history-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0

:: Remove Duplicate Drives in Navigation Pane of File Explorer: Created by: Shawn Brink: Tutorial: https://www.tenforums.com/tutorials/4675-drives-navigation-pane-add-remove-windows-10-a.html; https://www.winhelponline.com/blog/drives-listed-twice-explorer-navigation-pane/
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1

:: Disable Pin Store to Taskbar for All Users: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/47742-store-enable-disable-pin-taskbar-windows-8-10-a.html; https://www.elevenforum.com/t/enable-or-disable-show-pinned-items-on-taskbar-in-windows-11.3650/
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1

:: Disable Pin People icon on Taskbar: Created by: Shawn Brink; Created on: February 23rd 2018ș Tutorial: https://www.tenforums.com/tutorials/104877-enable-disable-people-bar-taskbar-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /f /v "PeopleBand" /t REG_DWORD /d "0"
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"

:: Choose which folders appear on start: To force a pinned folder to be visible, set the corresponding registry values to 1 (both values must set); to force it to be hidden, set the "_ProviderSet" value to 1 and the other one to 0; to let the user choose "_ProviderSet" value to 0 or delete the values. https://social.technet.microsoft.com/Forums/en-US/dbe85f3d-52a8-4852-a784-7bac64a9fa78/controlling-1803-quotchoose-which-folders-appear-on-startquot-settings?forum=win10itprosetup#3b488a59-cefe-4947-8529-944475c452d5
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDocuments" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDocuments_ProviderSet" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDownloads" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDownloads_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderFileExplorer" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderFileExplorer_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderMusic" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderMusic_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderNetwork" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderNetwork_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPersonalFolder" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPersonalFolder_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPictures" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPictures_ProviderSet" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderSettings" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderSettings_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderVideos" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderVideos_ProviderSet" /t REG_DWORD /d 0

:: Add User's Files Desktop Icon: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/6942-desktop-icons-add-remove-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0

:: Hide Unused User's Profile Personal Folders like 3D,Saved Games,Searches: Created by: Shawn Brink; Created on: April 13th 2018; Tutorial: https://www.tenforums.com/tutorials/108032-hide-show-user-profile-personal-folders-windows-10-file-explorer.html
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"

:: Windows Explorer Tweaks: Hidden Files,Expand to Current
:: Change your Visual Effects Settings: https://www.tenforums.com/tutorials/6377-change-visual-effects-settings-windows-10-a.html
:: 0 = Let Windows choose what’s best for my computer
:: 1 = Adjust for best appearance
:: 2 = Adjust for best performance
:: 3 = Custom ;This disables the following 8 settings:Animate controls and elements inside windows;Fade or slide menus into view;Fade or slide ToolTips into view;Fade out menu items after clicking;Show shadows under mouse pointer;Show shadows under windows;Slide open combo boxes;Smooth-scroll list boxes
:: Open File Explorer to: This PC
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d 1
:: Show hidden files, folders, and drives
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Hidden" /t REG_DWORD /d 1
:: Hide protected operating system files (Recommended)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ShowSuperHidden" /t REG_DWORD /d 0
:: Hide Desktop icons
:: reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideIcons" /t REG_DWORD /d 1
:: Hide extensions for known file types
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideFileExt" /t REG_DWORD /d 0
:: Navigation pane: Expand to open folder
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneExpandToCurrentFolder" /t REG_DWORD /d 1
:: Navigation pane: Show all folders
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneShowAllFolders" /t REG_DWORD /d 1

:: Change Visual Effects Settings for Best Performance and best looking
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /f /v "VisualFXSetting" /t REG_DWORD /d 3
:: Animate controls and elements inside windows - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Animate windows when minimizing and maximizing - off
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /d 0
:: Animations in the taskbar - off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
:: Enable Peek - off: Created by: Shawn Brink; Created on: April 14th 2016; Updated on: May 23rd 2019; Tutorial: https://www.tenforums.com/tutorials/47266-turn-off-peek-desktop-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v DisablePreviewDesktop /t REG_DWORD /d 1
:: Fade or slide menus into view - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Fade or slide ToolTips into view - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Fade out menu items after clicking - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Save taskbar thumbnail previews - off
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
:: Show shadows under mouse pointer
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Show shadows under windows
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Show thumbnails instead of icons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "IconsOnly" /t REG_DWORD /d 0
:: Show translucent selection rectangle - off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
:: Show window contents while dragging - off
reg add "HKCU\Control Panel\Desktop" /f /v "DragFullWindows" /d 0
:: Slide open combo boxes - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Smooth edges of screen fonts
reg add "HKCU\Control Panel\Desktop" /f /v "FontSmoothing" /t REG_SZ /d "2"
:: Smooth-scrool list boxes - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Use drop shadows for icon labels on the desktop
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewShadow" /t REG_DWORD /d 0
:: Move the Start button to the Left Corner:
taskkill /f /im explorer.exe
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0
start explorer.exe

:: Disable Remote Assistance: Created by: Shawn Brink on: August 27th 2018:: Tutorial: https://www.tenforums.com/tutorials/116749-enable-disable-remote-assistance-connections-windows.html
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /f /v fAllowToGetHelp /t REG_DWORD /d 0
netsh advfirewall firewall set rule group="Remote Assistance" new enable=no

:: Change to Small memory dump: Memory dump file options for Windows: https://support.microsoft.com/en-us/topic/b863c80e-fb51-7bd5-c9b0-6116c3ca920f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "CrashDumpEnabled" /d "0x3"

:: Clear Taskbar Pinned Apps: Created by: Shawn Brink on: December 3rd 2014: Tutorial: https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned"
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
:: reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /F
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

:: "Restore Windows Photo Viewer" Created by: Shawn Brink; Created on: August 8th 2015; Updated on: August 5th 2018 #  Tutorial: https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html
reg add "HKCR\jpegfile\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\pngfile\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\Applications\photoviewer.dll\shell\open" /f /v "MuiVerb" /t REG_SZ /d "@photoviewer.dll,-3043"
reg add "HKCR\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\Applications\photoviewer.dll\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap" /f /v "ImageOptionFlags" /t REG_DWORD /d "1"
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap" /f /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056"
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\Applications\photoviewer.dll\shell\print" /f /v "NeverDefault" /t REG_SZ /d ""
reg add "HKCR\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\Applications\photoviewer.dll\shell\print\DropTarget" /f /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}"
reg add "HKCR\PhotoViewer.FileAssoc.JFIF" /f /v "EditFlags" /t REG_DWORD /d "65536"
reg add "HKCR\PhotoViewer.FileAssoc.JFIF" /f /v "ImageOptionFlags" /t REG_DWORD /d "1"
reg add "HKCR\PhotoViewer.FileAssoc.JFIF" /f /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055"
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\shell\open" /f /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043"
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg" /f /v "EditFlags" /t REG_DWORD /d "65536"
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg" /f /v "ImageOptionFlags" /t REG_DWORD /d "1"
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg" /f /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055"
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\shell\open" /f /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043"
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\PhotoViewer.FileAssoc.Gif" /f /v "ImageOptionFlags" /t REG_DWORD /d "1"
reg add "HKCR\PhotoViewer.FileAssoc.Gif" /f /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057"
reg add "HKCR\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\PhotoViewer.FileAssoc.Png" /f /v "ImageOptionFlags" /t REG_DWORD /d "1"
reg add "HKCR\PhotoViewer.FileAssoc.Png" /f /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057"
reg add "HKCR\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\PhotoViewer.FileAssoc.Wdp" /f /v "EditFlags" /t REG_DWORD /d "65536"
reg add "HKCR\PhotoViewer.FileAssoc.Wdp" /f /v "ImageOptionFlags" /t REG_DWORD /d "1"
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\shell\open" /f /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043"
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /f /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
reg add "HKCR\SystemFileAssociations\image\shell\Image Preview\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\SystemFileAssociations\image\shell\Image Preview\DropTarget" /f /v "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /t REG_SZ /d ""
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities" /f /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities" /f /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".cr2" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff"
reg add "HKLM\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff"

:: Remove sounds - "Change to no sounds theme"
reg add "HKCU\AppEvents\Schemes" /f /ve /t REG_SZ /d ".None"
reg add "HKCU\AppEvents\Schemes\Apps\.Default\.Default\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\AppGPFault\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\CCSelect\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Close\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Maximize\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MenuCommand\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MenuPopup\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Minimize\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Open\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\PrintComplete\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\RestoreDown\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\RestoreUp\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ShowBand\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemExit\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Current" /f /ve /t REG_EXPAND_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Current" /f /ve /t REG_EXPAND_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\FaxError\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\FaxLineRings\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\FaxSent\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\SecurityBand\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" /f /ve /t REG_SZ /d ""
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" /f /ve /t REG_SZ /d ""

:: Remove Xbox...
sc stop XblAuthManager
sc delete XblAuthManager
sc stop XblGameSave
sc delete XblGameSave
sc stop XboxNetApiSvc
sc delete XboxNetApiSvc
sc stop XboxGipSvc
sc delete XboxGipSvc
reg delete "HKLM\System\CurrentControlSet\Services\xbgm" /f
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disable

:: Remove Maps...
sc stop "MapsBroker"
sc config "MapsBroker" start=disabled
sc delete MapsBroker
sc stop lfsvc
sc delete lfsvc
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable

:: Disables scheduled tasks that are considered unnecessary
schtasks /query /v /fo CSV > tasks.csv
:: EDP Policy Manager - This task performs steps necessary to configure Windows Information Protection.
schtasks /Change /TN "\Microsoft\Windows\AppID\EDP Policy Manager" /disable
:: Inspects the AppID certificate cache for invalid or revoked certificates.
:: schtasks /Change /TN "\Microsoft\Windows\AppID\VerifiedPublisherCertStoreCheck" /disable
?schtasks /Change /TN "\Microsoft\Windows\SmartScreenSpecific*" /disable
?schtasks /Change /TN "\Microsoft\Windows\AitAgent*" /disable
?schtasks /Change /TN "\Microsoft\Windows\Microsoft*" /disable
:: PcaPatchDbTask - Updates compatibility database
schtasks /Change /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" /disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
:: StartupAppTask - Scans startup entries and raises notification to the user if there are too many startup entries.
schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /disable
:: MareBackup - Gathers Win32 application data for App Backup scenario
schtasks /Change /TN "\Microsoft\Windows\Application Experience\MareBackup" /disable
:: Cleans up each package's unused temporary files.
rem schtasks /Change /TN "\Microsoft\Windows\ApplicationData\CleanupTemporaryState" /disable
:: Performs maintenance for the Data Sharing Service.
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /disable
:: This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program.
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /disable
?schtasks /Change /TN "\Microsoft\Windows\BthSQM*" /disable
:: License Validation - Windows Store legacy license migration task
schtasks /Change /TN "\Microsoft\Windows\Clip\License Validation" /disable
schtasks /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable
:: Consolidator - If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft.
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable
:: The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft.  The information received is used to help improve the reliability, stability, and overall functionality of USB in Windows.  If the user has not consented to participate in Windows CEIP, this task does not do anything.
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable
?schtasks /Change /TN "\Microsoft\Windows\KernelCeipTask*" /disable
?schtasks /Change /TN "\Microsoft\Windows\Uploader*" /disable
:: Microsoft-Windows-DiskDiagnosticDataCollector - The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program.
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
:: schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" /disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /disable
:: Property Definition Sync - Synchronizes the File Classification Infrastructure taxonomy on the computer with the resource property definitions stored in Active Directory Domain Services.
schtasks /Change /TN "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync" /disable
:: TempSignedLicenseExchange - Exchanges temporary preinstalled licenses for Windows Store licenses.
rem schtasks /Change /TN "\Microsoft\Windows\License Manager\TempSignedLicenseExchange" /disable
:: Location Notification
schtasks /Change /TN "\Microsoft\Windows\Location\Notifications" /disable
schtasks /Change /TN "\Microsoft\Windows\Location\WindowsActionDialog" /disable
:: Measures a system's performance and capabilities
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\Cellular" /disable
:: This task shows various Map related toasts
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /disable
:: This task checks for updates to maps which you have downloaded for offline use. Disabling this task will prevent Windows from notifying you of updated maps.
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable
:: Schedules a memory diagnostic in response to system events.
:: System Sounds User Mode Agent
schtasks /Change /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" /disable
:: This task gathers information about the Trusted Platform Module (TPM), Secure Boot, and Measured Boot.
schtasks /Change /TN "\Microsoft\Windows\PI\Sqm-Tasks" /disable
:: This task analyzes the system looking for conditions that may cause high energy use.
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable
:: This service manages Apps that are pushed to the device from the Microsoft Store App running on other devices or the web.
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration" /disable
:: Checks group policy for changes relevant to Remote Assistance
schtasks /Change /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\BackgroundUploadTask" /disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\NetworkStateChangeTask" /disable
:: 
?schtasks /Change /TN "\Microsoft\Windows\BackupTask*" /disable
:: Initializes Family Safety monitoring and enforcement.
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable
:: Synchronizes the latest settings with the Microsoft family features service.
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefreshTask" /disable
:: Downloads a backup of your synced theme images
schtasks /Change /TN "\Microsoft\Windows\Shell\ThemesSyncedImageDownload" /disable
schtasks /Change /TN "\Microsoft\Windows\Shell\UpdateUserPictureTask" /disable
:: Keeps the search index up to date
schtasks /Change /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /disable
schtasks /Change /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask" /disable
:: Enable susbscription license acquisition
schtasks /Change /TN "\Microsoft\Windows\Subscription\EnableLicenseAcquisition" /disable
:: Susbscription license acquisition
schtasks /Change /TN "\Microsoft\Windows\Subscription\LicenseAcquisition" /disable
:: Windows Error Reporting task to process queued reports.
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
:: Register this computer if the computer is already joined to an Active Directory domain.
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Automatic-Device-Join" /disable
:: Sync device attributes to Azure Active Directory.
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Device-Sync" /disable
:: Performs recovery check.
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Recovery-Check" /disable
:: This task will automatically upload a roaming user profile's registry hive to its network location.
schtasks /Change /TN "\Microsoft\Windows\User Profile Service\HiveUploadTask" /disable


:: Removing Telemetry and other unnecessary services:
:: Connected User Experience and Telemetry component, also known as the Universal Telemetry Client (UTC)...
sc stop DiagTrack
sc delete DiagTrack
:: WAP Push Message Routing Service... Device Management Wireless Application Protocol (WAP) Push message Routing Service — This service is another service that helps to collect and send user data to Microsoft.
sc stop dmwappushservice
sc delete dmwappushservice
:: Windows Error Reporting Service Description: Allows errors to be reported when programs stop working or responding ...
sc stop WerSvc
sc delete WerSvc
:: Synchronize mail, contacts, calendar and various other user data...
sc stop OneSyncSvc
:: Preventing Windows from re-enabling Telemetry services...
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1

:: System TuneUp
:: Optimize prefetch parameters to improve Windows boot-up speed
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d 2
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d 2
:: Reduce Application idlesness at closing to improve shutdown process
reg delete "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout"
reg add "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout" /t REG_SZ /d "4000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000"
reg add "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout" /t REG_SZ /d "3000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout" /t REG_SZ /d "10000"
:: Enable optimization feature to improve Windows boot-up speed (HDD only)
reg add "HKLM\Software\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "y"
:: System Stability
:: Disable automatical reboot when system encounters blue screen
reg add "HKLM\System\ControlSet001\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
:: Disable registry modification from a remote computer
reg add "HKLM\System\ControlSet001\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
:: Set Windows Explorer components to run in separate processes avoiding system conflicts
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "DesktopProcess" /t REG_DWORD /d 1
:: Close frozen processes to avoid system crashes
reg add "HKCU\Control Panel\Desktop" /f /v "AutoEndTasks" /t REG_SZ /d "1"
:: System Speedup
:: Remove the word "shortcut" from the shortcut icons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "link" /t REG_BINARY /d "00000000"
:: Optimize Windows Explorer so that it can automatically restart after an exception occurs to prevent the system from being unresponsive.

:: Optimize the visual effect of the menu and list to improve the operating speed of the system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
:: Optimize refresh policy of Windows file list - DFS Share Refresh Issue - https://wiki.ledhed.net/index.php/DFS_Share_Refresh_Issue
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoSimpleNetIDList" /t REG_DWORD /d 1
:: Speed up display speed of Taskbar Window Previews.
reg add "HKCU\Control Panel\Mouse" /f /v "MouseHoverTime" /t REG_SZ /d "100"
:: Speed up Aero Snap to make thumbnail display faster.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ExtendedUIHoverTime" /t REG_DWORD /d "0"
:: Optimized response speed of system display.
reg add "HKCU\Control Panel\Desktop" /f /v "MenuShowDelay" /t REG_SZ /d 0
:: Increase system icon cache and speed up desktop display.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "Max Cached Icons" /t REG_SZ /d 4096
:: Boost the response speed of foreground programs.
reg add "HKCU\Control Panel\Desktop" /f /v "ForegroundLockTimeout" /t REG_DWORD /d 0
:: Boost the display speed of Aero Peek.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "DesktopLivePreviewHoverTime" /t REG_DWORD /d 0
:: Disable memory pagination and reduce disk 1/0 to improve application performance. {Option may be ignored if physical memory is <1 GB)
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
:: Optimize processor performance for execution of applications, games, etc. {Ignore if server}
reg add "HKLM\System\ControlSet001\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
:: Close animation effect when maximizing or minimizing a window to speed up the window response.
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /t REG_SZ /d "0"
:: Optimize disk I/O while CPU is idle (HDD only)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "1"
:: Disable the "Autoplay" feature on drives to avoid virus infection/propagation.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "221"
:: Optimize disk 1/0 subsystem to improve system performance.
reg add "HKLM\System\ControlSet001\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
:: Optimize the file system to improve system performance.
reg delete "HKLM\System\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg delete "HKLM\System\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg add "HKLM\System\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
reg add "HKLM\System\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
:: Optimize front end components (dialog box, menus, etc.) appearance to improve system performance.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
:: Optimize memory default settings to improve system performance.
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
:: Disable the debugger to speed up error processing.
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AeDebug" /f /v "Auto" /t REG_SZ /d 0
:: Disable screen error reporting to improve system performance.
reg add "HKLM\Software\Microsoft\PCHealth\ErrorReporting" /f /v "ShowUI" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PCHealth\ErrorReporting" /f /v "DoReport" /t REG_DWORD /d 0
:: Network Speedup
:: Optimize LAN connection.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "nonetcrawling" /t REG_DWORD /d 1
:: Optimize DNS and DNS parsing speed.
reg add "HKLM\System\ControlSet001\Services\Dnscache\Parameters" /f /v "maxnegativecachettl" /t REG_DWORD /d 0
reg add "HKLM\System\ControlSet001\Services\Dnscache\Parameters" /f /v "maxcachettl" /t REG_DWORD /d "10800"
reg add "HKLM\System\ControlSet001\Services\Dnscache\Parameters" /f /v "maxcacheentryttllimit" /t REG_DWORD /d "10800"
reg add "HKLM\System\ControlSet001\Services\Dnscache\Parameters" /f /v "netfailurecachetime" /t REG_DWORD /d "0"
reg add "HKLM\System\ControlSet001\Services\Dnscache\Parameters" /f /v "negativesoacachetime" /t REG_DWORD /d "0"
reg add "HKLM\System\CurrentControlSet\Services\Dnscache\Parameters" /f /v "maxnegativecachettl" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\Dnscache\Parameters" /f /v "maxcachettl" /t REG_DWORD /d "10800"
reg add "HKLM\System\CurrentControlSet\Services\Dnscache\Parameters" /f /v "maxcacheentryttllimit" /t REG_DWORD /d "10800"
reg add "HKLM\System\CurrentControlSet\Services\Dnscache\Parameters" /f /v "netfailurecachetime" /t REG_DWORD /d "0"
reg add "HKLM\System\CurrentControlSet\Services\Dnscache\Parameters" /f /v "negativesoacachetime" /t REG_DWORD /d "0"
:: Optimize Ethernet card performance.
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
:: Optimize network forward ability to improve network performance.
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
:: Optimize network settings to improve communication performance.
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
:: Optimize WINS name query time to improve data transfer speed.
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
:: Improve TCP/IP performance through automatic detection of "black holes" in routing at Path MTU Discovery technique.
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
:: Optimize TTL {Time To Live) settings to improve network performance.
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
:: SSD optimize
:: Disable drive defrag system on boot to extend lifespan of SSD.
reg add "HKLM\Software\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "n"
:: Disable auto defrag when idle to extend lifespan of SSD.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "0"
:: Disable prefetch parameters to extend lifespan of SSD.
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
:: Enable TRIM function to improve working performance of SSD.

taskkill /f /im explorer.exe

powershell.exe -ExecutionPolicy Bypass -File WinClean.ps1

:: Update all installed programs
winget upgrade --all --silent --force

:: Run Disk Cleanup - Runs Disk Cleanup on Drive C: and removes old Windows Updates.
cleanmgr.exe /d C: /VERYLOWDISK
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

:: Verify System Files
sfc /scannow
shutdown -r /t 0
