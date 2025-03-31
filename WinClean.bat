Color 07
@echo Self elevate
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights & powershell -Command "Start-Process '%downloaddir%\WinClean\winclean.bat' -Verb runAs" & exit /b 1) > "%downloaddir%\WinClean\admin.log"
if not "%1"=="max" start /max cmd /c %0 max & Exit /b >> CleanUp.log
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}"') do (set downloaddir=%%b)
md %downloaddir%\WinClean
cd %downloaddir%\WinClean
@echo Generate ANSI ESC characters for color codes
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set ESC=%%b
@echo Set Color variables
@echo STYLES
set Bold=%ESC%[1m && set Underline=%ESC%[4m && set Inverse=%ESC%[7m && set Reset=%ESC%[0m
@echo NORMAL FOREGROUND COLORS
set Black=%ESC%[30m && set Red=%ESC%[31m && set Green=%ESC%[32m && set Yellow=%ESC%[33m && set Blue=%ESC%[34m && set Magenta=%ESC%[35m && set Cyan=%ESC%[36m && set White=%ESC%[37m
@echo NORMAL BACKGROUND COLORS
set BBlack=%ESC%[40m && set BRed=%ESC%[41m && set BGreen=%ESC%[42m && set BYellow=%ESC%[43m && set BBlue=%ESC%[44m && set BMagenta=%ESC%[45m && set BCyan=%ESC%[46m && set BWhite=%ESC%[47m
@echo STRONG FOREGROUND COLORS
set LWhite=%ESC%[90m && set SRed=%ESC%[91m && set SGreen=%ESC%[92m && set SYellow=%ESC%[93m && set SBlue=%ESC%[94m && set SMagenta=%ESC%[95m && set SCyan=%ESC%[96m && set SWhite=%ESC%[97m
@echo STRONG BACKGROUND COLORS
set SBBlack=%ESC%[100m && set SBRed=%ESC%[101m && set SBGreen=%ESC%[102m && set SBYellow=%ESC%[103m && set SBBlue=%ESC%[104m && set SBMagenta=%ESC%[105m && set SBCyan=%ESC%[106m && set SBWhite=%ESC%[107m
@echo COMBINATIONS: inverse foreground-background %ESC%[7m , inverse red foreground color %ESC%[7;31m , and nested %ESC%[7m before %ESC%[31m  nested , nested %ESC%[7m %ESC%[31m before %ESC%[7m  nested %ESC%[0m
@echo %Bold%- Commands sintax and utils @ %Cyan% https://ss64.com %Reset%
@echo "Color" Sets the default console foreground and background colours. %Cyan% https://ss64.com/nt/color.html %Reset%

@echo %Bold%- Changed the Encoding to chcp 65001 > nul %SCyan% [ Unicode Encoding ] %Reset%
chcp 65001 > nul

@echo -%Green% Save important PC information to Documents\PC-info %Reset% -%Cyan% https://www.tenforums.com/tutorials/3443-view-user-account-details-windows-10-a.html %Reset%
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardManufacturer"') do (set mb=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardProduct"') do (set model=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" /v "ProcessorNameString"') do (set cpu=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (set docdir=%%b)
@echo %cpu% on %mb% - %model%
md "%docdir%\%mb% %model% PC-info"
@echo -%Green% Add date and time to files %Reset%
set today=%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%h%time:~3,2%m%time:~6,2%
@echo -%Green% Export Environment Variables -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Environment-Variables.txt %Reset%
set >> "%docdir%\%mb% %model% PC-info\%today%_Environment-Variables.txt"
::  use a simple for loop in the cmd prompt to import back all the variables:
:: for /F %a in (Environment-Variables.txt) do SET %a
wmic useraccount list full >"%docdir%\%mb% %model% PC-info\%today%_UserAccountDetails.txt"
@echo -%Green% Export WiFi passwords -%Cyan% https://www.elevenforum.com/t/backup-and-restore-wi-fi-network-profiles-in-windows-11.4472/ %Reset%
netsh wlan show profiles
netsh wlan export profile key=clear folder="%docdir%\%mb% %model% PC-info"
:: To import several profiles at once, you can use a loop in the command prompt:
:: for %a in (*.xml) do netsh wlan add profile filename="%a"
@echo -%Green% Check if Users are a Microsoft account or Local account -%Cyan% https://www.tenforums.com/tutorials/5387-how-tell-if-local-account-microsoft-account-windows-10-a.html %Reset%
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-LocalUser | Select-Object Name,PrincipalSource | Out-File -filepath '%docdir%\%mb% %model% PC-info\%today%_All_Accounts.txt'"
@echo -%SGreen% List all Optional Capabilities - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Capability-listing-before-cleanup.txt %Reset%
dism /Online /Get-Capabilities /Format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Capability-listing-before-cleanup.txt"
@echo -%SGreen% List all Optional Features - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Features-listing-before-cleanup.txt %Reset%
dism /Online /Get-Features /Format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Features-listing-before-cleanup.txt"
@echo -%SGreen% List of Provisioned Application Packages - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_AppPackages-before-cleanup.txt %Reset%
dism /Online /Get-ProvisionedAppxPackages > "%docdir%\%mb% %model% PC-info\%today%_AppPackages-before-cleanup.txt"
@echo -%SGreen% List of Drivers - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Drivers.txt %Reset%
dism /Online /Get-Drivers /format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Drivers.txt"
@echo -%SGreen% List of Packages - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Packages.txt %Reset%
dism /Online /Get-Packages /format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Packages.txt"
@echo -%SGreen% International Settings - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_International-Settings.txt %Reset%
dism /Online /Get-Intl > "%docdir%\%mb% %model% PC-info\%today%_International-Settings.txt"
@echo -%SGreen% Saving PC information to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_SystemInfo.txt %Reset%
systeminfo > "%docdir%\%mb% %model% PC-info\%today%_SystemInfo.txt"
systeminfo /FO CSV > "%docdir%\%mb% %model% PC-info\%today%_SystemInfo.csv"
msinfo32 /report "%docdir%\%mb% %model% PC-info\%today%_Detailed-System-Information-MSInfo32.txt"
@echo -%SGreen% Windows Version Information - -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-version.txt %Reset%
ver > "%docdir%\%mb% %model% PC-info\%today%_Windows-version.txt"
@echo -%SGreen% Export Current Tasks to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Tasks-before-cleanup.csv %Reset%
schtasks /query /v /fo CSV > "%docdir%\%mb% %model% PC-info\%today%_Tasks-before-cleanup.csv"
@echo -%SGreen% Export Windows Services to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Services-before-cleanup.csv %Reset%
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-CIMInstance -Class Win32_Service | Select-Object Name, DisplayName, Description, StartMode, DelayedAutoStart, StartName, PathName, State, ProcessId | Export-CSV -Path '%docdir%\%mb% %model% PC-info\%today%_Services-before-cleanup.csv'"
sc query state=all > "%docdir%\%mb% %model% PC-info\%today%_All-Services-before-cleanup.txt"
sc query > "%docdir%\%mb% %model% PC-info\%today%_Running-Services-before-cleanup.txt"
net start > "%docdir%\%mb% %model% PC-info\%today%_List-of-Running-Services-before-cleanup.txt"
@echo -%SGreen% Please Backup your credentials to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Credentials.crd %Reset% by running: %Cyan%Rundll32.exe keymgr.dll,KRShowKeyMgr%Reset%
Rundll32.exe keymgr.dll,KRShowKeyMgr
@echo -%SGreen% Export Windows Product Key to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Product-Key.txt %Reset%
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "BackupProductKeyDefault"') do (echo %%b > "%docdir%\%mb% %model% PC-info\%today%_Windows-Backup-Product-Key.txt")

for /f "delims=: tokens=*" %%x in ('findstr /b ::: "%~f0"') do @echo(%%x
@echo %SWhite% 
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
@echo -%SRed%Please read carefully before proceding! %Reset%
@echo -%SYellow% Cleaning up Windows 10 and 11 could be a long process with many detailed steps, we're trying to cover most of them automatically. %Reset%
@echo -%SYellow% This is a long script and it can take (from my tests) anywhere between 10-30 minutes depending on the computer speed.
@echo The scrips will run automatically removing most of the bloatware and leaving a clean and lightweight Operating System
@echo %SCyan% Important Notes:
@echo %SWhite%- computer needs to be signed in locally,%SRed% not with a Microsoft Account%SWhite% , this script will disable Microsoft Syncronization, so a previous change to %SGreen%Local Account%SWhite%  is necesary
@echo - this script will %ESC%[95mdisable the Gaming platform and all cloud Syncronization %SWhite% 
@echo - this script will remove a lot of %ESC%[95mbackground tasks and most of the Microsoft Store Apps %SWhite% 
@echo - the script is self explanatory, lines of descriptione listed on every step
@echo - to speed up user experience and reduce eye strain the background is removed, %ESC%[94mColor Scheme turned to Dark, and Sound Scheme to no sounds! %SWhite% 
@echo - the "hosts" file contains a list of bad websites, known for moral or controversial issues! Loaded to the right place, it will provide a first-hand protection to any computer. It may be attacked by some Antivirus Software.
@echo - While this is a big list of cleanup commands, it is not complete. Further cleaning is recommended by using a few Portable Apps from%SCyan%  https://portableapps.com/apps/utilities %Reset%like:
@echo 	- PrivaZer -%SCyan%  https://portableapps.com/apps/utilities/privazer-portable %Reset%
@echo 	- Revo Uninstaller -%SCyan%  https://portableapps.com/apps/utilities/revo_uninstaller_portable %Reset%
@echo 	- Wise Disk Cleaner -%SCyan%  https://portableapps.com/apps/utilities/wise-disk-cleaner-portable %Reset%
@echo 	- Wise Registry Cleaner -%SCyan%  https://portableapps.com/apps/utilities/wise-registry-cleaner-portable %Reset%
@echo 	- ccPortable -%SCyan%  https://portableapps.com/apps/utilities/ccportable %Reset%
@echo 	- "O&O ShutUp10++" -%SCyan%  https://www.oo-software.com/en/shutup10 %Reset%

msg "%username%" Please make sure you: Read the explanations before continuing!

:Menu
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-LocalUser | Select-Object Name,PrincipalSource"
@echo 	%ESC%[101;93m WARNING %Reset%
@echo %Yellow% ----------------------------- %Reset%
@echo %SRed% If you see a%Reset% %ESC%[41mMicrosoftAccount%Reset% %SRed%in the above list, please stop and switch to%Reset% %Green%Local Account%Reset%
@echo   %Bold%(%Reset%%ESC%[31mU%Reset%%Bold%)%Reset% Open User Accounts
@echo   %Bold%(%Reset%%ESC%[31mC%Reset%%Bold%)%Reset% Continue
@echo   %Bold%(%Reset%%ESC%[31mX%Reset%%Bold%)%Reset% STOP
@echo / & CHOICE /C UCX /N /M "Enter Selection:"
IF %errorlevel%==1 START "" Rundll32.exe shell32.dll,Control_RunDLL nusrmgr.cpl
IF %errorlevel%==2 START "" exit /b & goto Continue
IF %errorlevel%==3 START "" exit /b & exit /b
goto Menu
:Continue
@echo -%Green% Rename C: Drive to Windows-OS %Reset%
label C: Windows-OS
:: Changed the Encoding to chcp utf-8
chcp 1252 > nul
@echo -%Green% Set Time to UTC (Dual Boot) Essential for computers that are dual booting. Fixes the time sync with Linux Systems. %Reset%
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /f /v RealTimeIsUniversal /t REG_DWORD /d 1

:: Rename computer: wmic computersystem where caption='current_pc_name' rename new_pc_name
:: Rename a remote computer on the same network: wmic /node:"Remote-Computer-Name" /user:Admin /password:Remote-Computer-password computersystem call rename "Remote-Computer-New-Name"
:: Rename computer to Work-PC
rem wmic computersystem rename Work-PC
:: Disable Hyper-V:
rem bcdedit /set hypervisorlaunchtype off
rem dism /Online /NoRestart /Disable-Feature:Microsoft-Hyper-V

@echo -%Green% To prevent a specific update from installing Download the "Show or hide updates" troubleshooter package from the Microsoft website: %Cyan% https://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab %Reset%
powershell -c "Invoke-WebRequest -Uri 'https://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab' -OutFile '%docdir%\%mb% %model% PC-info\%today%_wushowhide.diagcab'"

@echo -%Green% Microsoft Edge uninstall %Reset%
IF EXIST Edge-uninstall.ps1 (powershell.exe -ExecutionPolicy Bypass -File ./Edge-uninstall.ps1 ) ELSE (msg "%username%" Edge-uninstall.ps1 not found! & echo Edge-uninstall.ps1 not found! )

@echo -%Green% Microsoft OneDrive uninstall %Reset%
IF EXIST OneDrive-uninstall.ps1 (powershell.exe -ExecutionPolicy Bypass -File ./OneDrive-uninstall.ps1 ) ELSE (msg "%username%" OneDrive-uninstall.ps1 not found! & echo OneDrive-uninstall.ps1 not found! )

@echo -%Green% Removing OneDrive leftovers. %Reset%
set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
@echo -%Green% Closing OneDrive process. %Reset%
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

@echo -%Green% Removing OneDrive from the Explorer Side Panel. %Reset%
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
del /Q /F "%localappdata%\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe"
del /Q /F "%UserProfile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

@echo -%Green% Prefer IPv4 over IPv6: To set the IPv4 preference can have latency and security benefits on private networks where IPv6 is not configured. %Reset%
reg add "HKLM\System\CurrentControlSet\Services\Tcpip6\Parameters" /f /v DisabledComponents /t REG_DWORD /d 255

@echo -%Green% Disable Wifi-Sense: Wifi Sense is a spying service that phones home all nearby scanned wifi networks and your current geo location. %Reset%
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /f /v "Value" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /f /v "Value" /t REG_DWORD /d 0

@echo -%Green% Enable End Task With Right Click - Enables option to end task when right clicking a program in the taskbar %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /f /v TaskbarEndTask /t REG_DWORD /d 1

@echo -%Green% Remove Home and Gallery from explorer %Reset%
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d "1"
	 
@echo %Magenta% Turn Off System Protection for All Drives %Reset%
@echo -%Green% Created by: Shawn Brink; Created on: December 27, 2021; Tutorial: %Cyan% https://www.elevenforum.com/t/turn-on-or-off-system-protection-for-drives-in-windows-11.3598/ %Reset%
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}"
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /f /v "RPSessionInterval" /t REG_DWORD /d "0"
wmic /Namespace:\\root\default Path SystemRestore Call Disable "C:\" & :: C-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "D:\" & :: D-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "E:\" & :: E-drive

wmic /Namespace:\\root\default Path SystemRestore Call Disable "F:\" & :: F-drive

@echo -%Green% Disable Hybernation %Reset%
powercfg -h off
powercfg.exe /hibernate off
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /f /v HibernateEnabled /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /f /v ShowHibernateOption /t REG_DWORD /d 0

@echo -%Green% Decrypt Bitlocker (useless resource hog abused by Microsoft, unless sensitive data has to be protected) %Reset%
manage-bde -status
manage-bde -off C:
manage-bde -off D:
manage-bde -off E:
manage-bde -off F:

@echo -%Green% Disable Copilot %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsCopilot" /f /v TurnOffWindowsCopilot /t REG_DWORD /d 1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /f /v TurnOffWindowsCopilot /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowCopilotButton /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Edge" /f /v HubsSidebarEnabled" /t REG_DWORD /d 0

@echo -%Green% Disable Ads in Windows 11 - Source %Cyan% https://www.elevenforum.com/t/disable-ads-in-windows-11.8004/ %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowSyncProviderNotifications /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_IrisRecommendations /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_AccountNotifications /t REG_DWORD /d 0

@echo -%Green% Remove Settings Home page in Windows 11; Created by: Shawn Brink; Created on: June 30, 2023; Tutorial: %Cyan% https://www.elevenforum.com/t/add-or-remove-settings-home-page-in-windows-11.16017/ %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "SettingsPageVisibility" /t REG_SZ /d "hide:home"

@echo -%Magenta% Turn Off Suggested Content in Settings: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: %Cyan% https://www.elevenforum.com/t/enable-or-disable-suggested-content-in-settings-in-windows-11.3791/ %Reset%
@echo -%Green% Lock screen Spotlight - New backgrounds, tips, advertisements etc. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0

@echo -%Magenta% To Turn Off App Suggestions in Start: source %Cyan% https://forums.mydigitallife.net/threads/windows-10-guide-for-remove-and-stop-apps-bundle-and-more-tweaks.76030/ %Reset%
@echo -%Green% Disable from OEM Preinstalled Apps %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Preinstalled Apps in Windows 10 %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Windows Spotlight %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Get fun facts, tips, tricks, and moe on your lock screen %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable from SyncProviders - OneDrive %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280810Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from OneDrive %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280811Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Windows Ink - StokedOnIt %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280813Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Windows Spotlight %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-202914Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Share - Facebook, Instagram and etc. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-280815Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310091Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310092Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338380Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from BingWeather, Candy Crush and etc. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-314559Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Windows Maps %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338381Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from My People Suggested Apps %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-314563Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Timeline Suggestions %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Occasionally show suggestions in Start %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Get tips, tricks and suggestion as you use Windows and Cortana %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Show me suggested content in the Settings app %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-88000326Enabled" /t REG_DWORD /d 0

@echo -%Magenta% Disable Start Menu Suggestions %Reset%
@echo -%Green% Disable from Occassionally showing app suggestions in Start Menu %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0
@echo -%Green% To Disable Automatically Installing Suggested Apps %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "FeatureManagementEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Subsribed Content status Suggested Apps %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContentEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable Spotlight %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SlideshowEnabled" /t REG_DWORD /d 0
@echo -%Green% Disable from Tips, tricks and suggestions while using Windows %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SoftLandingEnabled" /t REG_DWORD /d 0

@echo -%Green% Clear and Reset Quick Access Folders %Reset%
del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms"

@echo -%Green% Increase the number of recent files displayed in the task bar %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "JumpListItems_Maximum " /t REG_DWORD /d 30

@echo -%Green% Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Holographic" /f /v "FirstRunSucceeded " /t REG_DWORD /d 0

@echo %Magenta% Remove Optional Capabilities %Reset%
@echo -%Green% Microsoft Recall uninstall %Reset%
Dism /Online /Disable-Feature /Featurename:Recall
@echo -%Green% "Remove Windows Media Player:" %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0
@echo -%Green% "Remove Feature: Extended Inbox Theme Content:" %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~
dism /Online /NoRestart /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~0.0.1.0
@echo -%Green% "Remove Feature: Microsoft Quick Assist:" %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:App.Support.QuickAssist~~~~0.0.1.0
@echo -%Green% "Remove Hello Face:" %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:Hello.Face.18967~~~~0.0.1.0
dism /Online /NoRestart /Remove-Capability /CapabilityName:Hello.Face.Migration.18967~~~~0.0.1.0
dism /Online /NoRestart /Remove-Capability /CapabilityName:Hello.Face.20134~~~~0.0.1.0
@echo -%Green% "Remove Math Recognizer:" %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0
@echo -%Green% "Remove Onesync Feature: Exchange ActiveSync and Internet Mail Sync Engine:" %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~~~0.0.1.0
@echo -%Green% Turn off Steps Recorder - Source %Cyan% "https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.ApplicationCompatibility::AppCompatTurnOffUserActionRecord" %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /f /v "DisableUAR" /t REG_DWORD /d "1"
dism /Online /NoRestart /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0
@echo -%Green% Remove Feature: Windows Feature Experience Pack %Reset%
dism /Online /NoRestart /Remove-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0
@echo -%Green% "Remove Internet Printing:" %Reset%

@echo -%Green% "Remove Work Folders:" %Reset%

@echo -%Green% "Remove Contact Support:" %Reset%

@echo -%Green% "Remove Language Speech:" %Reset%

@echo %Magenta% Add Optional Capabilities %Reset%
@echo -%Green% Add Feature: Print Fax Scan %Reset%
dism /Online /NoRestart /Add-Capability /CapabilityName:Print.Fax.Scan~~~~0.0.1.0
@echo -%Green% Add Feature: WMIC. A Windows Management Instrumentation (WMI) command-line utility. %Reset%
dism /Online /NoRestart /Add-Capability /CapabilityName:WMIC~~~~
@echo -%Green% Add .NET Framework %Reset%
dism /Online /NoRestart /Add-Capability /CapabilityName:NetFX3~~~~
@echo %SGreen% List all Optional Capabilities - Save to %docdir%\%mb% %model% PC-info %Reset%
dism /Online /Get-Capabilities /Format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Capability-listing-after-cleanup.txt"

@echo %Magenta% Enable High Performance Power Scheme %Reset%
powercfg /l
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /x monitor-timeout-ac 10
powercfg /x monitor-timeout-dc 10
powercfg /x disk-timeout-ac 20
powercfg /x disk-timeout-dc 20
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 15
@echo -%Green% Critical battery action: No action is taken when the critical battery level is reached. %Reset%
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 0 

@echo -%Magenta% Change to Dark Theme: %Reset%
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

@echo -%Green% Quiet down Windows Security stopping unnecessary notifications %Reset%
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableNotifications" /t REG_DWORD /d "1"
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableWindowsHelloNotifications" /t REG_DWORD /d "1"
reg add "HKCU\Software\Microsoft\Windows Defender Security Center\Account protection" /f /v "DisableDynamiclockNotifications" /t REG_DWORD /d "1"

@echo -%Green% Disable Collect Activity History: Created by: Shawn Brink on: December 14th 2017; Tutorial: %Cyan% https://www.tenforums.com/tutorials/100341-enable-disable-collect-activity-history-windows-10-a.html %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "EnableActivityFeed" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "PublishUserActivities" /t REG_DWORD /d 0
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\System" /f /v "UploadUserActivities" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /f /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1

@echo -%Green% Add Windows Defender ExclusionPath to enable host protection: %Reset%
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%UserProfile%\Downloads\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%downloaddir%\WinClean\'"
powershell -inputformat none -outputformat none -NonInteractive -Command "Add-MpPreference -ExclusionPath '%SystemRoot%\System32\drivers\etc\hosts'"

@echo -%Green% Transfer Hosts File: %Reset%
IF EXIST hosts (copy /D /V /Y hosts %SystemRoot%\System32\drivers\etc\hosts ) ELSE (msg "%username%" hosts file not found! & echo hosts file not found! )

@echo -%Green% Turn off background apps + Privacy settings; Created by: Shawn Brink; Created on: October 17th 2016: Tutorial: %Cyan% http://www.tenforums.com/tutorials/7225-background-apps-turn-off-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /f /v "GlobalUserDisabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /f /v "Value" /t REG_SZ /d "Deny"
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /f /v "VoiceActivationOn" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /f /v "ModelDownloadAllowed" /t REG_DWORD /d 0

@echo -%Green% Turn Off Website Access of Language List: Created by: Shawn Brink on: April 27th 2017; Tutorial: %Cyan% https://www.tenforums.com/tutorials/82980-turn-off-website-access-language-list-windows-10-a.html %Reset%
reg add "HKCU\Control Panel\International\User Profile" /f /v "%Cyan% httpAcceptLanguageOptOut" /t REG_DWORD /d 1
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Language Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Hotkey" /t REG_SZ /d "2"
reg add "HKCU\Keyboard Layout\Toggle" /f /v "Layout Hotkey" /t REG_SZ /d "3"

@echo %Magenta% Settings » privacy » general » app permissions: "Setting App Permissions." %Reset%
@echo -%Green% Next statements will deny access to the following apps under Privacy - - Setting anyone of these back to allow allows toggle functionality %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Disable app diag info about your other apps %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access calendar %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access other devices %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetooth" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access your file system %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access messaging %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access your contacts %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access Documents %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not Allow apps to access email %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\humanInterfaceDevice" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Disable Location Tracking %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /f /v "SensorPermissionState" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\lfsvc\Service\Configuration" /f /v "Status" /t REG_DWORD /d 0
reg add "HKLM\System\Maps" /f /v "AutoUpdateEnabled" /t REG_DWORD /d 0
@echo -%Green% Do not allow apps to access microphone %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /f /v "Value" /t REG_SZ /d Allow
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access call history %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access Pictures %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access radio %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\usb" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access Account Information %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access tasks %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access Notifications %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% Do not allow apps to access Videos %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /f /v "Value" /t REG_SZ /d Deny
@echo -%Green% App access turn off camera %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /f /v "Value" /t REG_SZ /d Allow
@echo -%Green% App access turn off WIFI %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /f /v "Value" /t REG_SZ /d Deny
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wiFiDirect" /f /v "Value" /t REG_SZ /d Deny

@echo %Magenta% Settings » privacy » general » windows permissions "Setting General Windows Permissions.": From %Cyan% https://admx.help/HKLM/Software/Policies/Microsoft/Windows/AppPrivacy %Reset%
@echo -%Green% Windows apps access user movements while running in the background %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessBackgroundSpatialPerception" /t REG_DWORD /d 2
@echo -%Green% Windows apps activate with voice while the system is locked %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoiceAboveLock" /t REG_DWORD /d 2
@echo -%Green% Windows apps activate with voice %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsActivateWithVoice" /t REG_DWORD /d 2
@echo -%Green% Windows apps access an eye tracker device %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGazeInput" /t REG_DWORD /d 2
@echo -%Green% Windows apps access diagnostic information about other apps %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d 2
@echo -%Green% Windows apps run in the background %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsRunInBackground" /t REG_DWORD /d 2
@echo -%Green% Windows apps access trusted devices %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTrustedDevices" /t REG_DWORD /d 2
@echo -%Green% Windows apps access Tasks %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessTasks" /t REG_DWORD /d 2
@echo -%Green% Windows apps communicate with unpaired devices %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2
@echo -%Green% Windows apps control radios %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessRadios" /t REG_DWORD /d 2
@echo -%Green% Windows apps make phone calls %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessPhone" /t REG_DWORD /d 2
@echo -%Green% Windows apps access notifications %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessNotifications" /t REG_DWORD /d 2
@echo -%Green% Windows apps access motion %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMotion" /t REG_DWORD /d 2
@echo -%Green% Windows apps access the microphone %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMicrophone" /t REG_DWORD /d 0
@echo -%Green% Windows apps access messaging %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessMessaging" /t REG_DWORD /d 2
@echo -%Green% Windows apps access location %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessLocation" /t REG_DWORD /d 2
@echo -%Green% Windows apps turn off the screenshot border %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureWithoutBorder" /t REG_DWORD /d 2
@echo -%Green% Windows apps take screenshots of various windows or displays %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessGraphicsCaptureProgrammatic" /t REG_DWORD /d 2
@echo -%Green% Windows apps access email %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessEmail" /t REG_DWORD /d 2
@echo -%Green% Windows apps access contacts %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessContacts" /t REG_DWORD /d 2
@echo -%Green% Windows apps access the camera %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCamera" /t REG_DWORD /d 0
@echo -%Green% Windows apps access call history %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2
@echo -%Green% Windows apps access the calendar %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessCalendar" /t REG_DWORD /d 2
@echo -%Green% Windows apps access account information %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 2

@echo -%Green% Disable App Launch Tracking: Created by: Shawn Brink; Created on: January 3, 2022; Tutorial: %Cyan% https://www.elevenforum.com/t/enable-or-disable-app-launch-tracking-in-windows-11.3727/ %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Start_TrackProgs" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\EdgeUI" /f /v "DisableMFUTracking" /t REG_DWORD /d 1

@echo -%Green% Disabling Windows Notifications %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "DatabaseMigrationCompleted" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "ToastEnabled" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoCloudApplicationNotification" /t REG_DWORD /d 1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d 0

@echo -%Green% Removes 3D Objects from the 'My Computer' submenu in explorer %Reset%
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f

@echo -%Green% settings » privacy » general » let apps use my ID ... %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Enabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /f /v "DisabledByGroupPolicy" /t REG_DWORD /d 1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v "Id"

@echo -%Green% Turn Off Personal Inking and Typing Dictionary: Created by: Shawn Brink; Created on: January 5, 2022; Tutorial: %Cyan% https://www.elevenforum.com/t/enable-or-disable-personal-inking-and-typing-dictionary-in-windows-11.5564/ %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization" /f /v "Value" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization" /f /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /f /v "HarvestContacts" /t REG_DWORD /d 0

@echo -%Green% Disable Windows Search Box... and web search in the search box Created by: Shawn Brink on: May 4th 2019 Tutorial: %Cyan% https://www.tenforums.com/tutorials/2854-hide-show-search-box-search-icon-taskbar-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "BingSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlStatus" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "WebControlSecondaryStatus" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /f /v "SearchboxTaskbarMode" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "SearchOnTaskbarMode" /t REG_DWORD /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1

@echo -%Green% Enable Admin Shares... %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\system" /f /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1

@echo -%Green% Remove the Limit local account use of blank passwords to console logon only... %Reset% (disabled now for security)
rem reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v "LimitBlankPasswordUse" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v "LimitBlankPasswordUse" /t REG_DWORD /d 1

@echo -%Green% Enable Local Security Authority Protection... %Reset%
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /f /v RunAsPPL /t REG_DWORD /d 1

@echo -%Green% Disable Windows Feedback... %Reset%
reg add "HKCU\Software\Microsoft\Siuf\Rules" /f /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0
reg delete "HKCU\Software\Microsoft\Siuf\Rules" /f /v "PeriodInNanoSeconds"
reg add "HKLM\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f /v "Start" /t REG_DWORD /d 0
@echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
@echo y|cacls  C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl  /d SYSTEM
rem reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKCU\Software\Microsoft\Internet Explorer\PhishingFilter" /f /v "EnabledV9" /t REG_DWORD /d 0
rem reg add "HKLM\Software\Policies\Microsoft\Windows\System" /f /v "EnableSmartScreen" /t REG_DWORD /d 0

@echo -%Green% Disabling Cortana... %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCortana" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search and Cortana application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

@echo -%Green% Turn off Windows Error reporting... %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /f /v "Disabled" /t REG_DWORD /d 1

@echo -%Green% No license checking... removed now %Reset%
rem reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f /v "NoGenTicket" /t REG_DWORD /d 1
reg delete "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f

@echo -%Green% Disable app access to Voice activation... %Reset%
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /f /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d 0

@echo -%Green% Disable sync... %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSync" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /f /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 

@echo -%Green% No Windows Tips... %Reset%
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableSoftLanding" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /f /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /f /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\WindowsInkWorkspace" /f /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d 0

@echo -%Green% Disabling live tiles... %Reset%
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v "NoTileApplicationNotification" /t REG_DWORD /d 1

@echo -%Green% Debloat Microsoft Edge using Registry - Disables various telemetry options, popups, and other annoyances in Edge. %Reset%
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

@echo -%Green% settings » privacy » general » speech, inking, typing %Reset%
reg add "HKCU\Software\Microsoft\Personalization\Settings" /f /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" /f /v "AllowLinguisticDataCollection" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Input\TIPC" /f /v "Enabled" /t REG_DWORD /d 0

@echo -%Green% Disables Autoplay and Turn Off AutoRun in Windows %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /f /v "DisableAutoplay" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255"

@echo -%Green% Disable Low Disk Space Checks in Windows -%Cyan% https://www.lifewire.com/how-to-disable-low-disk-space-checks-in-windows-vista-2626331 %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoLowDiskSpaceChecks" /t REG_DWORD /d 1

@echo -%Green% Windows 11 Explorer use compact mode and restore Classic Context Menu %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v UseCompactMode /t REG_DWORD /d 1
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f

@echo -%Green% Disables Meet Now Chat and Microsoft Teams; Remove Chat from the taskbar in Windows 11 %Reset%
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f /v "com.squirrel.Teams.Teams"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "HideSCAMeetNow" /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarMn /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3

@echo -%Green% Turn off News and Interests %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /f /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarDa" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Feeds" /f /v "EnableFeeds" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Dsh" /f /v "AllowNewsAndInterests" /t REG_DWORD /d 0
powershell -noprofile -executionpolicy bypass -command "Get-AppxPackage -Name *WebExperience* | Foreach {Remove-AppxPackage $_.PackageFullName}"
powershell -noprofile -executionpolicy bypass -command "Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match 'WebExperience' } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }"

@echo -%Green% Turn off Suggest Ways I can finish setting up my device: Created by: Shawn Brink on: July 31, 2019; Tutorial: %Cyan% https://www.tenforums.com/tutorials/137645-turn-off-get-even-more-out-windows-suggestions-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /f /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0

@echo -%Green% Turn off Game Mode: Created by: Shawn Brink on: January 27th 2016; Updated on: November 6th 2017; Tutorial: %Cyan% https://www.tenforums.com/tutorials/75936-turn-off-game-mode-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\GameBar" /f /v "AllowAutoGameMode" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\GameBar" /f /v "AutoGameModeEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /f /v "AppCaptureEnabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_Enabled" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d 0
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1
reg add "HKCU\System\GameConfigStore" /f /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /f /v "AllowGameDVR" /t REG_DWORD /d 0

@echo -%Green% Turn off Cloud Content Search for Microsoft Account: Created by: Shawn Brink on: September 18, 2022; Tutorial: %Cyan% https://www.elevenforum.com/t/enable-or-disable-cloud-content-search-in-windows-11.5378/ %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsAADCloudSearchEnabled" /t REG_DWORD /d 0
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /f /v "AllowCloudSearch" /t REG_DWORD /d 0

@echo -%Green% Removing CloudStore from registry if it exists %Reset%
taskkill /f /im explorer.exe
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore /f
start explorer.exe

@echo -%Green% Turn Off Device Search History: Created by: Shawn Brink on: September 18, 2020; Tutorial: %Cyan% https://www.tenforums.com/tutorials/133365-turn-off-device-search-history-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /f /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0

@echo -%Green% Remove Duplicate Drives in Navigation Pane of File Explorer: Created by: Shawn Brink: Tutorial: %Cyan% https://www.tenforums.com/tutorials/4675-drives-navigation-pane-add-remove-windows-10-a.html; %Cyan% https://www.winhelponline.com/blog/drives-listed-twice-explorer-navigation-pane/ %Reset%
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /f /v "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /t REG_DWORD /d 1

@echo -%Green% Disable Pin Store to Taskbar for All Users: Created by: Shawn Brink; Tutorial: %Cyan% http://www.tenforums.com/tutorials/47742-store-enable-disable-pin-taskbar-windows-8-10-a.html; %Cyan% https://www.elevenforum.com/t/enable-or-disable-show-pinned-items-on-taskbar-in-windows-11.3650/ %Reset%
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "NoPinningStoreToTaskbar" /t REG_DWORD /d 1

@echo -%Green% Disable Pin People icon on Taskbar: Created by: Shawn Brink; Created on: February 23rd 2018ș Tutorial: %Cyan% https://www.tenforums.com/tutorials/104877-enable-disable-people-bar-taskbar-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /f /v "PeopleBand" /t REG_DWORD /d "0"
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /f /v "HidePeopleBar" /t REG_DWORD /d "1"

@echo -%Green% Choose which folders appear on start: To force a pinned folder to be visible, set the corresponding registry values to 1 (both values must set); to force it to be hidden, set the "_ProviderSet" value to 1 and the other one to 0; to let the user choose "_ProviderSet" value to 0 or delete the values. %Cyan% https://social.technet.microsoft.com/Forums/en-US/dbe85f3d-52a8-4852-a784-7bac64a9fa78/controlling-1803-quotchoose-which-folders-appear-on-startquot-settings?forum=win10itprosetup#3b488a59-cefe-4947-8529-944475c452d5 %Reset%
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

@echo -%Green% Add User's Files Desktop Icon: Created by: Shawn Brink; Tutorial: %Cyan% http://www.tenforums.com/tutorials/6942-desktop-icons-add-remove-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /f /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0

@echo -%Green% Hide Unused User's Profile Personal Folders like 3D,Saved Games,Searches: Created by: Shawn Brink; Created on: April 13th 2018; Tutorial: %Cyan% https://www.tenforums.com/tutorials/108032-hide-show-user-profile-personal-folders-windows-10-file-explorer.html %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d1d3a04-debb-4115-95cf-2f29da2920da}\PropertyBag" /f /v "ThisPCPolicy" /d "Hide"

:: Windows Explorer Tweaks: Hidden Files,Expand to Current %Reset%
:: Change your Visual Effects Settings: %Cyan% https://www.tenforums.com/tutorials/6377-change-visual-effects-settings-windows-10-a.html %Reset%
:: 0 = Let Windows choose what’s best for my computer
:: 1 = Adjust for best appearance
:: 2 = Adjust for best performance
:: 3 = Custom ;This disables the following 8 settings:Animate controls and elements inside windows;Fade or slide menus into view;Fade or slide ToolTips into view;Fade out menu items after clicking;Show shadows under mouse pointer;Show shadows under windows;Slide open combo boxes;Smooth-scroll list boxes %Reset%
@echo -%Green% Open File Explorer to: This PC %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "LaunchTo" /t REG_DWORD /d 1
@echo -%Green% Show hidden files, folders, and drives %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Hidden" /t REG_DWORD /d 1
@echo -%Green% Hide protected operating system files (Recommended) %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ShowSuperHidden" /t REG_DWORD /d 0
@echo -%Green% Hide Desktop icons %Reset%
:: reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideIcons" /t REG_DWORD /d 1
@echo -%Green% Hide extensions for known file types %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "HideFileExt" /t REG_DWORD /d 0
@echo -%Green% Navigation pane: Expand to open folder %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneExpandToCurrentFolder" /t REG_DWORD /d 1
@echo -%Green% Navigation pane: Show all folders %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "NavPaneShowAllFolders" /t REG_DWORD /d 1

@echo -%Green% Change Visual Effects Settings for Best Performance and best looking %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /f /v "VisualFXSetting" /t REG_DWORD /d 3
@echo -%Green% Animate controls and elements inside windows - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Animate windows when minimizing and maximizing - off %Reset%
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /d 0
@echo -%Green% Animations in the taskbar - off %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
@echo -%Green% Enable Peek - off: Created by: Shawn Brink; Created on: April 14th 2016; Updated on: May 23rd 2019; Tutorial: %Cyan% https://www.tenforums.com/tutorials/47266-turn-off-peek-desktop-windows-10-a.html %Reset%
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "EnableAeroPeek" /t REG_DWORD /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v DisablePreviewDesktop /t REG_DWORD /d 1
@echo -%Green% Fade or slide menus into view - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Fade or slide ToolTips into view - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Fade out menu items after clicking - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Save taskbar thumbnail previews - off %Reset%
reg add "HKCU\Software\Microsoft\Windows\DWM" /f /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0
@echo -%Green% Show shadows under mouse pointer %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Show shadows under windows %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Show thumbnails instead of icons %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "IconsOnly" /t REG_DWORD /d 0
@echo -%Green% Show translucent selection rectangle - off %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
@echo -%Green% Show window contents while dragging - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "DragFullWindows" /d 0
@echo -%Green% Slide open combo boxes - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Smooth edges of screen fonts %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "FontSmoothing" /t REG_SZ /d "2"
@echo -%Green% Smooth-scrool list boxes - off %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032078090000000"
@echo -%Green% Use drop shadows for icon labels on the desktop %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewShadow" /t REG_DWORD /d 0
@echo -%Green% Move the Start button to the Left Corner: %Reset%
taskkill /f /im explorer.exe
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v TaskbarAl /t REG_DWORD /d 0
start explorer.exe

@echo -%Green% Disable Remote Assistance: Created by: Shawn Brink on: August 27th 2018@echo -%Green% Tutorial: %Cyan% https://www.tenforums.com/tutorials/116749-enable-disable-remote-assistance-connections-windows.html %Reset%
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /f /v fAllowToGetHelp /t REG_DWORD /d 0
netsh advfirewall firewall set rule group="Remote Assistance" new enable=no

@echo -%Green% Change to Small memory dump: Memory dump file options for Windows: %Cyan% https://support.microsoft.com/en-us/topic/b863c80e-fb51-7bd5-c9b0-6116c3ca920f %Reset%
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "CrashDumpEnabled" /d "0x3"

@echo -%Green% Clear Taskbar Pinned Apps: Created by: Shawn Brink on: December 3rd 2014: Tutorial: %Cyan% https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html %Reset%
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned"
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
:: reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /F
move "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\*.*" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

@echo %Magenta% "Restore Windows Photo Viewer" Created by: Shawn Brink; Created on: August 8th 2015; Updated on: August 5th 2018 # Tutorial: %Cyan% https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html %Reset%
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

@echo %Magenta% Remove sounds - "Change to no sounds theme" %Reset%
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

@echo -%Green% Remove Xbox... %Reset%
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

@echo -%Green% Remove Maps... %Reset%
sc stop "MapsBroker"
sc config "MapsBroker" start=disabled
sc delete MapsBroker
sc stop lfsvc
sc delete lfsvc
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable

@echo %Magenta% Disables scheduled tasks that are considered unnecessary %Reset%
@echo -%Green% EDP Policy Manager - This task performs steps necessary to configure Windows Information Protection. %Reset%
schtasks /Change /TN "\Microsoft\Windows\AppID\EDP Policy Manager" /disable :: Inspects the AppID certificate cache for invalid or revoked certificates.
:: schtasks /Change /TN "\Microsoft\Windows\AppID\VerifiedPublisherCertStoreCheck" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\SmartScreenSpecific*" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\AitAgent*" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\Microsoft*" /disable
@echo -%Green% PcaPatchDbTask - Updates compatibility database %Reset%
schtasks /Change /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" /disable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
@echo -%Green% StartupAppTask - Scans startup entries and raises notification to the user if there are too many startup entries. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /disable
@echo -%Green% MareBackup - Gathers Win32 application data for App Backup scenario %Reset%
schtasks /Change /TN "\Microsoft\Windows\Application Experience\MareBackup" /disable
@echo -%Green% Cleans up each package's unused temporary files. %Reset%
rem schtasks /Change /TN "\Microsoft\Windows\ApplicationData\CleanupTemporaryState" /disable
@echo -%Green% Performs maintenance for the Data Sharing Service.
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /disable
@echo -%Green% This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /disable
:: ?schtasks /Change /TN "\Microsoft\Windows\BthSQM*" /disable
@echo -%Green% License Validation - Windows Store legacy license migration task %Reset%
schtasks /Change /TN "\Microsoft\Windows\Clip\License Validation" /disable
schtasks /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable
@echo -%Green% Consolidator - If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable
@echo -%Green% The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft. The information received is used to help improve the reliability, stability, and overall functionality of USB in Windows. If the user has not consented to participate in Windows CEIP, this task does not do anything. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable
?schtasks /Change /TN "\Microsoft\Windows\KernelCeipTask*" /disable
?schtasks /Change /TN "\Microsoft\Windows\Uploader*" /disable
@echo -%Green% Microsoft-Windows-DiskDiagnosticDataCollector - The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program. %Reset%
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
@echo -%Green% schtasks /Change /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" /disable
schtasks /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /disable
@echo -%Green% Property Definition Sync - Synchronizes the File Classification Infrastructure taxonomy on the computer with the resource property definitions stored in Active Directory Domain Services. %Reset%
schtasks /Change /TN "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync" /disable
:: TempSignedLicenseExchange - Exchanges temporary preinstalled licenses for Windows Store licenses. %Reset%
rem schtasks /Change /TN "\Microsoft\Windows\License Manager\TempSignedLicenseExchange" /disable
@echo -%Green% Location Notification %Reset%
schtasks /Change /TN "\Microsoft\Windows\Location\Notifications" /disable
schtasks /Change /TN "\Microsoft\Windows\Location\WindowsActionDialog" /disable
@echo -%Green% Measures a system's performance and capabilities %Reset%
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /disable
schtasks /Change /TN "\Microsoft\Windows\Management\Provisioning\Cellular" /disable
@echo -%Green% This task shows various Map related toasts %Reset%
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /disable
@echo -%Green% This task checks for updates to maps which you have downloaded for offline use. Disabling this task will prevent Windows from notifying you of updated maps. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable
:: Schedules a memory diagnostic in response to system events. %Reset%
:: System Sounds User Mode Agent
schtasks /Change /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" /disable
@echo -%Green% This task gathers information about the Trusted Platform Module (TPM), Secure Boot, and Measured Boot. %Reset%
schtasks /Change /TN "\Microsoft\Windows\PI\Sqm-Tasks" /disable
@echo -%Green% This task analyzes the system looking for conditions that may cause high energy use. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable
@echo -%Green% This service manages Apps that are pushed to the device from the Microsoft Store App running on other devices or the web. %Reset%
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration" /disable
@echo -%Green% Checks group policy for changes relevant to Remote Assistance %Reset%
schtasks /Change /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\BackgroundUploadTask" /disable
schtasks /Change /TN "\Microsoft\Windows\SettingSync\NetworkStateChangeTask" /disable
:: 
?schtasks /Change /TN "\Microsoft\Windows\BackupTask*" /disable
@echo -%Green% Initializes Family Safety monitoring and enforcement. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable
@echo -%Green% Synchronizes the latest settings with the Microsoft family features service. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefreshTask" /disable
@echo -%Green% Downloads a backup of your synced theme images %Reset%
schtasks /Change /TN "\Microsoft\Windows\Shell\ThemesSyncedImageDownload" /disable
schtasks /Change /TN "\Microsoft\Windows\Shell\UpdateUserPictureTask" /disable
@echo -%Green% Keeps the search index up to date %Reset%
schtasks /Change /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /disable
schtasks /Change /TN "\Microsoft\Windows\Speech\SpeechModelDownloadTask" /disable
@echo -%Green% Enable susbscription license acquisition %Reset%
schtasks /Change /TN "\Microsoft\Windows\Subscription\EnableLicenseAcquisition" /disable
@echo -%Green% Susbscription license acquisition %Reset%
schtasks /Change /TN "\Microsoft\Windows\Subscription\LicenseAcquisition" /disable
@echo -%Green% Windows Error Reporting task to process queued reports. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
@echo -%Green% Register this computer if the computer is already joined to an Active Directory domain. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Automatic-Device-Join" /disable
@echo -%Green% Sync device attributes to Azure Active Directory. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Device-Sync" /disable
@echo -%Green% Performs recovery check. %Reset%
schtasks /Change /TN "\Microsoft\Windows\Workplace Join\Recovery-Check" /disable
@echo -%Green% This task will automatically upload a roaming user profile's registry hive to its network location. %Reset%
schtasks /Change /TN "\Microsoft\Windows\User Profile Service\HiveUploadTask" /disable


@echo %Magenta% Removing Telemetry and other unnecessary services: %Reset%
@echo -%Green% Connected User Experience and Telemetry component, also known as the Universal Telemetry Client (UTC)... %Reset%
sc stop DiagTrack
sc delete DiagTrack
@echo -%Green% WAP Push Message Routing Service... Device Management Wireless Application Protocol (WAP) Push message Routing Service — This service is another service that helps to collect and send user data to Microsoft. %Reset%
sc stop dmwappushservice
sc delete dmwappushservice
@echo -%Green% Windows Error Reporting Service Description: Allows errors to be reported when programs stop working or responding ... %Reset%
sc stop WerSvc
sc delete WerSvc
@echo -%Green% Synchronize mail, contacts, calendar and various other user data... %Reset%
sc stop OneSyncSvc
@echo -%Green% Preventing Windows from re-enabling Telemetry services... %Reset%
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "Type" /t REG_DWORD /d 10
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "DelayedAutoStart" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "Type" /t REG_DWORD /d 20
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice" /f /v "ServiceSidType" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Services\dmwappushservice\Parameters" /f /v "ServiceDllUnloadOnStop" /t REG_DWORD /d 1

@echo %Magenta% System TuneUp %Reset%
@echo -%Green% Optimize prefetch parameters to improve Windows boot-up speed %Reset%
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d 2
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d 2
@echo -%Green% Reduce Application idlesness at closing to improve shutdown process %Reset%
reg delete "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout"
reg delete "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout"
reg add "HKCU\Control Panel\Desktop" /f /v "LowLevelHooksTimeout" /t REG_SZ /d "4000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000"
reg add "HKCU\Control Panel\Desktop" /f /v "HungAppTimeout" /t REG_SZ /d "3000"
reg add "HKCU\Control Panel\Desktop" /f /v "WaitToKillAppTimeout" /t REG_SZ /d "10000"
@echo -%Green% Enable optimization feature to improve Windows boot-up speed (HDD only) %Reset%
reg add "HKLM\Software\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "y"
@echo -%Green% System Stability %Reset%
@echo -%Green% Disable automatical reboot when system encounters blue screen %Reset%
reg add "HKLM\System\ControlSet001\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /f /v "AutoReboot" /t REG_DWORD /d 0
@echo -%Green% Disable registry modification from a remote computer %Reset%
reg add "HKLM\System\ControlSet001\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Control\SecurePipeServers\winreg" /f /v "remoteregaccess" /t REG_DWORD /d 1
@echo -%Green% Set Windows Explorer components to run in separate processes avoiding system conflicts %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "DesktopProcess" /t REG_DWORD /d 1
@echo -%Green% Close frozen processes to avoid system crashes %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "AutoEndTasks" /t REG_SZ /d "1"
@echo %Magenta% System Speedup %Reset%
@echo -%Green% Remove the word "shortcut" from the shortcut icons %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "link" /t REG_BINARY /d "00000000"
@echo -%Green% Optimize Windows Explorer so that it can automatically restart after an exception occurs to prevent the system from being unresponsive. %Reset%

@echo -%Green% Optimize the visual effect of the menu and list to improve the operating speed of the system. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ListviewAlphaSelect" /t REG_DWORD /d 0
@echo -%Green% Optimize refresh policy of Windows file list - DFS Share Refresh Issue -%Cyan% https://wiki.ledhed.net/index.php/DFS_Share_Refresh_Issue %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoSimpleNetIDList" /t REG_DWORD /d 1
@echo -%Green% Speed up display speed of Taskbar Window Previews. %Reset%
reg add "HKCU\Control Panel\Mouse" /f /v "MouseHoverTime" /t REG_SZ /d "100"
@echo -%Green% Speed up Aero Snap to make thumbnail display faster. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "ExtendedUIHoverTime" /t REG_DWORD /d "0"
@echo -%Green% Optimized response speed of system display. %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "MenuShowDelay" /t REG_SZ /d 0
@echo -%Green% Increase system icon cache and speed up desktop display. %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /f /v "Max Cached Icons" /t REG_SZ /d 4096
@echo -%Green% Boost the response speed of foreground programs. %Reset%
reg add "HKCU\Control Panel\Desktop" /f /v "ForegroundLockTimeout" /t REG_DWORD /d 0
@echo -%Green% Boost the display speed of Aero Peek. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "DesktopLivePreviewHoverTime" /t REG_DWORD /d 0
@echo -%Green% Disable memory pagination and reduce disk 1/0 to improve application performance. {Option may be ignored if physical memory is <1 GB) %Reset%
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "DisablePagingExecutive" /t REG_DWORD /d 1
@echo -%Green% Optimize processor performance for execution of applications, games, etc. {Ignore if server} %Reset%
reg add "HKLM\System\ControlSet001\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /f /v "Win32PrioritySeparation" /t REG_DWORD /d "38"
@echo -%Green% Close animation effect when maximizing or minimizing a window to speed up the window response. %Reset%
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v "MinAnimate" /t REG_SZ /d "0"
@echo -%Green% Optimize disk I/O while CPU is idle (HDD only) %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "1"
@echo -%Green% Disable the "Autoplay" feature on drives to avoid virus infection/propagation. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "NoDriveTypeAutoRun" /t REG_DWORD /d "221"
@echo -%Green% Optimize disk 1/0 subsystem to improve system performance. %Reset%
reg add "HKLM\System\ControlSet001\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /f /v "AutoChkTimeout" /t REG_DWORD /d 5
@echo -%Green% Optimize the file system to improve system performance. %Reset%
reg delete "HKLM\System\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg delete "HKLM\System\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate"
reg add "HKLM\System\ControlSet001\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
reg add "HKLM\System\CurrentControlSet\Control\FileSystem" /f /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 2147483649
@echo -%Green% Optimize front end components (dialog box, menus, etc.) appearance to improve system performance. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "TaskbarAnimations" /t REG_DWORD /d 0
@echo -%Green% Optimize memory default settings to improve system performance. %Reset%
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /f /v "IoPageLockLimit" /t REG_DWORD /d "134217728"
@echo -%Green% Disable the debugger to speed up error processing. %Reset%
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AeDebug" /f /v "Auto" /t REG_SZ /d 0
@echo -%Green% Disable screen error reporting to improve system performance. %Reset%
reg add "HKLM\Software\Microsoft\PCHealth\ErrorReporting" /f /v "ShowUI" /t REG_DWORD /d 0
reg add "HKLM\Software\Microsoft\PCHealth\ErrorReporting" /f /v "DoReport" /t REG_DWORD /d 0
@echo %Magenta% Network Speedup %Reset%
@echo -%Green% Optimize LAN connection. %Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "nonetcrawling" /t REG_DWORD /d 1
@echo -%Green% Optimize DNS and DNS parsing speed. %Reset%
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
@echo -%Green% Optimize Ethernet card performance. %Reset%
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "MaxConnectionsPerServer" /t REG_DWORD /d 0
@echo -%Green% Optimize network forward ability to improve network performance. %Reset%
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Tcp1323Opts" /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "SackOpts" /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "TcpMaxDupAcks" /t REG_DWORD /d "2"
@echo -%Green% Optimize network settings to improve communication performance. %Reset%
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\System\ControlSet001\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCollectionCount" /t REG_DWORD /d "32"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxThreads" /t REG_DWORD /d "30"
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /f /v "MaxCmds" /t REG_DWORD /d "30"
@echo -%Green% Optimize WINS name query time to improve data transfer speed. %Reset%
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "NameSrvQueryTimeout" /f /t REG_DWORD /d "3000"
@echo -%Green% Improve TCP/IP performance through automatic detection of "black holes" in routing at Path MTU Discovery technique. %Reset%
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /f /t REG_DWORD /d "1"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /f /t REG_DWORD /d "1"
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /f /v "0200" /t REG_BINARY /d "010000010000000000000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000ff"
@echo -%Green% Optimize TTL {Time To Live) settings to improve network performance. %Reset%
reg add "HKLM\System\ControlSet001\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /f /v "DefaultTTL" /t REG_DWORD /d "64"
reg add "HKLM\System\ControlSet001\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a00-9b1a-11d4-9123-0050047759bc}\6" /f /ve /t REG_BINARY /d "000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff"
@echo %Magenta% SSD optimize %Reset%
@echo -%Green% Disable drive defrag system on boot to extend lifespan of SSD. %Reset%
reg add "HKLM\Software\Microsoft\Dfrg\BootOptimizeFunction" /f /v "Enable" /t REG_SZ /d "n"
@echo -%Green% Disable auto defrag when idle to extend lifespan of SSD. %Reset%
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OptimalLayout" /f /v "EnableAutoLayout" /t REG_DWORD /d "0"
@echo -%Green% Disable prefetch parameters to extend lifespan of SSD. %Reset%
reg add "HKLM\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /f /v "EnablePrefetcher" /t REG_DWORD /d "0"
@echo -%Green% Enable TRIM function to improve working performance of SSD. %Reset%

@echo -%Green% Install HEVC Video Extensions %Reset%
winget install -e -i --id=9N4WGH0Z6VHQ --source=msstore
winget install -e -i --id=9NMZLZ57R3T7 --source=msstore

taskkill /f /im explorer.exe

IF EXIST WinClean.ps1 (powershell.exe -ExecutionPolicy Bypass -File ./WinClean.ps1 ) ELSE (msg "%username%" WinClean.ps1 not found! & echo WinClean.ps1 not found! )

@echo -%Green% Update all installed programs %Reset%
winget upgrade --all --silent --force --include-unknown

@echo -%Green% Delete all temporary files %Reset%
del /q /f /s %temp%\* && del /s /q c:\Windows\temp

@echo -%Green% Run Disk Cleanup - Runs Disk Cleanup on Drive C: and removes old Windows Updates. -%Cyan% https://ss64.com/nt/cleanmgr.html %Reset%
cleanmgr.exe /d C: /VERYLOWDISK /Autoclean
@echo COLOR TEST
color 00 & ping -n 1 127.0.0.1>nul & color 01 & ping -n 1 127.0.0.1>nul & color 02 & ping -n 1 127.0.0.1>nul & color 03 & ping -n 1 127.0.0.1>nul & color 04 & ping -n 1 127.0.0.1>nul & color 05 & ping -n 1 127.0.0.1>nul & color 06 & ping -n 1 127.0.0.1>nul & color 07 & ping -n 1 127.0.0.1>nul & color 09 & ping -n 1 127.0.0.1>nul & color 0A & ping -n 1 127.0.0.1>nul & color 0B & ping -n 1 127.0.0.1>nul & color 0C & ping -n 1 127.0.0.1>nul & color 0D & ping -n 1 127.0.0.1>nul & color 0E & ping -n 1 127.0.0.1>nul & color 0F & ping -n 1 127.0.0.1>nul & color 00 & ping -n 1 127.0.0.1>nul & color 10 & ping -n 1 127.0.0.1>nul & color 20 & ping -n 1 127.0.0.1>nul & color 30 & ping -n 1 127.0.0.1>nul & color 40 & ping -n 1 127.0.0.1>nul & color 50 & ping -n 1 127.0.0.1>nul & color 60 & ping -n 1 127.0.0.1>nul & color 70 & ping -n 1 127.0.0.1>nul & color 80 & ping -n 1 127.0.0.1>nul & color 90 & ping -n 1 127.0.0.1>nul & color A0 & ping -n 1 127.0.0.1>nul & color B0 & ping -n 1 127.0.0.1>nul & color C0 & ping -n 1 127.0.0.1>nul & color D0 & ping -n 1 127.0.0.1>nul & color E0 & ping -n 1 127.0.0.1>nul & color F0 & ping -n 1 127.0.0.1>nul & color 07

dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

@echo -%Green% Verify System Files %Reset%
sfc /scannow
@echo -%Green% PC will restart in 10 seconds unless you type: shutdown /a %Reset%
shutdown /r /t 10
:End