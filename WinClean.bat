cls
msg "%username%" Please make sure you: `Read_First.txt
Notepad "`Read_First.txt"

:: Rename C: Drive to Windows-OS
label C: Windows-OS

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
:: Rename computer to Work-PC
rem wmic computersystem rename Work-PC
:: Add comments with :: or REM at beginning, if they are not in the beginning of line, then add & character: your commands here & :: comment

:: Turn Off System Protection for All Drives
:: Created by: Shawn Brink; Created on: December 27, 2021; Tutorial: https://www.elevenforum.com/t/turn-on-or-off-system-protection-for-drives-in-windows-11.3598/
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /f /v "RPSessionInterval" /t REG_DWORD /d "0"
wmic /Namespace:\\root\default Path SystemRestore Call Disable "C:\" & :: C-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "D:\" & :: D-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "E:\" & :: E-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "F:\" & :: F-drive

:: Disable Hybernation
powercfg -h off

:: Clear and Reset Quick Access Folders
del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms"

:: Increase the number of recent files displayed in the task bar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "JumpListItems_Maximum " /t REG_DWORD /d 30

:: Change Recent items List: The folders are defined in the registry under: HKLM\Sofware\Classes\CLSID - CLSID Items in folder:
:: {22877a6d-37a1-461a-91b0-dbda5aaebc99} 	Recent folders
:: {3936E9E4-D92C-4EEE-A85A-BC16D5EA0819} 	Frequent folders
:: {4564b25e-30cd-4787-82ba-39e73a750b14} 	Recent files
:: Since these are already defined, only two things are required for the folders to appear in the Navigation Pane. THe folder needs to be added to the Desktop Namespace by creating a CLSID-named subkey under: HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\Namespace and a DWORD named System.ISPinnedToNamespaceTree with a value of 1 needs to be added to the base key.
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}" /f /v "System.IsPinnedToNamespaceTree" /t REG_DWORD /d "1"
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}" /f /v "LocalizedString" /t REG_SZ /d "Recent files"
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}" /f /ve /t REG_SZ /d "Recent Items Instance Folder"
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}" /f /v "InfoTip" /t REG_SZ /d "Extended list of recent files"
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}" /f /v "System.HideOnDesktopPerUser" /t REG_SZ /d ""
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}\DefaultIcon" /f /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,-117"
reg add "HKCU\SOFTWARE\Classes\CLSID\{4564b25e-30cd-4787-82ba-39e73a750b14}\Instance\InitPropertyBag" /f /v "MaxItems" /t REG_DWORD /d "50"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{4564b25e-30cd-4787-82ba-39e73a750b14}" /f /ve /t REG_SZ /d "Recent files (extended)"
:: A value of '1' hides the icon on the Desktop; a value of `0` displays it.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{4564b25e-30cd-4787-82ba-39e73a750b14}" /t REG_DWORD /d "1"
:: add Recent folders
reg add "HKCU\SOFTWARE\Classes\CLSID\{22877a6d-37a1-461a-91b0-dbda5aaebc99}" /f /ve /t REG_SZ /d "Recent folders"
reg add "HKCU\SOFTWARE\Classes\CLSID\{22877a6d-37a1-461a-91b0-dbda5aaebc99}" /f /v "System.IsPinnedToNamespaceTree" /t REG_DWORD /d "1"
reg add "HKCU\SOFTWARE\Classes\CLSID\{22877a6d-37a1-461a-91b0-dbda5aaebc99}" /f /v "InfoTip" /t REG_SZ /d "Extended list of recent folders"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{22877a6d-37a1-461a-91b0-dbda5aaebc99}" /f /ve /t REG_SZ /d "Recent folders (extended)"
:: A value of '1' hides the icon on the Desktop; a value of `0` displays it.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{22877a6d-37a1-461a-91b0-dbda5aaebc99}" /t REG_DWORD /d "1"
:: Icons Layout
reg add "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" /f /v "IconLayouts" /t REG_BINARY /d "0000000000000000000000000000000003000100010001000c000000000000002c000000000000003a003a007b00350039003000330031004100340037002d0033004600370032002d0034003400410037002d0038003900430035002d003500350039003500460045003600420033003000450045007d003e005c00200000002c000000000000003a003a007b00360034003500460046003000340030002d0035003000380031002d0031003000310042002d0039004600300038002d003000300041004100300030003200460039003500340045007d003e002000200000002c000000000000003a003a007b00340035003600340042003200350045002d0033003000430044002d0034003700380037002d0038003200420041002d003300390045003700330041003700350030004200310034007d003e002000200000002c000000000000003a003a007b00320032003800370037004100360044002d0033003700410031002d0034003600310041002d0039003100420030002d004400420044004100350041004100450042004300390039007d003e002000200000001200000000000000450061007300790073006c0069006400650073002e006c006e006b003e0020007c0000001c000000000000004d00750073006900630020004d0061006b006500720020002800360034002d0042006900740029002e006c006e006b003e0020007c000000290000000000000053004f0055004e004400200046004f00520047004500200041007500640069006f002000530074007500640069006f002000310035002000280078003600340029002e006c006e006b003e0020007c0000001c0000000000000053006f0075006e006400200046006f007200670065002000500072006f002000310030002e0030002e006c006e006b003e0020007c0000001600000000000000560045004700410053002000500072006f002000310039002e0030002e006c006e006b003e0020007c0000001400000000000000560045004700410053002000530074007200650061006d002e006c006e006b003e0020007c0000000f000000000000006400650073006b0074006f0070002e0069006e0069003e0020007c0000000f000000000000006400650073006b0074006f0070002e0069006e0069003e00200020000000010000000000000002000100000000000000000001000000000000000200010000000000000000002200000010000000010000000c0000000000000000000000000000000000000000000000803f0100000000000000004002000000000000004040030000000000000080400400000000000000a0400500000000000000c0400600000000000000e0400700000000000000004108000000000000001041090000000000000020410a0000000000000030410b00"

:: Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Holographic" /f /v "FirstRunSucceeded " /t REG_DWORD /d 0

:: Remove Optional Features - List all Optional Features
dism /Online /Get-Capabilities
:: "Remove Windows Media Player:"
dism /Online /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0
:: "Remove Quick Assist:"
dism /Online /Remove-Capability /CapabilityName:App.Support.QuickAssist~~~~0.0.1.0
:: "Remove Hello Face:"
dism /Online /Remove-Capability /CapabilityName:Hello.Face.18967~~~~0.0.1.0
dism /Online /Remove-Capability /CapabilityName:Hello.Face.Migration.18967~~~~0.0.1.0
:: "Remove Math Recognizer:"
dism /Online /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0
:: Turn off Steps Recorder - Source https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.ApplicationCompatibility::AppCompatTurnOffUserActionRecord
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /f /v "DisableUAR" /t REG_DWORD /d "1"
dism /Online /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0

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
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "AppsUseLightTheme" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "SystemUsesLightTheme" /t REG_DWORD /d 0
reg add "HKCU\Control Panel\Colors" /f /v "Background" /t REG_SZ /d "0 0 0"
reg add "HKCU\Control Panel\Desktop" /f /v "WallPaper" /t REG_SZ /d "C:\Windows\web\wallpaper\Windows\img19.jpg"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "AppsUseLightTheme" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "ColorPrevalence" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "EnableTransparency" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /f /v "SystemUsesLightTheme" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentPalette" /t REG_BINARY /d "98abb6007d8d9600637077004a545900373f42002c3235001f23250000b7c300"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "StartColorMenu" /t REG_DWORD /d "4282531639"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentColorMenu" /t REG_DWORD /d "4284044362"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /f /v "BackgroundType" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "AccentColor" /t REG_DWORD /d "4284044362"
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "ColorizationAfterglow" /t REG_DWORD /d "3293205593"
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "ColorizationColor" /t REG_DWORD /d "3293205593"
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "ColorPrevalence" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "EnableWindowColorization" /t REG_DWORD /d 1

:: Temporary stop Windows Defender since it will block removal of Microsoft Telemetry, and Activity Reporting:
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 1
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring $true
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%UserProfile%\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath 'D:\Microsoft\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemRoot%\System32\drivers\etc\hosts'"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1

:: Quiet down Windows Security stopping unnecessary notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableNotifications" /t REG_DWORD /d "1"
reg add "HKCU\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableWindowsHelloNotifications" /t REG_DWORD /d "1"
reg add "HKCU\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableDynamiclockNotifications" /t REG_DWORD /d "1"

:: Disable Collect Activity History: Created by: Shawn Brink on: December 14th 2017; Tutorial: https://www.tenforums.com/tutorials/100341-enable-disable-collect-activity-history-windows-10-a.html
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /f /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0

