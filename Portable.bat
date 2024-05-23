:: Change location of user folders
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{56784854-C6CB-462B-8169-88E350ACB882}" /t REG_EXPAND_SZ /d "D:\Microsoft\Contacts"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "Desktop" /t REG_EXPAND_SZ /d "D:\Microsoft\Desktop"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}" /t REG_EXPAND_SZ /d "D:\Microsoft\Desktop"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "Personal" /t REG_EXPAND_SZ /d "D:\Microsoft\Documents"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" /t REG_EXPAND_SZ /d "D:\Microsoft\Documents"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_EXPAND_SZ /d "D:\Microsoft\Downloads"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" /t REG_EXPAND_SZ /d "D:\Microsoft\Downloads"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "Favorites" /t REG_EXPAND_SZ /d "D:\Microsoft\Favorites"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "Favorites" /t REG_EXPAND_SZ /d "D:\Microsoft\Favorites"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "My Music" /t REG_EXPAND_SZ /d "D:\Microsoft\Music"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{A0C69A99-21C8-4671-8703-7934162FCF1D}" /t REG_EXPAND_SZ /d "D:\Microsoft\Music"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "My Pictures" /t REG_EXPAND_SZ /d "D:\Microsoft\Pictures"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{0DDD015D-B06C-45D5-8C4C-F59713854639}" /t REG_EXPAND_SZ /d "D:\Microsoft\Pictures"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "My Video" /t REG_EXPAND_SZ /d "D:\Microsoft\Videos"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /f /v "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" /t REG_EXPAND_SZ /d "D:\Microsoft\Videos"

:: Move Personal Folders to Second Partition
if not exist "D:\Microsoft\Contacts" mkdir "D:\Microsoft\Contacts"
if not exist "D:\Microsoft\Desktop" mkdir "D:\Microsoft\Desktop"
if not exist "D:\Microsoft\Documents" mkdir "D:\Microsoft\Documents"
if not exist "D:\Microsoft\Downloads" mkdir "D:\Microsoft\Downloads"
if not exist "D:\Microsoft\Favorites" mkdir "D:\Microsoft\Favorites"
if not exist "D:\Microsoft\Music" mkdir "D:\Microsoft\Music"
if not exist "D:\Microsoft\Pictures" mkdir "D:\Microsoft\Pictures"
if not exist "D:\Microsoft\Videos" mkdir "D:\Microsoft\Videos"
move /y %USERPROFILE%\Contacts D:\Microsoft\Contacts
move /y %USERPROFILE%\Desktop D:\Microsoft\Desktop
move /y %USERPROFILE%\Documents D:\Microsoft\Documents
move /y %USERPROFILE%\Downloads D:\Microsoft\Downloads
move /y %USERPROFILE%\Favorites D:\Microsoft\Favorites
move /y %USERPROFILE%\Music D:\Microsoft\Music
move /y %USERPROFILE%\Pictures D:\Microsoft\Pictures
move /y %USERPROFILE%\Videos D:\Microsoft\Videos

:: Unzip PortableApps
tar -zxvf Microsoft.zip -C D:\Microsoft

:: Add StartMenu Links
tar -zxvf StartMenu.zip -C %appdata%

:: Fix permissions
icacls "D:\Microsoft" /setowner "Everyone" /T /C /Q
icacls "D:\Microsoft" /grant Everyone:(OI)(CI)F /T /C /Q

ftype 7-Zip.001="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.669="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.7z="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.a52="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.aif="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.aifc="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype anifile="D:\Microsoft\PortableApps\AniFXPortable\App\AniFX\AniFX.exe" "%1"
ftype 7-Zip.apfs="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.arj="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype aspfile="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype aspfile="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype VLC.asx="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.au="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.b4s="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.bz2="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.bzip2="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype aspfile="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype 7-Zip.cpio="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype CSSfile="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype curfile="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype 7-Zip.deb="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.dmg="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype docxfile="D:\Microsoft\PortableApps\LibreOfficePortable\LibreOfficeWriterPortable.exe" "%1"
ftype VLC.drc="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype "Microsoft Email Message" "D:\Microsoft\PortableApps\ThunderbirdPortable\App\Thunderbird64\thunderbird.exe" "%1"
ftype 7-Zip.esd="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.fat="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype giffile="D:\Microsoft\PortableApps\XnViewPortable\App\XnView\xnview.exe" "%1"
ftype VLC.gvi="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.gxf="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.gz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.gzip="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.hfs="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype htmlfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype htmlfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype icofile="D:\Microsoft\PortableApps\IcoFXPortable\App\IcoFX\IcoFX.exe" "%1"
ftype Windows.IsoFile="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype Windows.IsoFile="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.it="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype pjpegfile="D:\Microsoft\PortableApps\XnViewPortable\App\XnView\xnview.exe" "%1"
ftype jpegfile="D:\Microsoft\PortableApps\XnViewPortable\App\XnView\xnview.exe" "%1"
ftype jpegfile=%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1
ftype jpegfile=%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1
ftype 7-Zip.lha="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.lzh="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.lzma="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.m4p="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype mhtmlfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype mhtmlfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype VLC.mid="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.mp1="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.mpeg1="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.mpeg2="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.mpeg4="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.mpga="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.mtv="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype MSInfoFile="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype VLC.nsv="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.ntfs="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.nuv="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype odtfile="D:\Microsoft\PortableApps\LibreOfficePortable\LibreOfficeWriterPortable.exe" "%1"
ftype VLC.oma="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype pngfile=%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1
ftype VLC.qcp="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.rar="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.rmi="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.rpl="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.rpm="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.s3m="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.sdp="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.snd="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype svgfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype 7-Zip.swm="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.tar="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.taz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.tbz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.tbz2="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.tgz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.thp="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype TIFImage.Document=%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1
ftype TIFImage.Document=%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1
ftype 7-Zip.tpz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype txtfilelegacy="D:\Microsoft\PortableApps\Notepad++Portable\App\Notepad++\notepad++.exe" "%1"
ftype 7-Zip.txz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype Windows.VhdFile="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype Windows.VhdPmemFile="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype Windows.VhdFile="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.vlc="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.voc="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.vqf="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.vro="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.w64="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.wim="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.wvx="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.xar="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype VLC.xesc="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype xhtmlfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype xhtmlfile="D:\Microsoft\PortableApps\FirefoxPortable\App\Firefox64\firefox.exe" "%1"
ftype VLC.xm="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype VLC.xspf="D:\Microsoft\PortableApps\VLCPortable\App\vlc\vlc.exe" "%1"
ftype 7-Zip.xz="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype 7-Zip.z="D:\Microsoft\PortableApps\7-ZipPortable\App\7-Zip64\7zFM.exe" "%1"
ftype CompressedFolder="%SystemRoot%\Explorer.exe /idlist,%I,%L"

