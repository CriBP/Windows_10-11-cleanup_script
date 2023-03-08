cls
msg "%username%" Please make sure you: `Read_First.txt
Notepad "`Read_First.txt"

Echo Rename C: Drive to WinX-OS
label C: Windows-OS

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
Echo Rename computer to Work-PC
:: wmic computersystem rename Work-PC

:: Move the Start button to the Left Corner 
Echo Move the Start button to the Left Corner:
>nul 2>&1 reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0

Echo Change to Dark Theme:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v "BackgroundType" /t REG_DWORD /d 1 /f
reg add "HKCU\Control Panel\Colors" /v "Background" /t REG_SZ /d "0 0 0" /f
reg add "HKCU\Control Panel\Desktop" /v "WallPaper" /t REG_SZ /d "" /f

Echo Begin Cleanup Script for Windows 10
Echo Temporary stop Windows Defender since it will block removal of Microsoft Telemetry, and Activity Reporting:
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 1
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring $true
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%UserProfile%\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemRoot%\System32\drivers\etc\hosts'"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

:: Created by: Shawn Brink on: December 14th 2017; Tutorial: https://www.tenforums.com/tutorials/100341-enable-disable-collect-activity-history-windows-10-a.html
Echo Disable Collect Activity History...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f

Echo Transfer Hosts File:
copy /D /V /Y hosts %SystemRoot%\System32\drivers\etc\hosts

Echo Uninstall OneDrive
set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
Echo Closing OneDrive process.
taskkill /f /im OneDrive.exe > NUL 2>&1
ping 127.0.0.1 -n 5 > NUL 2>&1
if exist %x64% (
%x64% /uninstall
) else (
%x86% /uninstall
)
ping 127.0.0.1 -n 5 > NUL 2>&1
%SystemRoot%\System32\OneDriveSetup.exe /uninstall > NUL 2>&1
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall > NUL 2>&1
Echo Removing OneDrive leftovers.
rd "%USERPROFILE%\OneDrive" /Q /S > NUL 2>&1
rd "C:\OneDriveTemp" /Q /S > NUL 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S > NUL 2>&1
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S > NUL 2>&1
Echo Removing OneDrive from the Explorer Side Panel.
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1
del /Q /F "%localappdata%\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe" > NUL 2>&1
del /Q /F "%UserProfile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" > NUL 2>&1