:: Transfer Hosts File:
copy /D /V /Y hosts %SystemRoot%\System32\drivers\etc\hosts

:: Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016: Tutorial: http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /f /v "GlobalUserDisabled" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /f /v "Value" /t REG_SZ /d "Deny"
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /f /v "VoiceActivationOn" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /f /v "ModelDownloadAllowed" /t REG_DWORD /d 0

:: Turn Off Website Access of Language List: Created by: Shawn Brink on: April 27th 2017; Tutorial: https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html
reg add "HKCU\Control Panel\International\User Profile" /f /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Language Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Layout Hotkey" /t REG_SZ /d "3"

:: Settings » privacy » general » app permissions: "Setting App Permissions."
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

:: Settings » privacy » general » windows permissions "Setting General Windows Permissions.": From https://admx.help/HKLM/SOFTWARE/Policies/Microsoft/Windows/AppPrivacy
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

:: Disable App Launch Tracking: Created by: Shawn Brink; Created on: January 3, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-app-launch-tracking-in-windows-11.3727/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Start_TrackProgs" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1

:: Turn Off Suggested Content in Settings: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-suggested-content-in-settings-in-windows-11.3791/
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

:: Disabling Windows Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "DatabaseMigrationCompleted" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "ToastEnabled" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoCloudApplicationNotification" /t REG_DWORD /d 1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0

:: Removes 3D Objects from the 'My Computer' submenu in explorer
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f

:: settings » privacy » general » let apps use my ID ...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /f /v "DisabledByGroupPolicy" /t REG_DWORD /d 1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Id"

:: Turn Off Personal Inking and Typing Dictionary: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-personal-inking-and-typing-dictionary-in-windows-11.5564/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization" /f /v "Value" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /f /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /f /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /f /v "HarvestContacts" /t REG_DWORD /d 0

:: Uninstall OneDrive
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

:: Disable Windows Search Box... and web search in the search box Created by: Shawn Brink on: May 4th 2019 Tutorial: https://www.tenforums.com/tutorials/2854-hide-show-search-box-search-icon-taskbar-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "BingSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlStatus" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlSecondaryStatus" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /f /v "SearchboxTaskbarMode" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v "SearchOnTaskbarMode" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1

:: Enable Admin Shares...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /f /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1

:: Remove the Limit local account use of blank passwords to console logon only...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /f /v "LimitBlankPasswordUse" /t REG_DWORD /d 0

:: Enable Local Security Authority Protection...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /f /v RunAsPPL /t REG_DWORD /d 1

:: Disable Windows Feedback...
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /f /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /f /v "PeriodInNanoSeconds"
reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f /v "Start" /t REG_DWORD /d 0
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
echo y|cacls  C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl  /d SYSTEM
rem reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "EnableSmartScreen" /t REG_DWORD /d 0

:: Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCortana" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"  /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d  "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search  and Cortana  application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

:: Turn off Windows Error reporting...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1

:: No license checking... removed now
rem reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\SOFTWARE Protection Platform" /f /v "NoGenTicket" /t REG_DWORD /d 1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\SOFTWARE Protection Platform" /f

:: Disable app access to Voice activation...
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d 0

:: Disable sync...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSync" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 

:: No Windows Tips...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v "DisableSoftLanding" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /f /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d 0

:: Disabling live tiles...
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoTileApplicationNotification" /t REG_DWORD /d 1

:: Stop auto-installation of Microsoft Edge using Registry 
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /f /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1

:: settings » privacy » general » speech, inking, typing
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /f /v "AllowLinguisticDataCollection" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /f /v "Enabled" /t REG_DWORD /d 0

:: Disables Autoplay and Turn Off AutoRun in Windows
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /f /v "DisableAutoplay" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"

:: DFS Share Refresh Issue - https://wiki.ledhed.net/index.php/DFS_Share_Refresh_Issue
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoSimpleNetIDList" /t REG_DWORD /d 1

:: Disable Low Disk Space Checks in Windows - https://www.lifewire.com/how-to-disable-low-disk-space-checks-in-windows-vista-2626331
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoLowDiskSpaceChecks" /t REG_DWORD /d 1

:: Windows 11 Explorer use compact mode and restore Classic Context Menu
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v UseCompactMode /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f