assoc .001=7-Zip.001
assoc .669=VLC.669
assoc .7z=7-Zip.7z
assoc .a52=VLC.a52
assoc .aif=VLC.aif
assoc .aifc=VLC.aifc
assoc .ani=anifile
assoc .apfs=7-Zip.apfs
assoc .arj=7-Zip.arj
assoc .asa=aspfile
assoc .asp=aspfile
assoc .asx=VLC.asx
assoc .au=VLC.au
assoc .b4s=VLC.b4s
assoc .bat=batfile
assoc .bmp=Paint.Picture
assoc .bz2=7-Zip.bz2
assoc .bzip2=7-Zip.bzip2
assoc .cab=CABFolder
assoc .cdx=aspfile
assoc .cpio=7-Zip.cpio
assoc .css=CSSfile
assoc .cur=curfile
assoc .deb=7-Zip.deb
assoc .dmg=7-Zip.dmg
assoc .docx=docxfile
assoc .drc=VLC.drc
assoc .drv=drvfile
assoc .eml=Microsoft Email Message
assoc .esd=7-Zip.esd
assoc .fat=7-Zip.fat
assoc .fon=fonfile
assoc .gif=giffile
assoc .gvi=VLC.gvi
assoc .gxf=VLC.gxf
assoc .gz=7-Zip.gz
assoc .gzip=7-Zip.gzip
assoc .hfs=7-Zip.hfs
assoc .hta=htafile
assoc .htm=htmlfile
assoc .html=htmlfile
assoc .ico=icofile
assoc .img=Windows.IsoFile
assoc .iso=Windows.IsoFile
assoc .it=VLC.it
assoc .jfif=pjpegfile
assoc .jpe=jpegfile
assoc .jpeg=jpegfile
assoc .jpg=jpegfile
assoc .js=JSFile
assoc .lha=7-Zip.lha
assoc .lzh=7-Zip.lzh
assoc .lzma=7-Zip.lzma
assoc .m4p=VLC.m4p
assoc .mht=mhtmlfile
assoc .mhtml=mhtmlfile
assoc .mid=VLC.mid
assoc .mp1=VLC.mp1
assoc .mpeg1=VLC.mpeg1
assoc .mpeg2=VLC.mpeg2
assoc .mpeg4=VLC.mpeg4
assoc .mpga=VLC.mpga
assoc .mtv=VLC.mtv
assoc .nfo=MSInfoFile
assoc .nsv=VLC.nsv
assoc .ntfs=7-Zip.ntfs
assoc .nuv=VLC.nuv
assoc .odt=odtfile
assoc .oma=VLC.oma
assoc .pif=piffile
assoc .pnf=pnffile
assoc .png=pngfile
assoc .qcp=VLC.qcp
assoc .rar=7-Zip.rar
assoc .rmi=VLC.rmi
assoc .rpl=VLC.rpl
assoc .rpm=7-Zip.rpm
assoc .rtf=rtffile
assoc .s3m=VLC.s3m
assoc .sdp=VLC.sdp
assoc .snd=VLC.snd
assoc .svg=svgfile
assoc .swm=7-Zip.swm
assoc .tar=7-Zip.tar
assoc .taz=7-Zip.taz
assoc .tbz=7-Zip.tbz
assoc .tbz2=7-Zip.tbz2
assoc .tgz=7-Zip.tgz
assoc .thp=VLC.thp
assoc .tif=TIFImage.Document
assoc .tiff=TIFImage.Document
assoc .tpz=7-Zip.tpz
assoc .txt=txtfilelegacy
assoc .txz=7-Zip.txz
assoc .vhd=Windows.VhdFile
assoc .vhdpmem=Windows.VhdPmemFile
assoc .vhdx=Windows.VhdFile
assoc .vlc=VLC.vlc
assoc .voc=VLC.voc
assoc .vqf=VLC.vqf
assoc .vro=VLC.vro
assoc .w64=VLC.w64
assoc .wim=7-Zip.wim
assoc .wvx=VLC.wvx
assoc .xar=7-Zip.xar
assoc .xesc=VLC.xesc
assoc .xht=xhtmlfile
assoc .xhtml=xhtmlfile
assoc .xm=VLC.xm
assoc .xsl=xslfile
assoc .xspf=VLC.xspf
assoc .xz=7-Zip.xz
assoc .z=7-Zip.z
assoc .zip=CompressedFolder
