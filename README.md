# Windows_10-11-cleanup_script
Clean-up ideas for a faster and lighter Windows OS
                                                         
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

Cleaning up Windows 10 and 11 could be a long process with many detailed steps, we're trying to cover most of them automatically.
Please read entirely before proceding!

Because the script is deleting tracking services, some Antivirus software may block the process, if that is the case,
antivirus may be manualy stopped and restarted after the cleanup.

This is a long script and it can take (from my tests) anywhere between 10-30 minutes depending on the computer speed.

For our purpose here we need the five files saved in the same location and run WinClean.bat file that will elevate itself asking Administrator permission so it can run. Here are the 5 files needed
- WinClean.bat - The main cleanup script - will call the other scripts automatically
- WinClean.ps1 - contains some extended Powershell scripts too big to be called inside a batch file
- OneDrive-uninstall.ps1 - dedicated Microsoft OneDrive uninstall script
- Edge-uninstall.ps1 - dedicated Microsoft Edge uninstall script
- the "hosts" file contains a list of bad websites, known for moral or controversial issues, facebook included but enabled for people who 
really want it (you may remove # to block)! Loaded to the right place, it will provide a first-hand protection to any computer. It may be attacked by some Antivirus Software.

The scrips will run automatically removing most of the bloatware and leaving a clean and lightweight Operating System

Important Notes:
- computer needs to be signed in locally, not with a Microsoft Account, this script will disable Microsoft Syncronization, so a previous change to Local Account is necesary
- this script will disable the Gaming platform and all cloud Syncronization
- this script will remove a lot of background tasks and most of the Microsoft Store Apps
- the scripts are self explanatory, they have lines of description on every step
- to speed up user experience and reduce eye strain the background is removed, Color Scheme turned to Dark, and no sounds
- these scrips were made speciffically for Ekklesia PC's cleanup, but they can work on any Windows PC, and can be customized
- While this is a big list of cleanup commands, it is not complete. Further cleaning is recommended by using a few Portable Apps from https://portableapps.com/apps/utilities like:
 	- PrivaZer - https://portableapps.com/apps/utilities/privazer-portable
	- Revo Uninstaller - https://portableapps.com/apps/utilities/revo_uninstaller_portable
	- Wise Disk Cleaner - https://portableapps.com/apps/utilities/wise-disk-cleaner-portable
	- Wise Registry Cleaner - https://portableapps.com/apps/utilities/wise-registry-cleaner-portable
	- ccPortable - https://portableapps.com/apps/utilities/ccportable
	- O&O ShutUp10++ - https://www.oo-software.com/en/shutup10
-"FileTypes" is just a collection of example files that helps with File Association