:: Disables Meet Now Chat and Microsoft Teams; Remove Chat from the taskbar in Windows 11
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "com.squirrel.Teams.Teams"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarMn /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3

:: Turn off News and Interests
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /f /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarDa" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /f /v "EnableFeeds" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Dsh" /f /v "AllowNewsAndInterests" /t REG_DWORD /d 0
powershell -noprofile -executionpolicy bypass -command "Get-AppxPackage -Name *WebExperience* | Foreach {Remove-AppxPackage $_.PackageFullName}"
powershell -noprofile -executionpolicy bypass -command "Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match 'WebExperience' } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }"

:: Turn off Suggest Ways I can finish setting up my device: Created by: Shawn Brink on: July 31, 2019; Tutorial: https://www.tenforums.com/tutorials/137645-turn-off-get-even-more-out-windows-suggestions-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /f /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0

:: Turn off Game Mode: Created by: Shawn Brink on: January 27th 2016; Updated on: November 6th 2017; Tutorial: https://www.tenforums.com/tutorials/75936-turn-off-game-mode-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /f /v "AllowAutoGameMode" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /f /v "AutoGameModeEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /f /v "AppCaptureEnabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f /v "AllowGameDVR" /t REG_DWORD /d 0

:: Turn off Cloud Content Search for Microsoft Account: Created by: Shawn Brink on: September 18, 2022; Tutorial: https://www.elevenforum.com/t/enable-or-disable-cloud-content-search-in-windows-11.5378/
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsAADCloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCloudSearch" /t REG_DWORD /d 0

:: Removing CloudStore from registry if it exists
taskkill /f /im explorer.exe
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore /f
start explorer.exe

:: Turn Off Device Search History: Created by: Shawn Brink on: September 18, 2020; Tutorial: https://www.tenforums.com/tutorials/133365-turn-off-device-search-history-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0

:: Remove Duplicate Drives in Navigation Pane of File Explorer: Created by: Shawn Brink: Tutorial: https://www.tenforums.com/tutorials/4675-drives-navigation-pane-add-remove-windows-10-a.html; https://www.winhelponline.com/blog/drives-listed-twice-explorer-navigation-pane/
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1

:: Disable Pin Store to Taskbar for All Users: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/47742-store-enable-disable-pin-taskbar-windows-8-10-a.html; https://www.elevenforum.com/t/enable-or-disable-show-pinned-items-on-taskbar-in-windows-11.3650/
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1

:: Disable Pin People icon on Taskbar: Created by: Shawn Brink; Created on: February 23rd 2018ș Tutorial: https://www.tenforums.com/tutorials/104877-enable-disable-people-bar-taskbar-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /f /v "PeopleBand" /t REG_DWORD /d "0"
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"

:: Choose which folders appear on start: To force a pinned folder to be visible, set the corresponding registry values to 1 (both values must set); to force it to be hidden, set the "_ProviderSet" value to 1 and the other one to 0; to let the user choose "_ProviderSet" value to 0 or delete the values. https://social.technet.microsoft.com/Forums/en-US/dbe85f3d-52a8-4852-a784-7bac64a9fa78/controlling-1803-quotchoose-which-folders-appear-on-startquot-settings?forum=win10itprosetup#3b488a59-cefe-4947-8529-944475c452d5
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

:: Add User's Files Desktop Icon: Created by: Shawn Brink; Tutorial: http://www.tenforums.com/tutorials/6942-desktop-icons-add-remove-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0

:: Hide Unused User's Profile Personal Folders like 3D,Saved Games,Searches: Created by: Shawn Brink; Created on: April 13th 2018; Tutorial: https://www.tenforums.com/tutorials/108032-hide-show-user-profile-personal-folders-windows-10-file-explorer.html
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"

:: Windows Explorer Tweaks: Hidden Files,Expand to Current
:: Change your Visual Effects Settings: https://www.tenforums.com/tutorials/6377-change-visual-effects-settings-windows-10-a.html
:: 0 = Let Windows choose what’s best for my computer
:: 1 = Adjust for best appearance
:: 2 = Adjust for best performance
:: 3 = Custom ;This disables the following 8 settings:Animate controls and elements inside windows;Fade or slide menus into view;Fade or slide ToolTips into view;Fade out menu items after clicking;Show shadows under mouse pointer;Show shadows under windows;Slide open combo boxes;Smooth-scroll list boxes
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

