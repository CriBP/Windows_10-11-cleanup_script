@echo off
:: Generate ANSI ESC characters for color codes
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set ESC=%%b
:: Setup Winclean environment:
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}"') do (set downloaddir=%%b)
md %downloaddir%\WinClean
cd %downloaddir%\WinClean
echo Download the files from https://github.com/CriBP/Windows_10-11-cleanup_script
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/raw/refs/heads/main/WinClean.bat' -OutFile %downloaddir%\WinClean\WinClean.bat"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/raw/refs/heads/main/Edge-uninstall.ps1' -OutFile %downloaddir%\WinClean\Edge-uninstall.ps1"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/raw/refs/heads/main/OneDrive-uninstall.ps1' -OutFile %downloaddir%\WinClean\OneDrive-uninstall.ps1"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/raw/refs/heads/main/Read_First.txt' -OutFile %downloaddir%\WinClean\Read_First.txt"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/raw/refs/heads/main/WinClean.ps1' -OutFile %downloaddir%\WinClean\WinClean.ps1"
powershell -c "Invoke-WebRequest -Uri 'https://github.com/CriBP/Windows_10-11-cleanup_script/raw/refs/heads/main/hosts' -OutFile %downloaddir%\WinClean\hosts"

net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights & powershell -Command "Start-Process '%downloaddir%\WinClean\winclean.bat' -Verb runAs" & exit /b 1) > %downloaddir%\WinClean\CleanUp.log
pause