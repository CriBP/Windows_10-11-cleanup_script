
	██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗
	██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝
	██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗
	██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║
	╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║
	╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝

		██████╗██╗     ███████╗ █████╗ ███╗   ██╗
		██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║
		██║     ██║     █████╗  ███████║██╔██╗ ██║
		██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║
		╚██████╗███████╗███████╗██║  ██║██║ ╚████║
		╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝

Cleaning up Windows 10 and 11 could be a long process with many detailed steps, we're trying to cover most of them automatically. If you prefer an interactive method, please check Chris Titus https://github.com/ChrisTitusTech/winutil and O&O ShutUp10++ https://www.oo-software.com/en/shutup10

Please read entirely before proceding!

Because the script is deleting tracking services, some Antivirus software may block the process, if that is the case, antivirus may be manualy stopped and restarted after the cleanup.

This is a long script and it can take (from my tests) anywhere between 10-30 minutes depending on the computer speed.

For our purpose here we need the five files saved in the same location and run WinClean.bat file that will elevate itself asking Administrator permission so it can run. The file "setup.bat" will download and run all the scripts. Here are the 5 files needed
- WinClean.bat - The main cleanup script - will call the other scripts automatically
- WinClean.ps1 - contains some extended Powershell scripts too big to be called inside a batch file
- OneDrive-uninstall.ps1 - dedicated Microsoft OneDrive uninstall script
- Edge-uninstall.ps1 - dedicated Microsoft Edge uninstall script
- the "hosts" file contains a list of bad websites, known for moral or controversial issues! Loaded to the right place, it will provide a first-hand protection to any computer. It may be attacked by some Antivirus Software.

The scrips will run automatically removing most of the bloatware and leaving a clean and lightweight Operating System

Setting up a a CLEAN COMPUTER:

1. First step is to obtain a clean copy of the operating system directly from source.
- Windows 10 - https://www.microsoft.com/en-us/software-download/windows10
- Windows 11 - https://www.microsoft.com/en-us/software-download/windows11
- Here we choose and create installation media, using a 8+ GB USB drive and we save on the usb the cleanup files mentioned above
2. Any new computer comes preloaded with bloatware, no matter where it was purchased, so first thing to do is to wipe clean the internal Drive, so we can start from scratch! (I will include details later)
3. With computer disconnected from internet, we start the installation from the created USB
4. Once installed, we copy the cleanup files in a dedicated location, for example Downloads and we run the WinClean.bat script
5. After restart we connect to the internet and Activate Windows then we can run the script again so it will be able to run the online commands as well

Important Notes:
- computer needs to be signed in locally, not with a Microsoft Account, this script will disable Microsoft Syncronization, so a previous change to Local Account is necesary
- this script will disable the Gaming platform and all cloud Syncronization
- this script will remove a lot of background tasks and most of the Microsoft Store Apps
- the scripts are self explanatory, they have lines of description on every step
- to speed up user experience and reduce eye strain the background is removed, Color Scheme turned to Dark, and no sounds
- the script starts with saving important PC information, it can work on any Windows PC, and it can be customized
- While this is a big list of cleanup commands, it is not complete. Further cleaning is recommended by using a few Portable Apps from https://portableapps.com/apps/utilities like:
 	- PrivaZer - https://portableapps.com/apps/utilities/privazer-portable
	- Revo Uninstaller - https://portableapps.com/apps/utilities/revo_uninstaller_portable
	- Wise Disk Cleaner - https://portableapps.com/apps/utilities/wise-disk-cleaner-portable
	- Wise Registry Cleaner - https://portableapps.com/apps/utilities/wise-registry-cleaner-portable
	- ccPortable - https://portableapps.com/apps/utilities/ccportable
	- O&O ShutUp10++ - https://www.oo-software.com/en/shutup10
	
-"FileTypes" is just a collection of example files that helps with File Association
