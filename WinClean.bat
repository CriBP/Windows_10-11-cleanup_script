cls
msg "%username%" Please make sure you: `Read_First.txt
Notepad "`Read_First.txt"

Echo Rename C: Drive to Windows-OS
label C: Windows-OS

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
:: Echo Rename computer to Work-PC
:: wmic computersystem rename Work-PC

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
:: Critical battery action: No action is taken when the critical battery level is reached.
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 0 

Echo Change to Dark Theme:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "AppsUseLightTheme" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "SystemUsesLightTheme" /t REG_DWORD /d 0
reg add "HKCU\Control Panel\Colors" /f /v "Background" /t REG_SZ /d "0 0 0"
reg add "HKCU\Control Panel\Desktop" /f /v "WallPaper" /t REG_SZ /d "C:\Windows\web\wallpaper\Windows\img19.jpg"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "AppsUseLightTheme" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "ColorPrevalence" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "EnableTransparency" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "SystemUsesLightTheme" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentColorMenu" /t REG_BINARY /d ff59544a
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentPalette" /t REG_BINARY /d "D6 E0 E1 00 9E AB AE 00 61 6F 75 00 4A 54 59 00 3F 48 4D 00 25 2B 32 00 0D 11 18 00 00 B7 C3 00"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "StartColorMenu" /t REG_BINARY /d ff4d483f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /f /v "BackgroundType" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "AccentColor" /t REG_BINARY /d ff59544a
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "ColorizationAfterglow" /t REG_BINARY /d c44a5459
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "ColorizationColor" /t REG_BINARY /d c44a5459
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "ColorPrevalence" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "EnableWindowColorization" /t REG_DWORD /d 1

Echo Temporary stop Windows Defender since it will block removal of Microsoft Telemetry, and Activity Reporting:
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 1
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring $true
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%UserProfile%\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath 'D:\Microsoft\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemRoot%\System32\drivers\etc\hosts'"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1

:: Created by: Shawn Brink on: December 14th 2017; Tutorial: https://www.tenforums.com/tutorials/100341-enable-disable-collect-activity-history-windows-10-a.html
Echo Disable Collect Activity History...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /f /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0

Echo Transfer Hosts File:
copy /D /V /Y hosts %SystemRoot%\System32\drivers\etc\hosts

:: Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016
:: Tutorial: http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /f /v "GlobalUserDisabled" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /f /v "Value" /t REG_SZ /d "Deny"
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /f /v "VoiceActivationOn" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /f /v "ModelDownloadAllowed" /t REG_DWORD /d 0

:: Created by: Shawn Brink on: April 27th 2017; Tutorial: https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html
Echo "Turn Off Website Access of Language List."
reg add "HKCU\Control Panel\International\User Profile" /f /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1

Echo Settings » privacy » general » app permissions: "Setting App Permissions."
:: Next statements will deny access to the following apps under Privacy - - Setting anyone of these back to allow allows toggle functionality
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /f /v "Value" /t REG_SZ /d Deny
::  Disable app diag info about your other apps
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access calendar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access other devices
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access your file system
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access messaging
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access your contacts
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access Documents
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder" /f /v "Value" /t REG_SZ /d Deny
::  Do not Allow apps to access email 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access microphone
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /f /v "Value" /t REG_SZ /d Allow
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access call history
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access Pictures
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /f /v "Value" /t REG_SZ /d Deny
::  Do Not allow apps to access radio
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access Account Information
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access tasks
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /f /v "Value" /t REG_SZ /d Deny
::  Do not allow apps to access Notifications
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /f /v "Value" /t REG_SZ /d Deny
::  do not allow apps to access Videos
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /f /v "Value" /t REG_SZ /d Deny
::  App access turn off camera
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /f /v "Value" /t REG_SZ /d Allow
::  App access turn off WIFI
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect" /f /v "Value" /t REG_SZ /d Deny