:: Disable Windows 10 Search Box (Created by: Shawn Brink on: May 4th 2019 Tutorial: https://www.tenforums.com/tutorials/2854-hide-show-search-box-search-icon-taskbar-windows-10-a.html
Echo Disable Windows 10 Search Box...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "SearchboxTaskbarMode" /T REG_DWORD /D 0 /F

Echo Enable Admin Shares...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

Echo Disable Windows Feedback...
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f > NUL 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f

Echo Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"  /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d  "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search  and Cortana  application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

Echo Turn off Windows Error reporting...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f

Echo Remove the Limit local account use of blank passwords to console logon only...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f

Echo No license checking... removed now
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f > NUL 2>&1

Echo Disable app access to Voice activation...
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d 0 /f

Echo Disable sync...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1 /f
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 

Echo No Windows Tips...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d 0 /f

Echo Stop auto-installation of Microsoft Edge using Registry 
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f

Echo Remove Xbox...
sc delete XblAuthManager > NUL 2>&1
sc delete XblGameSave > NUL 2>&1
sc delete XboxNetApiSvc > NUL 2>&1
sc delete XboxGipSvc > NUL 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f > NUL 2>&1
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f

Echo Removing Telemetry and other unnecessary services...
sc stop DiagTrack
sc stop dmwappushservice
Echo Connected User Experience and Telemetry component, also known as the Universal Telemetry Client (UTC)...
sc delete DiagTrack > NUL 2>&1
Echo WAP Push Message Routing Service...
sc delete dmwappushservice > NUL 2>&1
Echo Windows Error Reporting Service Description: Allows errors to be reported when programs stop working or responding ...
sc delete WerSvc > NUL 2>&1
Echo This service synchronizes mail, contacts, calendar and various other user data...
sc delete OneSyncSvc > NUL 2>&1
Echo Service supporting text messaging and related functionality...
sc delete MessagingService > NUL 2>&1
Echo Problem Reports and Solutions Control Panel Support...
sc delete wercplsupport > NUL 2>&1
Echo Windows Live Sign-In Assistant service...
sc delete wlidsvc > NUL 2>&1
Echo Windows Insider Service Provides infrastructure support for the Windows Insider Program...
sc delete wisvc > NUL 2>&1
Echo Retail Demo experience, for retail store staff who want to demo it to customers...
sc delete RetailDemo > NUL 2>&1
Echo Microsoft (R) Diagnostics Hub Standard Collector Service, this service collects real time ETW events and processes them...
sc delete diagnosticshub.standardcollector.service > NUL 2>&1
sc delete DiagTracksc > NUL 2>&1
sc delete dmwappushserviceecho > NUL 2>&1

Echo Remove Maps...
sc delete MapsBroker > NUL 2>&1
sc delete lfsvc > NUL 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable

Echo Preventing Windows from re-enabling these services...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1

Echo settings » privacy » general » let apps use my ID ...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Id" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f

Echo settings » privacy » general » let websites provide locally ...
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1 /f

Echo settings » privacy » general » speech, inking, typing
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v "AllowLinguisticDataCollection" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f

Echo Disables Autoplay and Turn Off AutoRun in Windows 10
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0xFF /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0xFF /f

Echo Disables Meet Now
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f

Echo Turn off News and Interests
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink on: July 31, 2019; Tutorial: https://www.tenforums.com/tutorials/137645-turn-off-get-even-more-out-windows-suggestions-windows-10-a.html
Echo Turn off Suggest Ways I can finish setting up my device
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink on: January 27th 2016; Updated on: November 6th 2017; Tutorial: https://www.tenforums.com/tutorials/75936-turn-off-game-mode-windows-10-a.html
Echo Turn off Game Mode
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink on: September 18, 2020; Tutorial: https://www.tenforums.com/tutorials/88731-enable-disable-show-cloud-content-search-results-windows-10-a.html
Echo Turn off Cloud Content Search for Microsoft Account
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink on: September 18, 2020; Tutorial: https://www.tenforums.com/tutorials/133365-turn-off-device-search-history-windows-10-a.html
Echo Turn Off Device Search History
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink: Tutorial: https://www.tenforums.com/tutorials/4675-drives-navigation-pane-add-remove-windows-10-a.html; https://www.winhelponline.com/blog/drives-listed-twice-explorer-navigation-pane/
Echo Remove Duplicate Drives in Navigation Pane of File Explorer in Windows 10
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1 /f

:: Created by: Shawn Brink; Created on: April 18th 2016; Tutorial: http://www.tenforums.com/tutorials/47742-store-enable-disable-pin-taskbar-windows-8-10-a.html
Echo Disable Pin Store to Taskbar for All Users
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1 /f

Echo Disables web search in the search box
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
echo y|cacls  C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl  /d SYSTEM

Echo Disable Hybernation
powercfg -h off
Echo Enable High Performance Power Scheme
powercfg /l
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /x monitor-timeout-ac 10
powercfg /x monitor-timeout-dc 10
powercfg /x disk-timeout-ac 20
powercfg /x disk-timeout-dc 20
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 15

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f

:: To force a pinned folder to be visible, set the corresponding registry values to 1 (both values must set); to force it to be hidden, set the "_ProviderSet" value to 1 and the other one to 0; to let the user choose "_ProviderSet" value to 0 or delete the values.﻿﻿
Echo Choose which folders appear on start
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderFileExplorer" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderFileExplorer_ProviderSet" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderSettings" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderSettings_ProviderSet" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderDocuments" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderDocuments_ProviderSet" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderDownloads" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderDownloads_ProviderSet" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderMusic" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderMusic_ProviderSet" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderPictures" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderPictures_ProviderSet" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderVideos" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderVideos_ProviderSet" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderNetwork" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderNetwork_ProviderSet" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderPersonalFolder" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /v "AllowPinnedFolderPersonalFolder_ProviderSet" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/6942-desktop-icons-add-remove-windows-10-a.html
Echo Add User's Files Desktop Icon
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink; Created on: April 13th 2018; Tutorial: https://www.tenforums.com/tutorials/108032-hide-show-user-profile-personal-folders-windows-10-file-explorer.html
Echo Hide Unused User's Profile Personal Folders like 3D,Saved Games,Searches
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /d "Hide" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /d "Hide" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /v "ThisPCPolicy" /d "Hide" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /v "ThisPCPolicy" /d "Hide" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /v "ThisPCPolicy" /d "Hide" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /v "ThisPCPolicy" /d "Hide" /f

Echo Windows Explorer Tweaks: Hidden Files,Expand to Current
Echo Change Visual Effects Settings for Best Performance and best looking
:: Change your Visual Effects Settings: https://www.tenforums.com/tutorials/6377-change-visual-effects-settings-windows-10-a.html
:: 0 = Let Windows choose what’s best for my computer
:: 1 = Adjust for best appearance
:: 2 = Adjust for best performance
:: 3 = Custom ;This disables the following 8 settings:Animate controls and elements inside windows;Fade or slide menus into view;Fade or slide ToolTips into view;Fade out menu items after clicking;Show shadows under mouse pointer;Show shadows under windows;Slide open combo boxes;Smooth-scroll list boxes
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "90 32 07 80 10 00 00 00" /f
:: Open File Explorer to: This PC
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
:: Show hidden files, folders, and drives
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
:: Hide protected operating system files (Recommended)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f
:: Hide Desktop icons
:: reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideIcons" /t REG_DWORD /d 1 /f
:: Hide extensions for known file types
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
:: Navigation pane: Expand to open folder
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneExpandToCurrentFolder" /t REG_DWORD /d 1 /f
:: Navigation pane: Show all folders
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d 1 /f
:: Animate windows when minimizing and maximizing
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /d 0 /f
:: Animations in the taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f
:: Enable Peek
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f
:: Save taskbar thumbnail previews
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f
:: Show translucent selection rectangle
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 0 /f
:: Show thumbnails instead of icons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d 0 /f
:: Show window contents while dragging
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /d 0 /f
:: Smooth edges of screen fonts
reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_DWORD /d 2 /f
:: Use drop shadows for icon labels on the desktop
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 0 /f

:: Created by: Shawn Brink on: August 27th 2018:: Tutorial: https://www.tenforums.com/tutorials/116749-enable-disable-remote-assistance-connections-windows.html
Echo Disable Remote Assistance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remote Assistance" new enable=no

:: Memory dump file options for Windows: https://support.microsoft.com/en-us/topic/b863c80e-fb51-7bd5-c9b0-6116c3ca920f
Echo Change to Small memory dump
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /d "0x3" /f

:: Created by: Shawn Brink on: December 3rd 2014: Tutorial: https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html
Echo Clear Taskbar Pinned Apps
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned"
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
:: reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /F
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

:: Remove Chat from the taskbar in Windows 11
>nul 2>&1 REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarMn /t REG_DWORD /d 0

:: Hide the Chat slider in Windows 11
>nul 2>&1 REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3

:: Hide the Widgets slider
>nul 2>&1 REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarDa /t REG_DWORD /d 0
>nul 2>&1 REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Dsh" /f /v AllowNewsAndInterests /t REG_DWORD /d 0
>nul 2>&1 REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /f /v EnableFeeds /t REG_DWORD /d 0
>nul powershell -noprofile -executionpolicy bypass -command "Get-AppxPackage -Name *WebExperience* | Foreach {Remove-AppxPackage $_.PackageFullName}"
>nul powershell -noprofile -executionpolicy bypass -command "Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match 'WebExperience' } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }"

taskkill /f /im explorer.exe

>nul powershell.exe -ExecutionPolicy Bypass -File WinClean.ps1

Echo Enable Windows Defender Realtime Monitoring:
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 0
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring $false
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /f > NUL 2>&1

Echo Uninstall Microsoft Edge
del /Q /F "%UserProfile%\Desktop\Microsoft Edge.lnk" > NUL 2>&1
cd %ProgramFiles(x86)%\Microsoft\Edge\Application\
Echo Please change Directory to the "installation number"\installer and run setup.exe --uninstall --system-level --verbose-logging --force-uninstall
dir
