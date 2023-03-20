cls
msg "%username%" Please make sure you: `Read_First.txt
Notepad "`Read_First.txt"

Echo Rename C: Drive to WinX-OS
label C: Windows-OS

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
Echo Rename computer to Work-PC
wmic computersystem rename Work-PC

:: Move the Start button to the Left Corner 
Echo Move the Start button to the Left Corner:
>nul 2>&1 reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0

Echo Change to Dark Theme:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v "BackgroundType" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "D6 E0 E1 00 9E AB AE 00 61 6F 75 00 4A 54 59 00 3F 48 4D 00 25 2B 32 00 0D 11 18 00 00 B7 C3 00" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_BINARY /d ff4d483f /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_BINARY /d ff59544a /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_BINARY /d c44a5459 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_BINARY /d c44a5459 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AccentColor" /t REG_BINARY /d ff59544a /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f
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

:: Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016
:: Tutorial: http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /f /v "GlobalUserDisabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /f /v "Value" /t REG_SZ /d "Deny"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /f /v "AppCaptureEnabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /f /v "VoiceActivationOn" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /f /v "ModelDownloadAllowed" /t REG_DWORD /d 0

:: Created by: Shawn Brink on: April 27th 2017; Tutorial: https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html
Echo "Turn Off Website Access of Language List."
reg add "HKCU\Control Panel\International\User Profile" /f /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1

Echo Settings » privacy » general » windows permissions "Setting General Windows Permissions."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCamera" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessLocation" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMicrophone" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessNotifications" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessContacts" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCalendar" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessEmail" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMessaging" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessRadios" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTasks" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d 2
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsRunInBackground" /t REG_DWORD /d 2

:: Created by: Shawn Brink on: March 8th 2018; Tutorial: https://www.tenforums.com/tutorials/128523-enable-disable-app-launch-tracking-windows-10-a.html
Echo "Disable App Launch Tracking."
reg add "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1

:: Created by: Shawn Brink; Created on: December 17th 2017; Updated on: June 11th 2018; Tutorial: https://www.tenforums.com/tutorials/100541-turn-off-suggested-content-settings-app-windows-10-a.html
Echo "Turn Off Suggested Content in Settings."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0

Echo Disabling Windows 10 Notifications
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "DatabaseMigrationCompleted" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "ToastEnabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoCloudApplicationNotification" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /f /v "DisabledByGroupPolicy" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /f /v "HarvestContacts" /t REG_DWORD /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0

:: Created by: Shawn Brink - Restore Windows Photo Viewer # Created on: August 8th 2015 # Updated on: August 5th 2018  #  Tutorial: https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html
Echo "Restore Windows Photo Viewer" ; Created by: Shawn Brink ; Created on: August 8th 2015 ; Updated on: August 5th 2018
reg add "HKCR\jpegfile\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\pngfile\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_SZ /d "@photoviewer.dll,-3043" /f
reg add "HKCR\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\Applications\photoviewer.dll\shell\print" /v "NeverDefault" /t REG_SZ /d "" /f
reg add "HKCR\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF" /v "EditFlags" /t REG_DWORD /d "65536" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg" /v "EditFlags" /t REG_DWORD /d "65536" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp" /v "EditFlags" /t REG_DWORD /d "65536" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
reg add "HKCR\SystemFileAssociations\image\shell\Image Preview\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
reg add "HKCR\SystemFileAssociations\image\shell\Image Preview\DropTarget" /v "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".cr2" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f

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
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "SearchOnTaskbarMode" /t REG_DWORD /d "0" /f

Echo Enable Admin Shares...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

Echo Enable Local Security Authority Protection...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RunAsPPL /t REG_DWORD /d 1 /f

Echo Remove the Limit local account use of blank passwords to console logon only...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f

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
:: sc delete OneSyncSvc > NUL 2>&1
Echo Service supporting text messaging and related functionality...
:: sc delete MessagingService > NUL 2>&1
Echo Problem Reports and Solutions Control Panel Support...
sc delete wercplsupport > NUL 2>&1
Echo Windows Live Sign-In Assistant service...
:: sc delete wlidsvc > NUL 2>&1
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
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1 /f

Echo Settings » privacy » general » app permissions: "Setting App Permissions."

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /f /v "Value" /t REG_SZ /d Allow
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect" /f /v "Value" /t REG_SZ /d Deny


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
:: Critical battery action: No action is taken when the critical battery level is reached.
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 0 

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