:: Change Visual Effects Settings for Best Performance and best looking
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /f /v "VisualFXSetting" /t REG_DWORD /d 3
:: Animate controls and elements inside windows - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Animate windows when minimizing and maximizing - off
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /d 0
:: Animations in the taskbar - off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
:: Enable Peek - off: Created by: Shawn Brink; Created on: April 14th 2016; Updated on: May 23rd 2019; Tutorial: https://www.tenforums.com/tutorials/47266-turn-off-peek-desktop-windows-10-a.html
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v DisablePreviewDesktop /t REG_DWORD /d 1
:: Fade or slide menus into view - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Fade or slide ToolTips into view - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Fade out menu items after clicking - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Save taskbar thumbnail previews - off
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
:: Show shadows under mouse pointer
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Show shadows under windows
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Show thumbnails instead of icons
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "IconsOnly" /t REG_DWORD /d 0
:: Show translucent selection rectangle - off
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
:: Show window contents while dragging - off
reg add "HKCU\Control Panel\Desktop" /f /v "DragFullWindows" /d 0
:: Slide open combo boxes - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Smooth edges of screen fonts
reg add "HKCU\Control Panel\Desktop" /f /v "FontSmoothing" /t REG_SZ /d "2"
:: Smooth-scrool list boxes - off
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
:: Use drop shadows for icon labels on the desktop
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewShadow" /t REG_DWORD /d 0
:: Move the Start button to the Left Corner:
taskkill /f /im explorer.exe
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0
start explorer.exe

:: Disable Remote Assistance: Created by: Shawn Brink on: August 27th 2018:: Tutorial: https://www.tenforums.com/tutorials/116749-enable-disable-remote-assistance-connections-windows.html
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /f /v fAllowToGetHelp /t REG_DWORD /d 0
netsh advfirewall firewall set rule group="Remote Assistance" new enable=no

:: Change to Small memory dump: Memory dump file options for Windows: https://support.microsoft.com/en-us/topic/b863c80e-fb51-7bd5-c9b0-6116c3ca920f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "CrashDumpEnabled" /d "0x3"

:: Clear Taskbar Pinned Apps: Created by: Shawn Brink on: December 3rd 2014: Tutorial: https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned"
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
:: reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /F
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

:: "Restore Windows Photo Viewer" Created by: Shawn Brink ; Created on: August 8th 2015 ; Updated on: August 5th 2018 #  Tutorial: https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html
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
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f
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
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" /disable
:: Detects and mitigates problems in physical memory (RAM).
schtasks /Change /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" /disable
:: Mobile Broadband Account Experience Metadata Parser
schtasks /Change /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" /disable
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
sc config "OneSyncSvc" start=demand
wmic service where "name like 'OneSyncSvc%%%'" call stopservice

wmic service where "name like 'OneSyncSvc%%%'" call ChangeStartMode StartMode=manual
:: Service supporting text messaging and related functionality...
sc stop MessagingService
:: Problem Reports and Solutions Control Panel Support...
sc stop wercplsupport
sc config "wercplsupport" start=disabled
:: Windows Live Sign-In Assistant service...
sc stop wlidsvc
:: Windows Insider Service Provides infrastructure support for the Windows Insider Program...
sc stop wisvc
sc delete wisvc
:: Retail Demo experience, for retail store staff who want to demo it to customers...
sc stop RetailDemo
sc delete RetailDemo
:: Microsoft (R) Diagnostics Hub Standard Collector Service, this service collects real time ETW events and processes them...
sc stop diagnosticshub.standardcollector.service
sc delete diagnosticshub.standardcollector.service
:: Disable the use of biometrics - Windows Biometric Service
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /f /v "Enabled" /t REG_DWORD /d "0"
sc stop WbioSrvc
sc delete WbioSrvc
:: Disable Game Recordings and Live Broadcasts
wmic service where "name like 'BcastDVR%%%'" call stopservice