Echo Settings » privacy » general » windows permissions "Setting General Windows Permissions."
:: From https://admx.help/HKLM/SOFTWARE/Policies/Microsoft/Windows/AppPrivacy
:: Windows apps access user movements while running in the background
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessBackgroundSpatialPerception" /t REG_DWORD /d 2
:: Windows apps activate with voice while the system is locked
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoiceAboveLock" /t REG_DWORD /d 2
:: Windows apps activate with voice
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoice" /t REG_DWORD /d 2
:: Windows apps access an eye tracker device
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGazeInput" /t REG_DWORD /d 2
:: Windows apps access diagnostic information about other apps
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d 2
:: Windows apps run in the background
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsRunInBackground" /t REG_DWORD /d 2
:: Windows apps access trusted devices
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTrustedDevices" /t REG_DWORD /d 2
:: Windows apps access Tasks
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTasks" /t REG_DWORD /d 2
:: Windows apps communicate with unpaired devices
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2
:: Windows apps control radios
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessRadios" /t REG_DWORD /d 2
:: Windows apps make phone calls
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessPhone" /t REG_DWORD /d 2
:: Windows apps access notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessNotifications" /t REG_DWORD /d 2
:: Windows apps access motion
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMotion" /t REG_DWORD /d 2
:: Windows apps access the microphone
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMicrophone" /t REG_DWORD /d 0
:: Windows apps access messaging
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMessaging" /t REG_DWORD /d 2
:: Windows apps access location
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessLocation" /t REG_DWORD /d 2
:: Windows apps turn off the screenshot border
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureWithoutBorder" /t REG_DWORD /d 2
:: Windows apps take screenshots of various windows or displays
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureProgrammatic" /t REG_DWORD /d 2
:: Windows apps access email
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessEmail" /t REG_DWORD /d 2
:: Windows apps access contacts
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessContacts" /t REG_DWORD /d 2
:: Windows apps access the camera
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCamera" /t REG_DWORD /d 0
:: Windows apps access call history
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2
:: Windows apps access the calendar
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCalendar" /t REG_DWORD /d 2
:: Windows apps access account information
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 2

Echo "Disable App Launch Tracking."
:: Created by: Shawn Brink; Created on: January 3, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-app-launch-tracking-in-windows-11.3727/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Start_TrackProgs" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1

Echo "Turn Off Suggested Content in Settings."
:: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-suggested-content-in-settings-in-windows-11.3791/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0
:: To Turn Off App Suggestions in Start
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-88000326Enabled" /t REG_DWORD /d 0
:: Disable Start Menu Suggestions
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0
:: To Disable Automatically Installing Suggested Apps
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "FeatureManagementEnabled" /t REG_DWORD /d 0
:: Disable Spotlight
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SlideshowEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SoftLandingEnabled" /t REG_DWORD /d 0

Echo Disabling Windows Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "DatabaseMigrationCompleted" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "ToastEnabled" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoCloudApplicationNotification" /t REG_DWORD /d 1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0

Echo settings » privacy » general » let apps use my ID ...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /f /v "DisabledByGroupPolicy" /t REG_DWORD /d 1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Id"

Echo Turn Off Personal Inking and Typing Dictionary
:: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-personal-inking-and-typing-dictionary-in-windows-11.5564/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization" /f /v "Value" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /f /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /f /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /f /v "HarvestContacts" /t REG_DWORD /d 0

Echo Uninstall OneDrive
set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
Echo Closing OneDrive process.
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
Echo Removing OneDrive leftovers.
rd "%USERPROFILE%\OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S
Echo Removing OneDrive from the Explorer Side Panel.
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
del /Q /F "%localappdata%\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe"
del /Q /F "%UserProfile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

