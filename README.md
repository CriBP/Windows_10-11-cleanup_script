# Windows_10-11-cleanup_script
Clean-up ideas for a faster and lighter Windows OS

Cleaning up Windows 10 and 11 could be a long process with many detailed steps, we're trying to cover most of them automatically.
Please read entirely before proceding!

Because the script is deleting tracking services, some Antivirus software may block the process, if that is the case,
antivirus may be manualy stopped and restarted after the cleanup.

This is a long script and it can take (from my tests) anywhere between 2-20 minutes depending on the computer speed.

For our purpose here we need an Administrator Command Promt Window in which we'll run WinClean:
- unzip to your preffered location (Ex. Downloads)
- click on Widows Start Button and type cmd, from the right choose Run As Administrator and click Yes
- Type: cd %UserProfile%\Downloads\WinClean (if you used Downloads, otherwise type the address where you have unzipped the file)
- type winclean and press Enter

The scrips will run automatically removing most of the bloatware and leaving a clean and lightweight Operating System

Important Notes:
- computer needs to be signed in locally, not with a Microsoft Account, this script will disable Microsoft Syncronization,
    so a previous change to Local Account is necesary
- this script will disable the Gaming platform and all cloud Syncronization
- this script will remove a lot of background tasks and most of the Microsoft Store Apps
- the scripts are self explanatory, they have lines of description on every step
- to speed up user experience and reduce eye strain the background is removed, Color Scheme turned to Dark, and no sounds
- these scrips were made speciffically for Ekklesia PC's cleanup, but they can work on any Windows PC, and can be customized
- the "hosts" file contains a list of bad websites, known for moral or controversial issues, facebook included but enabled for people who really want it (you may remove # to block)! Loaded to the right place, it will provide a first-hand protection to any computer. It may be attacked by some Antivirus Software.
- While this is a big list of cleanup commands, it is not complete. Further cleaning is recommended by 
    using a few Portable Apps from https://portableapps.com/apps/utilities like:
    - Revo Uninstaller
    - Wise Disk Cleaner
    - Wise Registry Cleaner
    - PrivaZer
    - ccPortable

-"FileTypes" is just a collection of example files that helps with File Association