wmic service where "name like 'BcastDVR%%%'" call ChangeStartMode StartMode=disabled
:: BitLocker Drive Encryption Service
sc stop BDESVC
sc config "BDESVC" start=demand
:: Internet Connection Sharing (ICS)
sc stop SharedAccess
sc config "SharedAccess" start=demand
:: Parental Controls
sc stop WpcMonSvc
sc config "WpcMonSvc" start=disabled
:: Phone Service - Manages the telephony state on the device
sc stop PhoneSvc
sc config "PhoneSvc" start=demand
:: Fax Service - Enables you to send and receive faxes
sc stop Fax
sc config "Fax" start=demand
:: Remote Registry
sc stop RemoteRegistry
sc config "RemoteRegistry" start=disabled
:: TCP/IP NetBIOS Helper
sc stop lmhosts
sc config "lmhosts" start=demand
:: Touch Keyboard and Handwriting Panel Service
sc stop TabletInputService
sc config "TabletInputService" start=demand
:: Windows Image Acquisition (WIA)
sc stop stisvc
sc config "stisvc" start=demand
:: Wallet Service - Hosts objects used by clients of the wallet
sc stop WalletService
sc config "WalletService" start=demand
:: AllJoyn Router Service — This is a service that lets you connect Windows to the Internet of Things and communicate with devices such as smart TVs, refrigerators, light bulbs, thermostats, etc.
sc stop AJRouter
sc config "AJRouter" start=demand
:: Program Compatibility Assistant Service - This service provides support for the Program Compatibility Assistant (PCA).
sc stop PcaSvc
sc config "PcaSvc" start=demand
:: Portable Device Enumerator Service — This service is needed for making group policy changes for removable drives and to synchronize content for applications like Windows Media Player and Image Import Wizard on the removable drive.
sc stop WPDBusEnum
sc config "WPDBusEnum" start=demand
:: Network connection broker — This service brokers connections and allows Microsoft Store apps to get notifications from the internet.
sc stop NcbService
sc config "NcbService" start=demand
:: Windows event log — Similar to number 23, this service allows logs to be generated about Windows events such as querying, subscribing to, and archiving events.
sc stop EventLog
sc config "EventLog" start=demand
:: Smart Card (and related services) — These services let Windows use smart cards that are required for security purposes in corporations and large organizations.
sc stop SCardSvr
sc config "SCardSvr" start=demand
sc stop ScDeviceEnum
sc config "ScDeviceEnum" start=demand
sc stop SCPolicySvc
sc config "SCPolicySvc" start=demand
:: Certificate Propagation - Copies user certificates and root certificates from smart cards
sc stop CertPropSvc
sc config "CertPropSvc" start=demand
:: Enterprise App Management Service — This service is only needed to manage enterprise apps that are provided by organizations and companies.
sc stop EntAppSvc
sc config "EntAppSvc" start=demand
:: Netlogon — This is another network service that helps establish and secure channels between a computer and the domain controller.
sc stop Netlogon
sc config "Netlogon" start=demand


:: Preventing Windows from re-enabling Telemetry services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1

:: System TuneUp
:: Reduce Application idlesness at closing to improve shutdown process
reg delete "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout"
reg add "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout" /t REG_SZ /d "4000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000"
reg add "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout" /t REG_SZ /d "3000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout" /t REG_SZ /d "10000"
:: System Stability
:: Disable automatical reboot when system encounters blue screen
reg add "HKLM\SYSTEM\ControlSet001\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
:: Disable registry modification from a remote computer
reg add "HKLM\SYSTEM\ControlSet001\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
:: Set Windows Explorer components to run in separate processes avoiding system conflicts
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /f /v "DesktopProcess" /t REG_DWORD /d 1
:: Close frozen processes to avoid system crashes
reg add "HKCU\Control Panel\Desktop" /f /v "AutoEndTasks" /t REG_SZ /d "1"
:: System Speedup
:: Remove the word "shortcut" from the shortcut icons
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /f /v "link" /t REG_BINARY /d "00000000"
:: Optimize Windows Explorer so that it can automatically restart after an exception occurs to prevent the system from being unresponsive.

:: Optimize the visual effect of the menu and list to improve the operating speed of the system.

:: Optimize refresh policy of Windows file list.

