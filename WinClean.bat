@echo off
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights & powershell -Command "Start-Process 'winclean.bat' -Verb runAs" & exit /b 1)
echo "Color" Sets the default console foreground and background colours. %ESC%[36m https://ss64.com/nt/color.html
Color 07
:: Maximize the window
if not "%1"=="max" start /max cmd /c %0 max & Exit /b
:: Changed the Encoding to chcp 65001 > nul [ Unicode Encoding ]
chcp 65001 > nul
:: Generate ANSI ESC characters for color codes
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set ESC=%%b
echo %ESC%[1m- Commands sintax and utils @ %ESC%[36m https://ss64.com %ESC%[0m
echo %ESC%[1m- Update script %ESC%[96m and Self-Healing %ESC%[0m
:: Please comment out the following lines if you are customizing the script, otherwise it will auto-heal :-)
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/blob/a19cc2cc16294b4c59abb55e37511291a181931d/WinClean.bat' -OutFile WinClean.bat"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/blob/a19cc2cc16294b4c59abb55e37511291a181931d/Edge-uninstall.ps1' -OutFile Edge-uninstall.ps1"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/blob/a19cc2cc16294b4c59abb55e37511291a181931d/OneDrive-uninstall.ps1' -OutFile OneDrive-uninstall.ps1"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/blob/a19cc2cc16294b4c59abb55e37511291a181931d/README.md' -OutFile '`Read_First.txt'"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/blob/a19cc2cc16294b4c59abb55e37511291a181931d/WinClean.ps1' -OutFile WinClean.ps1"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/blob/a19cc2cc16294b4c59abb55e37511291a181931d/hosts' -OutFile hosts"

echo -%ESC%[32m Save important PC information to Documents\PC-info %ESC%[0m -%ESC%[36m https://www.tenforums.com/tutorials/3443-view-user-account-details-windows-10-a.html %ESC%[0m
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (set docdir=%%b)
md %docdir%\PC-info
wmic useraccount list full >"%docdir%\PC-info\UserAccountDetails.txt"
echo -%ESC%[32m Export WiFi passwords -%ESC%[36m https://www.elevenforum.com/t/backup-and-restore-wi-fi-network-profiles-in-windows-11.4472/ %ESC%[0m
netsh wlan show profiles
netsh wlan export profile key=clear folder=%docdir%\PC-info
echo -%ESC%[32m Check if Users are a Microsoft account or Local account -%ESC%[36m https://www.tenforums.com/tutorials/5387-how-tell-if-local-account-microsoft-account-windows-10-a.html %ESC%[0m
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-LocalUser | Select-Object Name,PrincipalSource | Out-File -filepath %docdir%\PC-info\All_Accounts.txt"
echo -%ESC%[92m List all Optional Capabilities - Save to -%ESC%[36m %docdir%\PC-info\Windows-Capability-listing-before-cleanup.txt %ESC%[0m
dism /Online /Get-Capabilities /Format:Table > "%docdir%\PC-info\Windows-Capability-listing-before-cleanup.txt"
echo -%ESC%[92m List all Optional Features - Save to -%ESC%[36m %docdir%\PC-info\Windows-Features-listing-before-cleanup.txt %ESC%[0m
dism /Online /Get-Features /Format:Table > "%docdir%\PC-info\Windows-Features-listing-before-cleanup.txt"
echo -%ESC%[92m List of Provisioned Application Packages - Save to -%ESC%[36m %docdir%\PC-info\AppPackages-before-cleanup.txt %ESC%[0m
dism /Online /Get-ProvisionedAppxPackages > "%docdir%\PC-info\AppPackages-before-cleanup.txt"
echo -%ESC%[92m List of Drivers - Save to -%ESC%[36m %docdir%\PC-info\Windows-Drivers.txt %ESC%[0m
dism /Online /Get-Drivers /format:Table > "%docdir%\PC-info\Windows-Drivers.txt"
echo -%ESC%[92m List of Packages - Save to -%ESC%[36m %docdir%\PC-info\Windows-Packages.txt %ESC%[0m
dism /Online /Get-Packages /format:Table > "%docdir%\PC-info\Windows-Packages.txt"
echo -%ESC%[92m International Settings - Save to -%ESC%[36m %docdir%\PC-info\International-Settings.txt %ESC%[0m
dism /Online /Get-Intl > "%docdir%\PC-info\International-Settings.txt"
echo -%ESC%[92m Saving PC information to -%ESC%[36m %docdir%\PC-info\SystemInfo.txt %ESC%[0m
systeminfo > %docdir%\PC-info\SystemInfo.txt
systeminfo /FO CSV > %docdir%\PC-info\SystemInfo.csv
msinfo32 /report %docdir%\PC-info\Detailed-System-Information-MSInfo32.txt
echo -%ESC%[92m Windows Version Information - -%ESC%[36m %docdir%\PC-info\Windows-version.txt %ESC%[0m
ver > "%docdir%\PC-info\Windows-version.txt"
echo -%ESC%[92m Export Current Tasks to -%ESC%[36m %docdir%\PC-info\Tasks-before-cleanup.txt %ESC%[0m
schtasks /query /v /fo CSV > "%docdir%\PC-info\Tasks-before-cleanup.txt"​
echo -%ESC%[92m Export Windows Services to -%ESC%[36m %docdir%\PC-info\Services-before-cleanup.csv %ESC%[0m
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-CIMInstance -Class Win32_Service | Select-Object Name, DisplayName, Description, StartMode, DelayedAutoStart, StartName, PathName, State, ProcessId | Export-CSV -Path %docdir%\PC-info\Services-before-cleanup.csv​"
sc query state=all > %docdir%\PC-info\All-Services-before-cleanup.txt
sc query > %docdir%\PC-info\Running-Services-before-cleanup.txt
net start > %docdir%\PC-info\List-of-Running-Services-before-cleanup.txt
echo -%ESC%[92m Please Backup your credentials to -%ESC%[36m %docdir%\PC-info\Credentials.crd %ESC%[0m by running: Rundll32.exe keymgr.dll,KRShowKeyMgr

for /f "delims=: tokens=*" %%x in ('findstr /b ::: "%~f0"') do @echo(%%x
echo %ESC%[97m
::: 
:::  ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗
:::  ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝
:::  ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗
:::  ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║
:::  ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║
:::   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝
:::  
::: 	  ██████╗██╗     ███████╗ █████╗ ███╗   ██╗
::: 	 ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║
::: 	 ██║     ██║     █████╗  ███████║██╔██╗ ██║
::: 	 ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║
::: 	 ╚██████╗███████╗███████╗██║  ██║██║ ╚████║
::: 	  ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
:::  
echo -%ESC%[91mPlease read carefully before proceding! %ESC%[0m
echo -%ESC%[93mCleaning up Windows 10 and 11 could be a long process with many detailed steps, we're trying to cover most of them automatically. %ESC%[0m
echo -%ESC%[93mThis is a long script and it can take (from my tests) anywhere between 10-30 minutes depending on the computer speed.
echo The scrips will run automatically removing most of the bloatware and leaving a clean and lightweight Operating System
echo %ESC%[96mImportant Notes:
echo %ESC%[97m- computer needs to be signed in locally,%ESC%[91m not with a Microsoft Account%ESC%[97m, this script will disable Microsoft Syncronization, so a previous change to %ESC%[92mLocal Account%ESC%[97m is necesary
echo - this script will %ESC%[95mdisable the Gaming platform and all cloud Syncronization %ESC%[97m
echo - this script will remove a lot of %ESC%[95mbackground tasks and most of the Microsoft Store Apps %ESC%[97m
echo - the script is self explanatory, lines of descriptione listed on every step
echo - to speed up user experience and reduce eye strain the background is removed, %ESC%[94mColor Scheme turned to Dark, and Sound Scheme to no sounds! %ESC%[97m
echo - the "hosts" file contains a list of bad websites, known for moral or controversial issues! Loaded to the right place, it will provide a first-hand protection to any computer. It may be attacked by some Antivirus Software.
echo - While this is a big list of cleanup commands, it is not complete. Further cleaning is recommended by using a few Portable Apps from%ESC%[96m https://portableapps.com/apps/utilities %ESC%[0mlike:
echo 	- PrivaZer -%ESC%[96m https://portableapps.com/apps/utilities/privazer-portable %ESC%[0m
echo 	- Revo Uninstaller -%ESC%[96m https://portableapps.com/apps/utilities/revo_uninstaller_portable %ESC%[0m
echo 	- Wise Disk Cleaner -%ESC%[96m https://portableapps.com/apps/utilities/wise-disk-cleaner-portable %ESC%[0m
echo 	- Wise Registry Cleaner -%ESC%[96m https://portableapps.com/apps/utilities/wise-registry-cleaner-portable %ESC%[0m
echo 	- ccPortable -%ESC%[96m https://portableapps.com/apps/utilities/ccportable %ESC%[0m
echo 	- "O&O ShutUp10++" -%ESC%[96m https://www.oo-software.com/en/shutup10 %ESC%[0m

msg "%username%" Please make sure you: Read the explanations before continuing!

:Menu
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-LocalUser | Select-Object Name,PrincipalSource"
echo 	%ESC%[101;93m WARNING %ESC%[0m
echo %ESC%[33m ----------------------------- %ESC%[0m
echo %ESC%[91m If you see a%ESC%[0m %ESC%[41mMicrosoftAccount%ESC%[0m %ESC%[91min the above list, please stop and switch to%ESC%[0m %ESC%[32mLocal Account%ESC%[0m
echo   %ESC%[1m(%ESC%[0m%ESC%[31mU%ESC%[0m%ESC%[1m)%ESC%[0m Open User Accounts
echo   %ESC%[1m(%ESC%[0m%ESC%[31mC%ESC%[0m%ESC%[1m)%ESC%[0m Continue
echo   %ESC%[1m(%ESC%[0m%ESC%[31mX%ESC%[0m%ESC%[1m)%ESC%[0m STOP
echo/ & CHOICE /C UCX /N /M "Enter Selection:"
IF %errorlevel%==1 START "" Rundll32.exe shell32.dll,Control_RunDLL nusrmgr.cpl
IF %errorlevel%==2 START "" exit /b & goto Continue
IF %errorlevel%==3 START "" exit /b & exit /b
goto Menu
:Continue
echo -%ESC%[32m Rename C: Drive to Windows-OS %ESC%[0m
label C: Windows-OS
:: Changed the Encoding to chcp utf-8
chcp 1252 > nul
echo -%ESC%[32m Set Time to UTC (Dual Boot) Essential for computers that are dual booting. Fixes the time sync with Linux Systems. %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /f /v RealTimeIsUniversal /t REG_DWORD /d 1

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
:: Rename computer to Work-PC
rem wmic computersystem rename Work-PC
:: Disable Hyper-V:
rem bcdedit /set hypervisorlaunchtype off
rem dism /Online /NoRestart /Disable-Feature:Microsoft-Hyper-V

echo -%ESC%[32m To prevent a specific update from installing Download the "Show or hide updates" troubleshooter package from the Microsoft website: %ESC%[36m https://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab %ESC%[0m
powershell -c "Invoke-WebRequest -Uri 'https://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab' -OutFile '%docdir%\PC-info\wushowhide.diagcab'"

echo -%ESC%[32m Microsoft Edge uninstall %ESC%[0m
IF EXIST Edge-uninstall.ps1 (powershell.exe -ExecutionPolicy Bypass -File ./Edge-uninstall.ps1 ) ELSE (msg "%username%" Edge-uninstall.ps1 not found! & echo Edge-uninstall.ps1 not found! )

echo -%ESC%[32m Microsoft OneDrive uninstall %ESC%[0m
IF EXIST OneDrive-uninstall.ps1 (powershell.exe -ExecutionPolicy Bypass -File ./OneDrive-uninstall.ps1 ) ELSE (msg "%username%" OneDrive-uninstall.ps1 not found! & echo OneDrive-uninstall.ps1 not found! )

echo -%ESC%[32m Removing OneDrive leftovers. %ESC%[0m
set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
echo -%ESC%[32m Closing OneDrive process. %ESC%[0m
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
rd "%USERPROFILE%\OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S

echo -%ESC%[32m Removing OneDrive from the Explorer Side Panel. %ESC%[0m
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
del /Q /F "%localappdata%\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe"
del /Q /F "%UserProfile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

echo -%ESC%[32m Prefer IPv4 over IPv6: To set the IPv4 preference can have latency and security benefits on private networks where IPv6 is not configured. %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Services\Tcpip6\Parameters" /f /v DisabledComponents /t REG_DWORD /d 255

echo -%ESC%[32m Disable Wifi-Sense: Wifi Sense is a spying service that phones home all nearby scanned wifi networks and your current geo location. %ESC%[0m
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /f /v "Value" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /f /v "Value" /t REG_DWORD /d 0

echo -%ESC%[32m Enable End Task With Right Click - Enables option to end task when right clicking a program in the taskbar %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /f /v TaskbarEndTask /t REG_DWORD /d 1

echo -%ESC%[32m Remove Home and Gallery from explorer %ESC%[0m
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d "1"
	 
echo %ESC%[35m Turn Off System Protection for All Drives %ESC%[0m
echo -%ESC%[32m Created by: Shawn Brink; Created on: December 27, 2021; Tutorial: %ESC%[36m https://www.elevenforum.com/t/turn-on-or-off-system-protection-for-drives-in-windows-11.3598/ %ESC%[0m
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}"
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /f /v "RPSessionInterval" /t REG_DWORD /d "0"
wmic /Namespace:\\root\default Path SystemRestore Call Disable "C:\" & :: C-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "D:\" & :: D-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "E:\" & :: E-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "F:\" & :: F-drive

echo -%ESC%[32m Disable Hybernation %ESC%[0m
powercfg -h off
powercfg.exe /hibernate off
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /f /v HibernateEnabled /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /f /v ShowHibernateOption /t REG_DWORD /d 0

echo -%ESC%[32m Decrypt Bitlocker (useless resource hog abused by Microsoft, unless sensitive data has to be protected) %ESC%[0m
manage-bde -status
manage-bde -off C:
manage-bde -off D:
manage-bde -off E:
manage-bde -off F:

echo -%ESC%[32m Disable Copilot %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsCopilot" /f /v TurnOffWindowsCopilot /t REG_DWORD /d 1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /f /v TurnOffWindowsCopilot /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowCopilotButton /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Edge" /f /v HubsSidebarEnabled" /t REG_DWORD /d 0

echo -%ESC%[32m Disable Ads in Windows 11 - Source %ESC%[36m https://www.elevenforum.com/t/disable-ads-in-windows-11.8004/ %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowSyncProviderNotifications /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_IrisRecommendations /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_AccountNotifications /t REG_DWORD /d 0

echo -%ESC%[32m Remove Settings Home page in Windows 11; Created by: Shawn Brink; Created on: June 30, 2023; Tutorial: %ESC%[36m https://www.elevenforum.com/t/add-or-remove-settings-home-page-in-windows-11.16017/ %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "SettingsPageVisibility" /t REG_SZ /d "hide:home"

echo -%ESC%[35m Turn Off Suggested Content in Settings: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: %ESC%[36m https://www.elevenforum.com/t/enable-or-disable-suggested-content-in-settings-in-windows-11.3791/ %ESC%[0m
echo -%ESC%[32m Lock screen Spotlight - New backgrounds, tips, advertisements etc. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0

echo -%ESC%[35m To Turn Off App Suggestions in Start: source %ESC%[36m https://forums.mydigitallife.net/threads/windows-10-guide-for-remove-and-stop-apps-bundle-and-more-tweaks.76030/ %ESC%[0m
echo -%ESC%[32m Disable from OEM Preinstalled Apps %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Preinstalled Apps in Windows 10 %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SystemPaneSuggestionsEnabled " /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Windows Spotlight %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Get fun facts, tips, tricks, and moe on your lock screen %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from SyncProviders - OneDrive %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280810Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from OneDrive %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280811Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Windows Ink - StokedOnIt %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280813Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Windows Spotlight %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-202914Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Share - Facebook, Instagram and etc. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280815Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310091Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310092Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338380Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from BingWeather, Candy Crush and etc. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-314559Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Windows Maps %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338381Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from My People Suggested Apps %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-314563Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Timeline Suggestions %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Occasionally show suggestions in Start %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Get tips, tricks and suggestion as you use Windows and Cortana %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Show me suggested content in the Settings app %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-88000326Enabled" /t REG_DWORD /d 0

echo -%ESC%[35m Disable Start Menu Suggestions %ESC%[0m
echo -%ESC%[32m Disable from Occassionally showing app suggestions in Start Menu %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m To Disable Automatically Installing Suggested Apps %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "FeatureManagementEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Subsribed Content status Suggested Apps %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContentEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable Spotlight %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SlideshowEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Disable from Tips, tricks and suggestions while using Windows %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SoftLandingEnabled" /t REG_DWORD /d 0

echo -%ESC%[32m Clear and Reset Quick Access Folders %ESC%[0m
del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms"

echo -%ESC%[32m Increase the number of recent files displayed in the task bar %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "JumpListItems_Maximum " /t REG_DWORD /d 30

echo -%ESC%[32m Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Holographic" /f /v "FirstRunSucceeded " /t REG_DWORD /d 0

echo %ESC%[35m Remove Optional Capabilities %ESC%[0m
echo -%ESC%[32m "Remove Windows Media Player:" %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0
echo -%ESC%[32m "Remove Feature: Extended Inbox Theme Content:" %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~
dism /Online /NoRestart /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~0.0.1.0
echo -%ESC%[32m "Remove Feature: Microsoft Quick Assist:" %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:App.Support.QuickAssist~~~~0.0.1.0
echo -%ESC%[32m "Remove Hello Face:" %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:Hello.Face.18967~~~~0.0.1.0
dism /Online /NoRestart /Remove-Capability /CapabilityName:Hello.Face.Migration.18967~~~~0.0.1.0
dism /Online /NoRestart /Remove-Capability /CapabilityName:Hello.Face.20134~~~~0.0.1.0
echo -%ESC%[32m "Remove Math Recognizer:" %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0
echo -%ESC%[32m "Remove Onesync Feature: Exchange ActiveSync and Internet Mail Sync Engine:" %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~~~0.0.1.0
echo -%ESC%[32m Turn off Steps Recorder - Source %ESC%[36m "https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.ApplicationCompatibility::AppCompatTurnOffUserActionRecord" %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /f /v "DisableUAR" /t REG_DWORD /d "1"
dism /Online /NoRestart /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0
echo -%ESC%[32m Remove Feature: Windows Feature Experience Pack %ESC%[0m
dism /Online /NoRestart /Remove-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0
echo -%ESC%[32m "Remove Internet Printing:" %ESC%[0m

echo -%ESC%[32m "Remove Work Folders:" %ESC%[0m

echo -%ESC%[32m "Remove Contact Support:" %ESC%[0m

echo -%ESC%[32m "Remove Language Speech:" %ESC%[0m

echo %ESC%[35m Add Optional Capabilities %ESC%[0m
echo -%ESC%[32m Add Feature: Print Fax Scan %ESC%[0m
dism /Online /NoRestart /Add-Capability /CapabilityName:Print.Fax.Scan~~~~0.0.1.0
echo -%ESC%[32m Add Feature: WMIC. A Windows Management Instrumentation (WMI) command-line utility. %ESC%[0m
dism /Online /NoRestart /Add-Capability /CapabilityName:WMIC~~~~
echo -%ESC%[32m Add .NET Framework %ESC%[0m
dism /Online /NoRestart /Add-Capability /CapabilityName:NetFX3~~~~
echo %ESC%[92m List all Optional Capabilities - Save to Documents\PC-info %ESC%[0m
dism /Online /Get-Capabilities /Format:Table > "%docdir%\PC-info\Windows-Capability-listing-after-cleanup.txt"

echo %ESC%[35m Enable High Performance Power Scheme %ESC%[0m
powercfg /l
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /x monitor-timeout-ac 10
powercfg /x monitor-timeout-dc 10
powercfg /x disk-timeout-ac 20
powercfg /x disk-timeout-dc 20
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 15
echo -%ESC%[32m Critical battery action: No action is taken when the critical battery level is reached. %ESC%[0m
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 0 

echo -%ESC%[35m Change to Dark Theme: %ESC%[0m
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

echo -%ESC%[32m Quiet down Windows Security stopping unnecessary notifications %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableNotifications" /t REG_DWORD /d "1"
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableWindowsHelloNotifications" /t REG_DWORD /d "1"
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableDynamiclockNotifications" /t REG_DWORD /d "1"

echo -%ESC%[32m Disable Collect Activity History: Created by: Shawn Brink on: December 14th 2017; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/100341-enable-disable-collect-activity-history-windows-10-a.html %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "EnableActivityFeed" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /f /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1

echo -%ESC%[32m Add Windows Defender ExclusionPath to enable host protection: %ESC%[0m
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%UserProfile%\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath 'D:\Microsoft\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemRoot%\System32\drivers\etc\hosts'"

echo -%ESC%[32m Transfer Hosts File: %ESC%[0m
IF EXIST hosts (copy /D /V /Y hosts %SystemRoot%\System32\drivers\etc\hosts ) ELSE (msg "%username%" hosts file not found! & echo hosts file not found! )

echo -%ESC%[32m Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016: Tutorial: %ESC%[36m http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /f /v "GlobalUserDisabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /f /v "Value" /t REG_SZ /d "Deny"
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /f /v "VoiceActivationOn" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /f /v "ModelDownloadAllowed" /t REG_DWORD /d 0

echo -%ESC%[32m Turn Off Website Access of Language List: Created by: Shawn Brink on: April 27th 2017; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html %ESC%[0m
reg add "HKCU\Control Panel\International\User Profile" /f /v "%ESC%[36m httpAcceptLanguageOptOut" /t REG_DWORD /d 1
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Language Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Layout Hotkey" /t REG_SZ /d "3"

echo %ESC%[35m Settings » privacy » general » app permissions: "Setting App Permissions." %ESC%[0m
echo -%ESC%[32m Next statements will deny access to the following apps under Privacy - - Setting anyone of these back to allow allows toggle functionality %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Disable app diag info about your other apps %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access calendar %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access other devices %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access your file system %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access messaging %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access your contacts %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access Documents %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not Allow apps to access email %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Disable Location Tracking %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /f /v "SensorPermissionState" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\lfsvc\Service\Configuration" /f /v "Status" /t REG_DWORD /d 0
reg add "HKLM\System\Maps" /f /v "AutoUpdateEnabled" /t REG_DWORD /d 0
echo -%ESC%[32m Do not allow apps to access microphone %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /f /v "Value" /t REG_SZ /d Allow
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access call history %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access Pictures %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access radio %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access Account Information %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access tasks %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access Notifications %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m Do not allow apps to access Videos %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /f /v "Value" /t REG_SZ /d Deny
echo -%ESC%[32m App access turn off camera %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /f /v "Value" /t REG_SZ /d Allow
echo -%ESC%[32m App access turn off WIFI %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect" /f /v "Value" /t REG_SZ /d Deny

echo %ESC%[35m Settings » privacy » general » windows permissions "Setting General Windows Permissions.": From %ESC%[36m https://admx.help/HKLM/Software/Policies/Microsoft/Windows/AppPrivacy %ESC%[0m
echo -%ESC%[32m Windows apps access user movements while running in the background %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessBackgroundSpatialPerception" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps activate with voice while the system is locked %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoiceAboveLock" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps activate with voice %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoice" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access an eye tracker device %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGazeInput" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access diagnostic information about other apps %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps run in the background %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsRunInBackground" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access trusted devices %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTrustedDevices" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access Tasks %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTasks" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps communicate with unpaired devices %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps control radios %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessRadios" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps make phone calls %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessPhone" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access notifications %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessNotifications" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access motion %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMotion" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access the microphone %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMicrophone" /t REG_DWORD /d 0
echo -%ESC%[32m Windows apps access messaging %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMessaging" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access location %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessLocation" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps turn off the screenshot border %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureWithoutBorder" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps take screenshots of various windows or displays %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureProgrammatic" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access email %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessEmail" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access contacts %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessContacts" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access the camera %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCamera" /t REG_DWORD /d 0
echo -%ESC%[32m Windows apps access call history %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access the calendar %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCalendar" /t REG_DWORD /d 2
echo -%ESC%[32m Windows apps access account information %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 2

echo -%ESC%[32m Disable App Launch Tracking: Created by: Shawn Brink; Created on: January 3, 2022; Tutorial: %ESC%[36m https://www.elevenforum.com/t/enable-or-disable-app-launch-tracking-in-windows-11.3727/ %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Start_TrackProgs" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1

echo -%ESC%[32m Disabling Windows Notifications %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "DatabaseMigrationCompleted" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "ToastEnabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoCloudApplicationNotification" /t REG_DWORD /d 1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0

echo -%ESC%[32m Removes 3D Objects from the 'My Computer' submenu in explorer %ESC%[0m
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f

echo -%ESC%[32m settings » privacy » general » let apps use my ID ... %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /f /v "DisabledByGroupPolicy" /t REG_DWORD /d 1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Id"

echo -%ESC%[32m Turn Off Personal Inking and Typing Dictionary: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: %ESC%[36m https://www.elevenforum.com/t/enable-or-disable-personal-inking-and-typing-dictionary-in-windows-11.5564/ %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization" /f /v "Value" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /f /v "HarvestContacts" /t REG_DWORD /d 0

echo -%ESC%[32m Disable Windows Search Box... and web search in the search box Created by: Shawn Brink on: May 4th 2019 Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/2854-hide-show-search-box-search-icon-taskbar-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "BingSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlStatus" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlSecondaryStatus" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "SearchboxTaskbarMode" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "SearchOnTaskbarMode" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1

echo -%ESC%[32m Enable Admin Shares... %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\system" /f /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1

echo -%ESC%[32m Remove the Limit local account use of blank passwords to console logon only... %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v "LimitBlankPasswordUse" /t REG_DWORD /d 0

echo -%ESC%[32m Enable Local Security Authority Protection... %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v RunAsPPL /t REG_DWORD /d 1

echo -%ESC%[32m Disable Windows Feedback... %ESC%[0m
reg add "HKCU\Software\Microsoft\Siuf\Rules" /f /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0
reg delete "HKCU\Software\Microsoft\Siuf\Rules" /f /v "PeriodInNanoSeconds"
reg add "HKLM\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f /v "Start" /t REG_DWORD /d 0
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
echo y|cacls  C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl  /d SYSTEM
rem reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKCU\Software\Microsoft\Internet Explorer\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "EnableSmartScreen" /t REG_DWORD /d 0

echo -%ESC%[32m Disabling Cortana... %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCortana" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search and Cortana application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

echo -%ESC%[32m Turn off Windows Error reporting... %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1

echo -%ESC%[32m No license checking... removed now %ESC%[0m
rem reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f /v "NoGenTicket" /t REG_DWORD /d 1
reg delete "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f

echo -%ESC%[32m Disable app access to Voice activation... %ESC%[0m
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d 0

echo -%ESC%[32m Disable sync... %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSync" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 

echo -%ESC%[32m No Windows Tips... %ESC%[0m
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableSoftLanding" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\WindowsInkWorkspace" /f /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d 0

echo -%ESC%[32m Disabling live tiles... %ESC%[0m
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoTileApplicationNotification" /t REG_DWORD /d 1

echo -%ESC%[32m Debloat Microsoft Edge using Registry - Disables various telemetry options, popups, and other annoyances in Edge. %ESC%[0m
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

echo -%ESC%[32m settings » privacy » general » speech, inking, typing %ESC%[0m
reg add "HKCU\Software\Microsoft\Personalization\Settings" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" /f /v "AllowLinguisticDataCollection" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Input\TIPC" /f /v "Enabled" /t REG_DWORD /d 0

echo -%ESC%[32m Disables Autoplay and Turn Off AutoRun in Windows %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /f /v "DisableAutoplay" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"

echo -%ESC%[32m Disable Low Disk Space Checks in Windows -%ESC%[36m https://www.lifewire.com/how-to-disable-low-disk-space-checks-in-windows-vista-2626331 %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoLowDiskSpaceChecks" /t REG_DWORD /d 1

echo -%ESC%[32m Windows 11 Explorer use compact mode and restore Classic Context Menu %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v UseCompactMode /t REG_DWORD /d 1
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f

echo -%ESC%[32m Disables Meet Now Chat and Microsoft Teams; Remove Chat from the taskbar in Windows 11 %ESC%[0m
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f /v "com.squirrel.Teams.Teams"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarMn /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3

echo -%ESC%[32m Turn off News and Interests %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /f /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarDa" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Feeds" /f /v "EnableFeeds" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Dsh" /f /v "AllowNewsAndInterests" /t REG_DWORD /d 0
powershell -noprofile -executionpolicy bypass -command "Get-AppxPackage -Name *WebExperience* | Foreach {Remove-AppxPackage $_.PackageFullName}"
powershell -noprofile -executionpolicy bypass -command "Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match 'WebExperience' } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }"

echo -%ESC%[32m Turn off Suggest Ways I can finish setting up my device: Created by: Shawn Brink on: July 31, 2019; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/137645-turn-off-get-even-more-out-windows-suggestions-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /f /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0

echo -%ESC%[32m Turn off Game Mode: Created by: Shawn Brink on: January 27th 2016; Updated on: November 6th 2017; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/75936-turn-off-game-mode-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\GameBar" /f /v "AllowAutoGameMode" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\GameBar" /f /v "AutoGameModeEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /f /v "AppCaptureEnabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_Enabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /f /v "AllowGameDVR" /t REG_DWORD /d 0

echo -%ESC%[32m Turn off Cloud Content Search for Microsoft Account: Created by: Shawn Brink on: September 18, 2022; Tutorial: %ESC%[36m https://www.elevenforum.com/t/enable-or-disable-cloud-content-search-in-windows-11.5378/ %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsAADCloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCloudSearch" /t REG_DWORD /d 0

echo -%ESC%[32m Removing CloudStore from registry if it exists %ESC%[0m
taskkill /f /im explorer.exe
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore /f
start explorer.exe

echo -%ESC%[32m Turn Off Device Search History: Created by: Shawn Brink on: September 18, 2020; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/133365-turn-off-device-search-history-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0

echo -%ESC%[32m Remove Duplicate Drives in Navigation Pane of File Explorer: Created by: Shawn Brink: Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/4675-drives-navigation-pane-add-remove-windows-10-a.html; %ESC%[36m https://www.winhelponline.com/blog/drives-listed-twice-explorer-navigation-pane/ %ESC%[0m
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1

echo -%ESC%[32m Disable Pin Store to Taskbar for All Users: Created by: Shawn Brink; Tutorial: %ESC%[36m http://www.tenforums.com/tutorials/47742-store-enable-disable-pin-taskbar-windows-8-10-a.html; %ESC%[36m https://www.elevenforum.com/t/enable-or-disable-show-pinned-items-on-taskbar-in-windows-11.3650/ %ESC%[0m
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1

echo -%ESC%[32m Disable Pin People icon on Taskbar: Created by: Shawn Brink; Created on: February 23rd 2018ș Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/104877-enable-disable-people-bar-taskbar-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /f /v "PeopleBand" /t REG_DWORD /d "0"
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"

echo -%ESC%[32m Choose which folders appear on start: To force a pinned folder to be visible, set the corresponding registry values to 1 (both values must set); to force it to be hidden, set the "_ProviderSet" value to 1 and the other one to 0; to let the user choose "_ProviderSet" value to 0 or delete the values. %ESC%[36m https://social.technet.microsoft.com/Forums/en-US/dbe85f3d-52a8-4852-a784-7bac64a9fa78/controlling-1803-quotchoose-which-folders-appear-on-startquot-settings?forum=win10itprosetup#3b488a59-cefe-4947-8529-944475c452d5 %ESC%[0m
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

echo -%ESC%[32m Add User's Files Desktop Icon: Created by: Shawn Brink; Tutorial: %ESC%[36m http://www.tenforums.com/tutorials/6942-desktop-icons-add-remove-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0

echo -%ESC%[32m Hide Unused User's Profile Personal Folders like 3D,Saved Games,Searches: Created by: Shawn Brink; Created on: April 13th 2018; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/108032-hide-show-user-profile-personal-folders-windows-10-file-explorer.html %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"

:: Windows Explorer Tweaks: Hidden Files,Expand to Current %ESC%[0m
:: Change your Visual Effects Settings: %ESC%[36m https://www.tenforums.com/tutorials/6377-change-visual-effects-settings-windows-10-a.html %ESC%[0m
:: 0 = Let Windows choose what’s best for my computer
:: 1 = Adjust for best appearance
:: 2 = Adjust for best performance
:: 3 = Custom ;This disables the following 8 settings:Animate controls and elements inside windows;Fade or slide menus into view;Fade or slide ToolTips into view;Fade out menu items after clicking;Show shadows under mouse pointer;Show shadows under windows;Slide open combo boxes;Smooth-scroll list boxes %ESC%[0m
echo -%ESC%[32m Open File Explorer to: This PC %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d 1
echo -%ESC%[32m Show hidden files, folders, and drives %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Hidden" /t REG_DWORD /d 1
echo -%ESC%[32m Hide protected operating system files (Recommended) %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ShowSuperHidden" /t REG_DWORD /d 0
echo -%ESC%[32m Hide Desktop icons %ESC%[0m
:: reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideIcons" /t REG_DWORD /d 1
echo -%ESC%[32m Hide extensions for known file types %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideFileExt" /t REG_DWORD /d 0
echo -%ESC%[32m Navigation pane: Expand to open folder %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneExpandToCurrentFolder" /t REG_DWORD /d 1
echo -%ESC%[32m Navigation pane: Show all folders %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneShowAllFolders" /t REG_DWORD /d 1

echo -%ESC%[32m Change Visual Effects Settings for Best Performance and best looking %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /f /v "VisualFXSetting" /t REG_DWORD /d 3
echo -%ESC%[32m Animate controls and elements inside windows - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Animate windows when minimizing and maximizing - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /d 0
echo -%ESC%[32m Animations in the taskbar - off %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
echo -%ESC%[32m Enable Peek - off: Created by: Shawn Brink; Created on: April 14th 2016; Updated on: May 23rd 2019; Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/47266-turn-off-peek-desktop-windows-10-a.html %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v DisablePreviewDesktop /t REG_DWORD /d 1
echo -%ESC%[32m Fade or slide menus into view - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Fade or slide ToolTips into view - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Fade out menu items after clicking - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Save taskbar thumbnail previews - off %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
echo -%ESC%[32m Show shadows under mouse pointer %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Show shadows under windows %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Show thumbnails instead of icons %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "IconsOnly" /t REG_DWORD /d 0
echo -%ESC%[32m Show translucent selection rectangle - off %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
echo -%ESC%[32m Show window contents while dragging - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "DragFullWindows" /d 0
echo -%ESC%[32m Slide open combo boxes - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Smooth edges of screen fonts %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "FontSmoothing" /t REG_SZ /d "2"
echo -%ESC%[32m Smooth-scrool list boxes - off %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
echo -%ESC%[32m Use drop shadows for icon labels on the desktop %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewShadow" /t REG_DWORD /d 0
echo -%ESC%[32m Move the Start button to the Left Corner: %ESC%[0m
taskkill /f /im explorer.exe
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0
start explorer.exe

echo -%ESC%[32m Disable Remote Assistance: Created by: Shawn Brink on: August 27th 2018echo -%ESC%[32m Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/116749-enable-disable-remote-assistance-connections-windows.html %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /f /v fAllowToGetHelp /t REG_DWORD /d 0
netsh advfirewall firewall set rule group="Remote Assistance" new enable=no

echo -%ESC%[32m Change to Small memory dump: Memory dump file options for Windows: %ESC%[36m https://support.microsoft.com/en-us/topic/b863c80e-fb51-7bd5-c9b0-6116c3ca920f %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "CrashDumpEnabled" /d "0x3"

echo -%ESC%[32m Clear Taskbar Pinned Apps: Created by: Shawn Brink on: December 3rd 2014: Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html %ESC%[0m
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned"
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
:: reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /F
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

echo %ESC%[35m "Restore Windows Photo Viewer" Created by: Shawn Brink; Created on: August 8th 2015; Updated on: August 5th 2018 # Tutorial: %ESC%[36m https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html %ESC%[0m
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

echo %ESC%[35m Remove sounds - "Change to no sounds theme" %ESC%[0m
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

echo -%ESC%[32m Remove Xbox... %ESC%[0m
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

echo -%ESC%[32m Remove Maps... %ESC%[0m
sc stop "MapsBroker"
sc config "MapsBroker" start=disabled
sc delete MapsBroker
sc stop lfsvc
sc delete lfsvc
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable

echo %ESC%[35m Disables scheduled tasks that are considered unnecessary %ESC%[0m
echo -%ESC%[32m EDP Policy Manager - This task performs steps necessary to configure Windows Information Protection. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\AppID\EDP Policy Manager" /disable :: Inspects the AppID certificate cache for invalid or revoked certificates.
:: schtasks /Change /TN "\Microsoft\Windows\AppID\VerifiedPublisherCertStoreCheck" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\SmartScreenSpecific*" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\AitAgent*" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\Microsoft*" /disable
echo -%ESC%[32m PcaPatchDbTask - Updates compatibility database %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" /disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
echo -%ESC%[32m StartupAppTask - Scans startup entries and raises notification to the user if there are too many startup entries. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /disable
echo -%ESC%[32m MareBackup - Gathers Win32 application data for App Backup scenario %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Application Experience\MareBackup" /disable
echo -%ESC%[32m Cleans up each package's unused temporary files. %ESC%[0m
rem schtasks /Change /TN "\Microsoft\Windows\ApplicationData\CleanupTemporaryState" /disable
echo -%ESC%[32m Performs maintenance for the Data Sharing Service.
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /disable
echo -%ESC%[32m This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\BthSQM*" /disable
echo -%ESC%[32m License Validation - Windows Store legacy license migration task %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Clip\License Validation" /disable
schtasks /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable
echo -%ESC%[32m Consolidator - If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable
echo -%ESC%[32m The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft. The information received is used to help improve the reliability, stability, and overall functionality of USB in Windows. If the user has not consented to participate in Windows CEIP, this task does not do anything. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable
?schtasks /Change /TN "\Microsoft\Windows\KernelCeipTask*" /disable
?schtasks /Change /TN "\Microsoft\Windows\Uploader*" /disable
echo -%ESC%[32m Microsoft-Windows-DiskDiagnosticDataCollector - The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
echo -%ESC%[32m schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" /disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /disable
echo -%ESC%[32m Property Definition Sync - Synchronizes the File Classification Infrastructure taxonomy on the computer with the resource property definitions stored in Active Directory Domain Services. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync" /disable
:: TempSignedLicenseExchange - Exchanges temporary preinstalled licenses for Windows Store licenses. %ESC%[0m
rem schtasks /Change /TN "\Microsoft\Windows\License Manager\TempSignedLicenseExchange" /disable
echo -%ESC%[32m Location Notification %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Location\Notifications" /disable
schtasks /Change /TN "\Microsoft\Windows\Location\WindowsActionDialog" /disable
echo -%ESC%[32m Measures a system's performance and capabilities %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\Cellular" /disable
echo -%ESC%[32m This task shows various Map related toasts %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /disable
echo -%ESC%[32m This task checks for updates to maps which you have downloaded for offline use. Disabling this task will prevent Windows from notifying you of updated maps. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable
:: Schedules a memory diagnostic in response to system events. %ESC%[0m
:: System Sounds User Mode Agent
schtasks /Change /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" /disable
echo -%ESC%[32m This task gathers information about the Trusted Platform Module (TPM), Secure Boot, and Measured Boot. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\PI\Sqm-Tasks" /disable
echo -%ESC%[32m This task analyzes the system looking for conditions that may cause high energy use. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable
echo -%ESC%[32m This service manages Apps that are pushed to the device from the Microsoft Store App running on other devices or the web. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration" /disable
echo -%ESC%[32m Checks group policy for changes relevant to Remote Assistance %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\BackgroundUploadTask" /disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\NetworkStateChangeTask" /disable
:: 
?schtasks /Change /TN "\Microsoft\Windows\BackupTask*" /disable
echo -%ESC%[32m Initializes Family Safety monitoring and enforcement. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable
echo -%ESC%[32m Synchronizes the latest settings with the Microsoft family features service. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefreshTask" /disable
echo -%ESC%[32m Downloads a backup of your synced theme images %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Shell\ThemesSyncedImageDownload" /disable
schtasks /Change /TN "\Microsoft\Windows\Shell\UpdateUserPictureTask" /disable
echo -%ESC%[32m Keeps the search index up to date %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /disable
schtasks /Change /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask" /disable
echo -%ESC%[32m Enable susbscription license acquisition %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Subscription\EnableLicenseAcquisition" /disable
echo -%ESC%[32m Susbscription license acquisition %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Subscription\LicenseAcquisition" /disable
echo -%ESC%[32m Windows Error Reporting task to process queued reports. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
echo -%ESC%[32m Register this computer if the computer is already joined to an Active Directory domain. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Automatic-Device-Join" /disable
echo -%ESC%[32m Sync device attributes to Azure Active Directory. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Device-Sync" /disable
echo -%ESC%[32m Performs recovery check. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Recovery-Check" /disable
echo -%ESC%[32m This task will automatically upload a roaming user profile's registry hive to its network location. %ESC%[0m
schtasks /Change /TN "\Microsoft\Windows\User Profile Service\HiveUploadTask" /disable


echo %ESC%[35m Removing Telemetry and other unnecessary services: %ESC%[0m
echo -%ESC%[32m Connected User Experience and Telemetry component, also known as the Universal Telemetry Client (UTC)... %ESC%[0m
sc stop DiagTrack
sc delete DiagTrack
echo -%ESC%[32m WAP Push Message Routing Service... Device Management Wireless Application Protocol (WAP) Push message Routing Service — This service is another service that helps to collect and send user data to Microsoft. %ESC%[0m
sc stop dmwappushservice
sc delete dmwappushservice
echo -%ESC%[32m Windows Error Reporting Service Description: Allows errors to be reported when programs stop working or responding ... %ESC%[0m
sc stop WerSvc
sc delete WerSvc
echo -%ESC%[32m Synchronize mail, contacts, calendar and various other user data... %ESC%[0m
sc stop OneSyncSvc
echo -%ESC%[32m Preventing Windows from re-enabling Telemetry services... %ESC%[0m
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1

echo %ESC%[35m System TuneUp %ESC%[0m
echo -%ESC%[32m Optimize prefetch parameters to improve Windows boot-up speed %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d 2
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d 2
echo -%ESC%[32m Reduce Application idlesness at closing to improve shutdown process %ESC%[0m
reg delete "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout"
reg add "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout" /t REG_SZ /d "4000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000"
reg add "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout" /t REG_SZ /d "3000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout" /t REG_SZ /d "10000"
echo -%ESC%[32m Enable optimization feature to improve Windows boot-up speed (HDD only) %ESC%[0m
reg add "HKLM\Software\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "y"
echo -%ESC%[32m System Stability %ESC%[0m
echo -%ESC%[32m Disable automatical reboot when system encounters blue screen %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
echo -%ESC%[32m Disable registry modification from a remote computer %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
echo -%ESC%[32m Set Windows Explorer components to run in separate processes avoiding system conflicts %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "DesktopProcess" /t REG_DWORD /d 1
echo -%ESC%[32m Close frozen processes to avoid system crashes %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "AutoEndTasks" /t REG_SZ /d "1"
echo %ESC%[35m System Speedup %ESC%[0m
echo -%ESC%[32m Remove the word "shortcut" from the shortcut icons %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "link" /t REG_BINARY /d "00000000"
echo -%ESC%[32m Optimize Windows Explorer so that it can automatically restart after an exception occurs to prevent the system from being unresponsive. %ESC%[0m

echo -%ESC%[32m Optimize the visual effect of the menu and list to improve the operating speed of the system. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
echo -%ESC%[32m Optimize refresh policy of Windows file list - DFS Share Refresh Issue -%ESC%[36m https://wiki.ledhed.net/index.php/DFS_Share_Refresh_Issue %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoSimpleNetIDList" /t REG_DWORD /d 1
echo -%ESC%[32m Speed up display speed of Taskbar Window Previews. %ESC%[0m
reg add "HKCU\Control Panel\Mouse" /f /v "MouseHoverTime" /t REG_SZ /d "100"
echo -%ESC%[32m Speed up Aero Snap to make thumbnail display faster. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ExtendedUIHoverTime" /t REG_DWORD /d "0"
echo -%ESC%[32m Optimized response speed of system display. %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "MenuShowDelay" /t REG_SZ /d 0
echo -%ESC%[32m Increase system icon cache and speed up desktop display. %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "Max Cached Icons" /t REG_SZ /d 4096
echo -%ESC%[32m Boost the response speed of foreground programs. %ESC%[0m
reg add "HKCU\Control Panel\Desktop" /f /v "ForegroundLockTimeout" /t REG_DWORD /d 0
echo -%ESC%[32m Boost the display speed of Aero Peek. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "DesktopLivePreviewHoverTime" /t REG_DWORD /d 0
echo -%ESC%[32m Disable memory pagination and reduce disk 1/0 to improve application performance. {Option may be ignored if physical memory is <1 GB) %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
echo -%ESC%[32m Optimize processor performance for execution of applications, games, etc. {Ignore if server} %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
echo -%ESC%[32m Close animation effect when maximizing or minimizing a window to speed up the window response. %ESC%[0m
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /t REG_SZ /d "0"
echo -%ESC%[32m Optimize disk I/O while CPU is idle (HDD only) %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "1"
echo -%ESC%[32m Disable the "Autoplay" feature on drives to avoid virus infection/propagation. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "221"
echo -%ESC%[32m Optimize disk 1/0 subsystem to improve system performance. %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
echo -%ESC%[32m Optimize the file system to improve system performance. %ESC%[0m
reg delete "HKLM\System\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg delete "HKLM\System\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg add "HKLM\System\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
reg add "HKLM\System\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
echo -%ESC%[32m Optimize front end components (dialog box, menus, etc.) appearance to improve system performance. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
echo -%ESC%[32m Optimize memory default settings to improve system performance. %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
echo -%ESC%[32m Disable the debugger to speed up error processing. %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AeDebug" /f /v "Auto" /t REG_SZ /d 0
echo -%ESC%[32m Disable screen error reporting to improve system performance. %ESC%[0m
reg add "HKLM\Software\Microsoft\PCHealth\ErrorReporting" /f /v "ShowUI" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PCHealth\ErrorReporting" /f /v "DoReport" /t REG_DWORD /d 0
echo %ESC%[35m Network Speedup %ESC%[0m
echo -%ESC%[32m Optimize LAN connection. %ESC%[0m
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "nonetcrawling" /t REG_DWORD /d 1
echo -%ESC%[32m Optimize DNS and DNS parsing speed. %ESC%[0m
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
echo -%ESC%[32m Optimize Ethernet card performance. %ESC%[0m
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
echo -%ESC%[32m Optimize network forward ability to improve network performance. %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
echo -%ESC%[32m Optimize network settings to improve communication performance. %ESC%[0m
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
echo -%ESC%[32m Optimize WINS name query time to improve data transfer speed. %ESC%[0m
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
echo -%ESC%[32m Improve TCP/IP performance through automatic detection of "black holes" in routing at Path MTU Discovery technique. %ESC%[0m
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
echo -%ESC%[32m Optimize TTL {Time To Live) settings to improve network performance. %ESC%[0m
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
echo %ESC%[35m SSD optimize %ESC%[0m
echo -%ESC%[32m Disable drive defrag system on boot to extend lifespan of SSD. %ESC%[0m
reg add "HKLM\Software\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "n"
echo -%ESC%[32m Disable auto defrag when idle to extend lifespan of SSD. %ESC%[0m
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "0"
echo -%ESC%[32m Disable prefetch parameters to extend lifespan of SSD. %ESC%[0m
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
echo -%ESC%[32m Enable TRIM function to improve working performance of SSD. %ESC%[0m

echo -%ESC%[32m Install HEVC Video Extensions %ESC%[0m
winget install -e -i --id=9N4WGH0Z6VHQ --source=msstore
winget install -e -i --id=9NMZLZ57R3T7 --source=msstore

taskkill /f /im explorer.exe

IF EXIST WinClean3.ps1 (powershell.exe -ExecutionPolicy Bypass -File ./WinClean.ps1 ) ELSE (msg "%username%" WinClean.ps1 not found! & echo WinClean.ps1 not found! )

echo -%ESC%[32m Update all installed programs %ESC%[0m
winget upgrade --all --silent --force --include-unknown

echo -%ESC%[32m Delete all temporary files %ESC%[0m
del /q /f /s %temp%\* && del /s /q c:\Windows\temp

echo -%ESC%[32m Run Disk Cleanup - Runs Disk Cleanup on Drive C: and removes old Windows Updates. -%ESC%[36m https://ss64.com/nt/cleanmgr.html %ESC%[0m
cleanmgr.exe /d C: /VERYLOWDISK /Autoclean
dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

echo -%ESC%[32m Verify System Files %ESC%[0m
sfc /scannow
echo -%ESC%[32m PC will restart in 10 seconds unless you type: shutdown /a %ESC%[0m
shutdown /r /t 10
:End