:: Disable Windows Search Box (Created by: Shawn Brink on: May 4th 2019 Tutorial: https://www.tenforums.com/tutorials/2854-hide-show-search-box-search-icon-taskbar-windows-10-a.html
Echo Disable Windows Search Box... and web search in the search box
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "BingSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlStatus" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlSecondaryStatus" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "SearchboxTaskbarMode" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v "SearchOnTaskbarMode" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1

Echo Enable Admin Shares...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /f /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1

Echo Remove the Limit local account use of blank passwords to console logon only...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /f /v "LimitBlankPasswordUse" /t REG_DWORD /d 0

Echo Enable Local Security Authority Protection...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /f /v RunAsPPL /t REG_DWORD /d 1

Echo Disable Windows Feedback...
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /f /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /f /v "PeriodInNanoSeconds"
reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f /v "Start" /t REG_DWORD /d 0
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
echo y|cacls  C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl  /d SYSTEM
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
:: reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "EnableSmartScreen" /t REG_DWORD /d 0

Echo Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCortana" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"  /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d  "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search  and Cortana  application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

Echo Turn off Windows Error reporting...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1

Echo No license checking... removed now
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\SOFTWARE Protection Platform" /f /v "NoGenTicket" /t REG_DWORD /d 1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\SOFTWARE Protection Platform" /f

Echo Disable app access to Voice activation...
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d 0

Echo Disable sync...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSync" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 

Echo No Windows Tips...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v "DisableSoftLanding" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /f /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d 0

Echo Disabling live tiles...
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoTileApplicationNotification" /t REG_DWORD /d 1

Echo Stop auto-installation of Microsoft Edge using Registry 
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /f /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1

Echo settings » privacy » general » speech, inking, typing
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /f /v "AllowLinguisticDataCollection" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /f /v "Enabled" /t REG_DWORD /d 0

Echo Disables Autoplay and Turn Off AutoRun in Windows
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /f /v "DisableAutoplay" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0xFF
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0xFF

Echo Disables Meet Now Chat and Microsoft Teams; Remove Chat from the taskbar in Windows 11
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "com.squirrel.Teams.Teams"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarMn /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3

Echo Turn off News and Interests
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /f /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarDa" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /f /v "EnableFeeds" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Dsh" /f /v "AllowNewsAndInterests" /t REG_DWORD /d 0
>nul powershell -noprofile -executionpolicy bypass -command "Get-AppxPackage -Name *WebExperience* | Foreach {Remove-AppxPackage $_.PackageFullName}"
>nul powershell -noprofile -executionpolicy bypass -command "Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match 'WebExperience' } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }"

Echo Turn off Suggest Ways I can finish setting up my device
:: Created by: Shawn Brink on: July 31, 2019; Tutorial: https://www.tenforums.com/tutorials/137645-turn-off-get-even-more-out-windows-suggestions-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /f /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0

Echo Turn off Game Mode
:: Created by: Shawn Brink on: January 27th 2016; Updated on: November 6th 2017; Tutorial: https://www.tenforums.com/tutorials/75936-turn-off-game-mode-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /f /v "AllowAutoGameMode" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /f /v "AutoGameModeEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /f /v "AppCaptureEnabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f /v "AllowGameDVR" /t REG_DWORD /d 0

Echo Turn off Cloud Content Search for Microsoft Account
:: Created by: Shawn Brink on: September 18, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-cloud-content-search-in-windows-11.5378/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsAADCloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCloudSearch" /t REG_DWORD /d 0

Echo Turn Off Device Search History
:: Created by: Shawn Brink on: September 18, 2020; Tutorial: https://www.tenforums.com/tutorials/133365-turn-off-device-search-history-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0

Echo Remove Duplicate Drives in Navigation Pane of File Explorer
:: Created by: Shawn Brink: Tutorial: https://www.tenforums.com/tutorials/4675-drives-navigation-pane-add-remove-windows-10-a.html; https://www.winhelponline.com/blog/drives-listed-twice-explorer-navigation-pane/
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1

Echo Disable Pin Store to Taskbar for All Users
:: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/47742-store-enable-disable-pin-taskbar-windows-8-10-a.html; https://www.elevenforum.com/t/enable-or-disable-show-pinned-items-on-taskbar-in-windows-11.3650/
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1

Echo Choose which folders appear on start
:: To force a pinned folder to be visible, set the corresponding registry values to 1 (both values must set); to force it to be hidden, set the "_ProviderSet" value to 1 and the other one to 0; to let the user choose "_ProviderSet" value to 0 or delete the values. https://social.technet.microsoft.com/Forums/en-US/dbe85f3d-52a8-4852-a784-7bac64a9fa78/controlling-1803-quotchoose-which-folders-appear-on-startquot-settings?forum=win10itprosetup#3b488a59-cefe-4947-8529-944475c452d5
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDocuments" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDocuments_ProviderSet" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDownloads" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderDownloads_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderFileExplorer" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderFileExplorer_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderMusic" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderMusic_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderNetwork" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderNetwork_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPersonalFolder" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPersonalFolder_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPictures" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderPictures_ProviderSet" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderSettings" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderSettings_ProviderSet" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderVideos" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\start" /f /v "AllowPinnedFolderVideos_ProviderSet" /t REG_DWORD /d 0

Echo Add User's Files Desktop Icon
:: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/6942-desktop-icons-add-remove-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0

:: Created by: Shawn Brink; Created on: April 13th 2018; Tutorial: https://www.tenforums.com/tutorials/108032-hide-show-user-profile-personal-folders-windows-10-file-explorer.html
Echo Hide Unused User's Profile Personal Folders like 3D,Saved Games,Searches
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"

Echo Windows Explorer Tweaks: Hidden Files,Expand to Current
:: Change your Visual Effects Settings: https://www.tenforums.com/tutorials/6377-change-visual-effects-settings-windows-10-a.html
:: 0 = Let Windows choose what’s best for my computer
:: 1 = Adjust for best appearance
:: 2 = Adjust for best performance
:: 3 = Custom ;This disables the following 8 settings:Animate controls and elements inside windows;Fade or slide menus into view;Fade or slide ToolTips into view;Fade out menu items after clicking;Show shadows under mouse pointer;Show shadows under windows;Slide open combo boxes;Smooth-scroll list boxes
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /f /v "VisualFXSetting" /t REG_DWORD /d 3
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "90 32 07 80 10 00 00 00"
:: Open File Explorer to: This PC
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d 1
:: Show hidden files, folders, and drives
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Hidden" /t REG_DWORD /d 1
:: Hide protected operating system files (Recommended)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ShowSuperHidden" /t REG_DWORD /d 0
:: Hide Desktop icons
:: reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideIcons" /t REG_DWORD /d 1
:: Hide extensions for known file types
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideFileExt" /t REG_DWORD /d 0
:: Navigation pane: Expand to open folder
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneExpandToCurrentFolder" /t REG_DWORD /d 1
:: Navigation pane: Show all folders
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneShowAllFolders" /t REG_DWORD /d 1

Echo Change Visual Effects Settings for Best Performance and best looking
:: Animate controls and elements inside windows
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "90 32 07 80 10 00 00 00"
:: Animate windows when minimizing and maximizing
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /d 0
:: Animations in the taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
:: Enable Peek
:: Created by: Shawn Brink; Created on: April 14th 2016; Updated on: May 23rd 2019; Tutorial: https://www.tenforums.com/tutorials/47266-turn-off-peek-desktop-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v DisablePreviewDesktop /t REG_DWORD /d 1
:: Fade or slide menus into view
:: Fade or slide ToolTips into view
:: Fade out menu items after clicking
:: Save taskbar thumbnail previews
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
:: Show shadows under mouse pointer
:: Show shadows under windows
:: Show thumbnails instead of icons
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "IconsOnly" /t REG_DWORD /d 0
:: Show translucent selection rectangle
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
:: Show window contents while dragging
reg add "HKCU\Control Panel\Desktop" /f /v "DragFullWindows" /d 0
:: Slide open combo boxes
:: Smooth edges of screen fonts
reg add "HKCU\Control Panel\Desktop" /f /v "FontSmoothing" /t REG_DWORD /d 2
:: Smooth-scrool list boxes
:: Use drop shadows for icon labels on the desktop
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewShadow" /t REG_DWORD /d 0
:: Move the Start button to the Left Corner 
Echo Move the Start button to the Left Corner:
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0
taskkill /f /im explorer.exe
start explorer.exe

Echo Disable Remote Assistance
:: Created by: Shawn Brink on: August 27th 2018:: Tutorial: https://www.tenforums.com/tutorials/116749-enable-disable-remote-assistance-connections-windows.html
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0
netsh advfirewall firewall set rule group="Remote Assistance" new enable=no

Echo Change to Small memory dump
:: Memory dump file options for Windows: https://support.microsoft.com/en-us/topic/b863c80e-fb51-7bd5-c9b0-6116c3ca920f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "CrashDumpEnabled" /d "0x3"

Echo Clear Taskbar Pinned Apps
:: Created by: Shawn Brink on: December 3rd 2014: Tutorial: https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned"
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
:: reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /F
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

:: Created by: Shawn Brink - Restore Windows Photo Viewer # Created on: August 8th 2015 # Updated on: August 5th 2018  #  Tutorial: https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html
Echo "Restore Windows Photo Viewer" ; Created by: Shawn Brink ; Created on: August 8th 2015 ; Updated on: August 5th 2018
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
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /f /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /f /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".cr2" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff"
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /f /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff"

Echo Remove sounds - "Change to no sounds theme"
reg add "HKCU\AppEvents\Schemes\Apps\.Default\.Default\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\AppGPFault\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\CCSelect\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ChangeTheme\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Close\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Maximize\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MenuCommand\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MenuPopup\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Minimize\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm01.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm10\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm10.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm2\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm02.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm3\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm03.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm4\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm04.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm5\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm05.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm6\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm06.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm7\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm07.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm8\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm08.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Alarm9\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Alarm09.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring01.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call10\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring10.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call2\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring02.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call3\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring03.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call4\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring04.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call5\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring05.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call6\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring06.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call7\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring07.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call8\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring08.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Looping.Call9\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Ring09.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Open\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\PrintComplete\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\RestoreDown\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\RestoreUp\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ShowBand\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemExit\.Current" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsLogoff\.Current" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Windows Logon.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsUnlock\.Current" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\media\Windows Unlock.wav" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\MoveMenuItem\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\Explorer\SecurityBand\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" /ve /t REG_SZ /d "" /f
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" /ve /t REG_SZ /d "" /f

Echo Remove Xbox...
sc delete XblAuthManager
sc delete XblGameSave
sc delete XboxNetApiSvc
sc delete XboxGipSvc
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disable

Echo Remove Maps...
sc delete MapsBroker
sc delete lfsvc
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable

Echo Removing Telemetry and other unnecessary services...
sc stop DiagTrack
sc stop dmwappushservice
Echo Connected User Experience and Telemetry component, also known as the Universal Telemetry Client (UTC)...
sc delete DiagTrack
Echo WAP Push Message Routing Service...
sc delete dmwappushservice
Echo Windows Error Reporting Service Description: Allows errors to be reported when programs stop working or responding ...
sc delete WerSvc
Echo This service synchronizes mail, contacts, calendar and various other user data...
:: sc delete OneSyncSvc
Echo Service supporting text messaging and related functionality...
:: sc delete MessagingService
Echo Problem Reports and Solutions Control Panel Support...
sc delete wercplsupport
Echo Windows Live Sign-In Assistant service...
:: sc delete wlidsvc
Echo Windows Insider Service Provides infrastructure support for the Windows Insider Program...
sc delete wisvc
Echo Retail Demo experience, for retail store staff who want to demo it to customers...
sc delete RetailDemo
Echo Microsoft (R) Diagnostics Hub Standard Collector Service, this service collects real time ETW events and processes them...
sc delete diagnosticshub.standardcollector.service

Echo Preventing Windows from re-enabling these services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1

taskkill /f /im explorer.exe

>nul powershell.exe -ExecutionPolicy Bypass -File WinClean.ps1

Echo Enable Windows Defender Realtime Monitoring:
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 0
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring $false
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f /v "DisableRealtimeMonitoring"

Echo Uninstall Microsoft Edge
del /Q /F "%UserProfile%\Desktop\Microsoft Edge.lnk"
cd %ProgramFiles(x86)%\Microsoft\Edge\Application\
Echo Please change Directory to the "installation number"\installer and run setup.exe --uninstall --system-level --verbose-logging --force-uninstall
dir