:: Speed up display speed of Taskbar Window Previews.
reg add "HKCU\Control Panel\Mouse" /f /v "MouseHoverTime" /t REG_SZ /d "100"
:: Speed up Aero Snap to make thumbnail display faster.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ExtendedUIHoverTime" /t REG_DWORD /d "0"
:: Optimized response speed of system display.
reg add "HKCU\Control Panel\Desktop" /f /v "MenuShowDelay" /t REG_SZ /d 0
:: Increase system icon cache and speed up desktop display.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /f /v "Max Cached Icons" /t REG_SZ /d 4096
:: Boost the response speed of foreground programs.
reg add "HKCU\Control Panel\Desktop" /f /v "ForegroundLockTimeout" /t REG_DWORD /d 0
:: Boost the display speed of Aero Peek.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "DesktopLivePreviewHoverTime" /t REG_DWORD /d 0
:: Disable memory pagination and reduce disk 1/0 to improve application performance. {Option may be ignored if physical memory is <1 GB)
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
:: Optimize processor performance for execution of applications, games, etc. {Ignore if server}
reg add "HKLM\SYSTEM\ControlSet001\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
:: Close animation effect when maximizing or minimizing a window to speed up the window response.

:: Disable the "Autoplay" feature on drives to avoid virus infection/propagation.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "221"
:: Optimize disk 1/0 subsystem to improve system performance.
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
:: Optimize the file system to improve system performance.
reg delete "HKLM\SYSTEM\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg add "HKLM\SYSTEM\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
:: Optimize front end components (dialog box, menus, etc.) appearance to improve system performance.

:: Optimize memory default settings to improve system performance.
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
:: Disable the debugger to speed up error processing.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" /f /v "Auto" /t REG_SZ /d 0
:: Disable screen error reporting to improve system performance.
reg add "HKLM\SOFTWARE\Microsoft\PCHealth\ErrorReporting" /f /v "ShowUI" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\PCHealth\ErrorReporting" /f /v "DoReport" /t REG_DWORD /d 0
:: Network Speedup
:: Optimize LAN connection.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "nonetcrawling" /t REG_DWORD /d 1
:: Optimize DNS and DNS parsing speed.
reg add "HKLM\SYSTEM\ControlSet001\Services\Dnscache\Parameters" /f /v "maxnegativecachettl" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\ControlSet001\Services\Dnscache\Parameters" /f /v "maxcachettl" /t REG_DWORD /d "10800"
reg add "HKLM\SYSTEM\ControlSet001\Services\Dnscache\Parameters" /f /v "maxcacheentryttllimit" /t REG_DWORD /d "10800"
reg add "HKLM\SYSTEM\ControlSet001\Services\Dnscache\Parameters" /f /v "netfailurecachetime" /t REG_DWORD /d "0"
reg add "HKLM\SYSTEM\ControlSet001\Services\Dnscache\Parameters" /f /v "negativesoacachetime" /t REG_DWORD /d "0"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /f /v "maxnegativecachettl" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /f /v "maxcachettl" /t REG_DWORD /d "10800"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /f /v "maxcacheentryttllimit" /t REG_DWORD /d "10800"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /f /v "netfailurecachetime" /t REG_DWORD /d "0"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /f /v "negativesoacachetime" /t REG_DWORD /d "0"
:: Optimize Ethernet card performance.
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
:: Optimize network forward ability to improve network performance.
reg add "HKLM\SYSTEM\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
:: Optimize network settings to improve communication performance.
reg add "HKLM\SYSTEM\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\SYSTEM\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\SYSTEM\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
:: Optimize WINS name query time to improve data transfer speed.
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
:: Improve TCP/IP performance through automatic detection of "black holes" in routing at Path MTU Discovery technique.
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\SYSTEM\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
:: Optimize TTL {Time To Live) settings to improve network performance.
reg add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\SYSTEM\ControlSet001\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
:: SSD optimize
:: Disable drive defrag system on boot to extend lifespan of SSD.
reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "n"
:: Disable auto defrag when idle to extend lifespan of SSD.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "0"
:: Disable prefetch parameters to extend lifespan of SSD.
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
:: Enable TRIM function to improve working performance of SSD.


taskkill /f /im explorer.exe

powershell.exe -ExecutionPolicy Bypass -File WinClean.ps1

:: Enable Windows Defender Realtime Monitoring:
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 0
powershell -inputformat none -outputformat none -NonInteractive -Command -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring $false
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f /v "DisableRealtimeMonitoring"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /f /v "Enabled" /t REG_DWORD /d 0

:: Uninstall Microsoft Edge
del /Q /F "%UserProfile%\Desktop\Microsoft Edge.lnk"
cd %ProgramFiles(x86)%\Microsoft\Edge\Application\
:: Please change Directory to the "installation number"\installer and run setup.exe --uninstall --system-level --verbose-logging --force-uninstall


:: Verify System Files
sfc /scannow
shutdown -r /t 0
