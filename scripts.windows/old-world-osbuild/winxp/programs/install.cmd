@echo off

:: process parameters
set ARGUMENTS=
for %%A in (%*) do (
	if "%%A"=="--pass-1" set PASS=1
	if "%%A"=="--pass-2" set PASS=2
	if "%%A"=="--pass-3" set PASS=3
	if "%%A"=="--pass-4" set PASS=4

	if "%%A"=="--virtual-machine" set IS_VIRTUAL_MACHINE=true
	if "%%A"=="--desktop-computer" set IS_DESKTOP_COMPUTER=true

	if "%%A"=="--minimum-installation" set MINIMUM_INSTALLATION=true
	if "%%A"=="--full-installation" set FULL_INSTALLATION=true
	if "%%A"=="--custom-installation" set CUSTOM_INSTALLATION=true

	if "%%A"=="--windows-installer" set INSTALL_WINDOWS_INSTALLER=true
	if "%%A"=="--windows-update-agent" set INSTALL_WINDOWS_UPDATE_AGENT=true
	if "%%A"=="--microsoft-vcpp-redistributable-package" set INSTALL_MICROSOFT_VCPP_REDISTRIBUTABLE_PACKAGE=true
	if "%%A"=="--microsoft-core-xml-services" set INSTALL_MICROSOFT_CORE_XML_SERVICES=true
	if "%%A"=="--dotnet-framework20" set INSTALL_DOTNET_FRAMEWORK20=true
	if "%%A"=="--dotnet-framework35" set INSTALL_DOTNET_FRAMEWORK35=true
	if "%%A"=="--windows-powershell" set INSTALL_WINDOWS_POWERSHELL=true
	if "%%A"=="--directx" set INSTALL_DIRECTX=true
	if "%%A"=="--java-jre" set INSTALL_JAVA_JRE=true
	if "%%A"=="--tooltipfixer" set INSTALL_TOOLTIPFIXER=true
	if "%%A"=="--unlocker" set INSTALL_UNLOCKER=true
	if "%%A"=="--scsi-pass-through-direct" set INSTALL_SCSI_PASS_THROUGH_DIRECT=true
	if "%%A"=="--partition-wizard" set INSTALL_PARTITION_WIZARD=true
	if "%%A"=="--total-commander" set INSTALL_TOTAL_COMMANDER=true
	if "%%A"=="--notepadpp" set INSTALL_NOTEPADPP=true
	if "%%A"=="--cdburnerxp" set INSTALL_CDBURNERXP=true
	if "%%A"=="--imgburn" set INSTALL_IMGBURN=true
	if "%%A"=="--nlite" set INSTALL_NLITE=true
	if "%%A"=="--hashtab" set INSTALL_HASHTAB=true
	if "%%A"=="--adobe-reader" set INSTALL_ADOBE_READER=true
	if "%%A"=="--openoffice" set INSTALL_OPENOFFICE=true
	if "%%A"=="--irfanview" set INSTALL_IRFANVIEW=true
	if "%%A"=="--google-picasa" set INSTALL_GOOGLE_PICASA=true
	if "%%A"=="--videolan-player" set INSTALL_VIDEOLAN_PLAYER=true
	if "%%A"=="--codecs" set INSTALL_CODECS=true
	if "%%A"=="--aimp2" set INSTALL_AIMP2=true
	if "%%A"=="--graphcalc" set INSTALL_GRAPHCALC=true
	if "%%A"=="--keepass" set INSTALL_KEEPASS=true
	if "%%A"=="--truecrypt" set INSTALL_TRUECRYPT=true
	if "%%A"=="--dropbox" set INSTALL_DROPBOX=true
	if "%%A"=="--perl" set INSTALL_PERL=true
	if "%%A"=="--python" set INSTALL_PYTHON=true
	if "%%A"=="--putty" set INSTALL_PUTTY=true
	if "%%A"=="--winscp" set INSTALL_WINSCP=true
	if "%%A"=="--collabnet-subversion-client" set INSTALL_COLLABNET_SUBVERSION_CLIENT=true
	if "%%A"=="--tortoisesvn" set INSTALL_TORTOISESVN=true
	if "%%A"=="--visualsvn" set INSTALL_VISUALSVN=true
	if "%%A"=="--git" set INSTALL_GIT=true
	if "%%A"=="--gimp" set INSTALL_GIMP=true
	if "%%A"=="--blender" set INSTALL_BLENDER=true
	if "%%A"=="--java-jdk" set INSTALL_JAVA_JDK=true
	if "%%A"=="--eclipse" set INSTALL_ECLIPSE=true
	if "%%A"=="--junit" set INSTALL_JUNIT=true
	if "%%A"=="--ant" set INSTALL_ANT=true
	if "%%A"=="--maven" set INSTALL_MAVEN=true
	if "%%A"=="--java-libraries" set INSTALL_JAVA_LIBRARIES=true
	if "%%A"=="--apache-tomcat" set INSTALL_APACHE_TOMCAT=true
	if "%%A"=="--apache-http-server" set INSTALL_APACHE_HTTP_SERVER=true
	if "%%A"=="--netbeans" set INSTALL_NETBEANS=true
	if "%%A"=="--php" set INSTALL_PHP=true
	if "%%A"=="--phing" set INSTALL_PHING=true
	if "%%A"=="--zend-framework" set INSTALL_ZEND_FRAMEWORK=true
	if "%%A"=="--dojo-toolkit" set INSTALL_DOJO_TOOLKIT=true
	if "%%A"=="--jquery" set INSTALL_JQUERY=true
	if "%%A"=="--web-debbuging-tools" set INSTALL_WEB_DEBBUGING_TOOLS=true
	if "%%A"=="--oxygen-xml-editor" set INSTALL_OXYGEN_XML_EDITOR=true
	if "%%A"=="--wireshark" set INSTALL_WIRESHARK=true
	if "%%A"=="--mysql-workbench" set INSTALL_MYSQL_WORKBENCH=true
	if "%%A"=="--microsoft-sql-server-management-studio" set INSTALL_MICROSOFT_SQL_SERVER_MANAGEMENT_STUDIO=true
	if "%%A"=="--oracle-sql-developer" set INSTALL_ORACLE_SQL_DEVELOPER=true
	if "%%A"=="--internet-explorer" set INSTALL_INTERNET_EXPLORER=true
	if "%%A"=="--opera" set INSTALL_OPERA=true
	if "%%A"=="--safari" set INSTALL_SAFARI=true
	if "%%A"=="--chrome" set INSTALL_CHROME=true
	if "%%A"=="--firefox" set INSTALL_FIREFOX=true
	if "%%A"=="--firefox-plugins" set INSTALL_FIREFOX_PLUGINS=true
	if "%%A"=="--thunderbird" set INSTALL_THUNDERBIRD=true
	if "%%A"=="--flash-player" set INSTALL_FLASH_PLAYER=true
	if "%%A"=="--shockwave" set INSTALL_SHOCKWAVE=true
	if "%%A"=="--silverlight" set INSTALL_SILVERLIGHT=true
	if "%%A"=="--free-download-manager" set INSTALL_FREE_DOWNLOAD_MANAGER=true
	if "%%A"=="--emule" set INSTALL_EMULE=true
	if "%%A"=="--utorrent" set INSTALL_UTORRENT=true
	if "%%A"=="--skype" set INSTALL_SKYPE=true
	if "%%A"=="--osbuild" set INSTALL_OSBUILD=true
	if "%%A"=="--daemon-tools-lite" set INSTALL_DAEMON_TOOLS_LITE=true
	if "%%A"=="--visual-studio" set INSTALL_VISUAL_STUDIO=true
	if "%%A"=="--kernel-mode-tools" set INSTALL_KERNEL_MODE_TOOLS=true
	if "%%A"=="--vmware-server" set INSTALL_VMWARE_SERVER=true
	if "%%A"=="--mysql" set INSTALL_MYSQL=true
	if "%%A"=="--mssql" set INSTALL_MSSQL=true
	if "%%A"=="--oracle" set INSTALL_ORACLE=true
	if "%%A"=="--cpu-z" set INSTALL_CPU_Z=true
	if "%%A"=="--gpu-z" set INSTALL_GPU_Z=true
	if "%%A"=="--eset-smart-security" set INSTALL_ESET_SMART_SECURITY=true

	if "%%A"=="--os-install" set OS_INSTALL=true

	if "%%A"=="--predefined-web-dev" set MACHINE_NAME_SUFFIX=-web-dev
	if "%%A"=="--predefined-win-dev" set MACHINE_NAME_SUFFIX=-win-dev
	if "%%A"=="--predefined-databases" set MACHINE_NAME_SUFFIX=-databases
	if "%%A"=="--predefined-networking" set MACHINE_NAME_SUFFIX=-networking

	call :setOption %%A
)

if "%ARGUMENTS%"=="" goto:eof

:: ===========================================================================================================================================================================================

echo *** Step %PASS% started at %TIME%, invoked command "%~f0 %*"

set NLM=^


set NL=^^^%NLM%%NLM%^%NLM%%NLM%
if "%IS_VIRTUAL_MACHINE%"=="true" (
	set DESTINATION_DRIVE=c
) else (
	set DESTINATION_DRIVE=d
)
set DOWNLOADS_DIR=%DESTINATION_DRIVE%:\download
set LIBRARIES_DIR=%DESTINATION_DRIVE%:\libraries
set PROJECTS_DIR=%DESTINATION_DRIVE%:\projects
set PUBLIC_DIR=%DESTINATION_DRIVE%:\public
set REPOSITORIES_DIR=%DESTINATION_DRIVE%:\repositories
set TEMP_DIR=%DESTINATION_DRIVE%:\temp
set TOOLS_DIR=%DESTINATION_DRIVE%:\tools
set VIRTUAL_MACHINES_DIR=%DESTINATION_DRIVE%:\virtual machines
set WINTOOLS_DIR=c:\Program Files\wintools
set LIMITED_USER=danstefan

:: change directory to script's directory
%~d0
cd %~dp0

echo on
@if "%PASS%"=="1" goto PASS1
@if "%PASS%"=="2" goto PASS2
@if "%PASS%"=="3" goto PASS3
@if "%PASS%"=="4" goto PASS4

:: ===========================================================================================================================================================================================

:PASS1

if not "%OS_INSTALL%"=="true" goto DO_NOT_REMOVE_DIRECTORIES
if exist "%LIBRARIES_DIR%" rmdir "%LIBRARIES_DIR%" /s /q
if exist "%TEMP_DIR%" rmdir "%TEMP_DIR%" /s /q
if exist "%TOOLS_DIR%" rmdir "%TOOLS_DIR%" /s /q
:DO_NOT_REMOVE_DIRECTORIES

if not exist "%DOWNLOADS_DIR%" mkdir "%DOWNLOADS_DIR%"
if not exist "%LIBRARIES_DIR%" mkdir "%LIBRARIES_DIR%"
if not exist "%PROJECTS_DIR%" mkdir "%PROJECTS_DIR%"
if not exist "%PUBLIC_DIR%" mkdir "%PUBLIC_DIR%"
if not exist "%REPOSITORIES_DIR%" mkdir "%REPOSITORIES_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"

if not "%OS_INSTALL%"=="true" goto IT_IS_NOT_OS_INSTALL_1

:: System Customization
echo Customizing System > con

:: pagefile
if "%IS_VIRTUAL_MACHINE%"=="true" (
	cscript //nologo %~d0\Utils\hostname.vbs vm%MACHINE_NAME_SUFFIX%
	wmic pagefileset set Name='c:\pagefile.sys',InitialSize=2048,MaximumSize=2048 > nul
) else (
	cscript //nologo %~d0\Utils\hostname.vbs desktop
	wmic pagefileset delete > nul
)

:: 7-Zip
echo Installing 7-Zip > con
msiexec /i 7z913-x64.msi /passive /norestart

:: Process Explorer
echo Installing Process Explorer > con
"c:\Program Files\7-Zip\7z" x ProcessExplorer.zip procexp.exe -o"%WINTOOLS_DIR%" > nul
call :processExplorer

:: SubInACL
echo Installing SubInACL > con
msiexec /i subinacl.msi /q
copy "c:\Program Files (x86)\Windows Resource Kits\Tools\subinacl.*" "%WINTOOLS_DIR%" > nul
msiexec /x subinacl.msi /q
copy %~d0\Utils\chown*.cmd "%WINTOOLS_DIR%" > nul

:: AutoIt
echo Installing AutoIt > con
"c:\Program Files\7-Zip\7z" x -sfx autoit-v3-sfx.exe -o%TEMP%\AutoIt > nul
rename %TEMP%\AutoIt\install AutoIt
xcopy %TEMP%\AutoIt\AutoIt "c:\Program Files\AutoIt\" /e > nul
rmdir %TEMP%\AutoIt /s /q

:: drivers
echo Installing Drivers > con
if "%IS_VIRTUAL_MACHINE%"=="true" (
	"c:\Program Files\7-Zip\7z" x VMwareTools.zip -o%TEMP%\VMwareTools > nul
	start /wait msiexec /i "%TEMP%\VMwareTools\VMware Tools64.msi" /qn /norestart
	rmdir %TEMP%\VMwareTools /s /q
) else (
	start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\chipset.au3 %~d0 > nul
	start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\lan.au3 %~d0 > nul
	start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\audio.au3 %~d0 > nul
	start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\video.au3 %~d0 > nul
	timeout /t 5 > nul
	rmdir c:\Intel /s /q
	rmdir c:\NVIDIA /s /q
)

start %1 --run-once "%1 --pass-2 %ARGUMENTS%"

@echo off
echo.
goto:eof

:: ===========================================================================================================================================================================================

:PASS2

call :processExplorer

:: Defraggler
echo Installing Defraggler > con
dfsetup119.exe /S
copy %~d0\Config\Defraggler.ini "c:\Program Files\Defraggler\" > nul

:: CCleaner
echo Installing CCleaner > con
ccsetup232.exe /S
"c:\Program Files (x86)\Yahoo!\Common\unyt.exe" /S
timeout /t 5 > nul
rmdir "%USERPROFILE%\Application Data\Yahoo!" /s /q
rmdir "c:\Program Files (x86)\Yahoo!" /s /q
copy %~d0\Config\ccleaner.ini "c:\Program Files (x86)\CCleaner\" > nul

:: CoreUtils
echo Installing CoreUtils > con
coreutils-5.3.0.exe /dir="%WINTOOLS_DIR%\gnu" /verysilent /norestart

:: Sed
echo Installing Sed > con
sed-4.2-1-setup.exe /dir="%WINTOOLS_DIR%\gnu" /verysilent /norestart

:: Gawk
echo Installing Gawk > con
gawk-3.1.6-1-setup.exe /dir="%WINTOOLS_DIR%\gnu" /verysilent /norestart

:: Wget
echo Installing Wget > con
wget-1.11.4-1-setup.exe /dir="%WINTOOLS_DIR%\gnu" /verysilent /norestart

:: Junction
echo Installing Junction > con
"c:\Program Files\7-Zip\7z" x Junction.zip junction.exe -o"%WINTOOLS_DIR%" > nul
"%WINTOOLS_DIR%\junction.exe" /accepteula > nul

:: Autorun
echo Installing Autorun > con
"c:\Program Files\7-Zip\7z" x Autoruns.zip autoruns.exe -o"%WINTOOLS_DIR%" > nul
start "" "%WINTOOLS_DIR%\autoruns.exe" /accepteula && timeout /t 2 > nul
taskkill /IM autoruns.exe /T /F > nul

:: RegShot
echo Installing RegShot > con
"c:\Program Files\7-Zip\7z" x regshot_1.8.2_src_bin.zip regshot.exe -o"%WINTOOLS_DIR%" > nul

:: TweakUI
echo Installing TweakUI > con
"c:\Program Files\7-Zip\7z" x TweakUIPowertoySetup_amd64.exe -o%TEMP%\TweakUI > nul
copy %TEMP%\TweakUI\TweakUI.exe "%WINTOOLS_DIR%" > nul
rmdir %TEMP%\TweakUI /s /q

:: UltraMon
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_INSTALL_ULTRAMON
echo Installing UltraMon > con
msiexec.exe /i UltraMon_3.0.10_en_x64.msi /qb!
:DO_NOT_INSTALL_ULTRAMON

:: Windows XP Activation Hack
echo Installing Windows XP Activation Hack > con
"c:\Program Files\7-Zip\7z" x %~d0\Utils\windows_xp_activation_hack.zip -o"%WINTOOLS_DIR%\windows_xp_activation_hack" > nul

:IT_IS_NOT_OS_INSTALL_1

@if "%MINIMUM_INSTALLATION%"=="true" goto END_OF_INSTALLATION

:: ===========================================================================================================================================================================================

:: Windows Installer
if not "%INSTALL_WINDOWS_INSTALLER%"=="true" goto DO_NOT_INSTALL_WINDOWS_INSTALLER
echo Installing Windows Installer > con
WindowsServer2003-KB942288-v4-x64.exe /Passive /NoRestart
:DO_NOT_INSTALL_WINDOWS_INSTALLER

:: Windows Update Agent
if not "%INSTALL_WINDOWS_UPDATE_AGENT%"=="true" goto DO_NOT_INSTALL_WINDOWS_UPDATE_AGENT
echo Installing Windows Update Agent > con
windowsupdateagent30-x64.exe/Q /WUforce /NoRestart
:DO_NOT_INSTALL_WINDOWS_UPDATE_AGENT

:: Microsoft Visual C++ Redistributable Package
if not "%INSTALL_MICROSOFT_VCPP_REDISTRIBUTABLE_PACKAGE%"=="true" goto DO_NOT_INSTALL_MICROSOFT_VCPP_REDISTRIBUTABLE_PACKAGE
echo Installing Microsoft Visual C++ Redistributable Package > con
vcredist_x86.exe /Q
vcredist_x64.exe /Q
:DO_NOT_INSTALL_MICROSOFT_VCPP_REDISTRIBUTABLE_PACKAGE

:: Microsoft Core XML Services
if not "%INSTALL_MICROSOFT_CORE_XML_SERVICES%"=="true" goto DO_NOT_INSTALL_MICROSOFT_CORE_XML_SERVICES
echo Installing Microsoft Core XML Services > con
msiexec /i msxml6_x64.msi /Passive /NoRestart
:DO_NOT_INSTALL_MICROSOFT_CORE_XML_SERVICES

:: .NET Framework 2.0
if not "%INSTALL_DOTNET_FRAMEWORK20%"=="true" goto DO_NOT_INSTALL_DOTNET_FRAMEWORK20
echo Installing .NET Framework 2.0 > con
NetFx20SP2_x64.exe /Passive /NoRestart
:DO_NOT_INSTALL_DOTNET_FRAMEWORK20

:: .NET Framework 3.5
if not "%INSTALL_DOTNET_FRAMEWORK35%"=="true" goto DO_NOT_INSTALL_DOTNET_FRAMEWORK35
echo Installing .NET Framework 3.5 > con
dotnetfx35.exe /Passive /NoRestart
timeout /t 5 > nul
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\Windows XP Version 2003\SP3\KB954550-v7\Filelist\1" %TEMP%\dotNet35folder.reg > nul
type %TEMP%\dotNet35folder.reg | find "Location" > %TEMP%\dotNet35folder.txt
for /F %%N in (%TEMP%\dotNet35folder.txt) do set STR_DOT_NET_TEMP_LOCATION=%%N
set STR_DOT_NET_TEMP_LOCATION=%STR_DOT_NET_TEMP_LOCATION:~0,-19%
set STR_DOT_NET_DRIVE=%STR_DOT_NET_TEMP_LOCATION:~12,2%
set STR_DOT_NET_DIR=%STR_DOT_NET_TEMP_LOCATION:~16%
rmdir /S /Q %STR_DOT_NET_DRIVE%\%STR_DOT_NET_DIR%
del %TEMP%\dotNet35folder.*
:DO_NOT_INSTALL_DOTNET_FRAMEWORK35

:: Windows PowerShell
if not "%INSTALL_WINDOWS_POWERSHELL%"=="true" goto DO_NOT_INSTALL_WINDOWS_POWERSHELL
echo Installing Windows PowerShell > con
start /wait WindowsServer2003.WindowsXP-KB926139-v2-x64-ENU.exe /Passive /NoRestart
:DO_NOT_INSTALL_WINDOWS_POWERSHELL

:: DirectX
if not "%INSTALL_DIRECTX%"=="true" goto DO_NOT_INSTALL_DIRECTX
echo Installing DirectX > con
directx_feb2010_redist.exe /Q /T:%TEMP%\DirectX
%TEMP%\DirectX\DXSETUP.exe /Silent
rmdir %TEMP%\DirectX /s /q
:DO_NOT_INSTALL_DIRECTX

:: Java JRE
if not "%INSTALL_JAVA_JRE%"=="true" goto DO_NOT_INSTALL_JAVA_JRE
echo Installing Java JRE > con
jre-6u20-windows-i586-s.exe ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 /Passive /NoRestart
jre-6u20-windows-x64.exe ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 /Passive /NoRestart
:DO_NOT_INSTALL_JAVA_JRE

:: ToolTipFixer
if not "%INSTALL_TOOLTIPFIXER%"=="true" goto DO_NOT_INSTALL_TOOLTIPFIXER
echo Installing ToolTipFixer > con
"ToolTipFixer 2.0.0.exe" /S
:DO_NOT_INSTALL_TOOLTIPFIXER

:: Unlocker
if not "%INSTALL_UNLOCKER%"=="true" goto DO_NOT_INSTALL_UNLOCKER
echo Installing Unlocker > con
unlocker.exe /S
:DO_NOT_INSTALL_UNLOCKER

:: SCSI Pass Through Direct
if not "%INSTALL_SCSI_PASS_THROUGH_DIRECT%"=="true" goto DO_NOT_INSTALL_SCSI_PASS_THROUGH_DIRECT
echo Installing SCSI Pass Through Direct > con
SPTDinst-v162-x64.exe add /q
:DO_NOT_INSTALL_SCSI_PASS_THROUGH_DIRECT

:: Partition Wizard
if not "%INSTALL_PARTITION_WIZARD%"=="true" goto DO_NOT_INSTALL_PARTITION_WIZARD
echo Installing Partition Wizard > con
pwhe5.exe /silent
:DO_NOT_INSTALL_PARTITION_WIZARD

:: Total Commander
if not "%INSTALL_TOTAL_COMMANDER%"=="true" goto DO_NOT_INSTALL_TOTAL_COMMANDER
echo Installing Total Commander > con
"c:\Program Files\7-Zip\7z" x -tzip tcm755r2.exe -o%TEMP%\tc > nul
"%WINTOOLS_DIR%\gnu\bin\sed" -e "s/auto=0/auto=1/g" -e "s/alllang=1/alllang=0/g" -e "s/Dir=c:\\totalcmd/Dir=c:\\Program Files (x86)\\totalcmd/g" %TEMP%\tc\INSTALL.INF > %TEMP%\tc\INSTALL.INF.tmp
del %TEMP%\tc\INSTALL.INF
rename %TEMP%\tc\INSTALL.INF.tmp INSTALL.INF
%TEMP%\tc\INSTALL.EXE
rmdir %TEMP%\tc /s /q
copy %~d0\Config\TotalCommander.ini "%USERPROFILE%\Application Data\GHISLER\" > nul
del "%USERPROFILE%\Application Data\GHISLER\wincmd.ini"
rename "%USERPROFILE%\Application Data\GHISLER\TotalCommander.ini" wincmd.ini
:DO_NOT_INSTALL_TOTAL_COMMANDER

:: Notepad++
if not "%INSTALL_NOTEPADPP%"=="true" goto DO_NOT_INSTALL_NOTEPADPP
echo Installing Notepad++ > con
npp.5.6.8.Installer.exe /S
copy "%~d0\Config\Notepad++.xml" "%USERPROFILE%\Application Data\Notepad++\" > nul
rename "%USERPROFILE%\Application Data\Notepad++\Notepad++.xml" config.xml
:DO_NOT_INSTALL_NOTEPADPP

:: CDBurnerXP
if not "%INSTALL_CDBURNERXP%"=="true" goto DO_NOT_INSTALL_CDBURNERXP
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_INSTALL_CDBURNERXP
echo Installing CDBurnerXP > con
cdbxp_setup_4.3.2.2140.exe /Silent /NoRestart
:DO_NOT_INSTALL_CDBURNERXP

:: ImgBurn
if not "%INSTALL_IMGBURN%"=="true" goto DO_NOT_INSTALL_IMGBURN
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_INSTALL_IMGBURN
echo Installing ImgBurn > con
SetupImgBurn_2.5.1.0.exe /S
:DO_NOT_INSTALL_IMGBURN

:: nLite
if not "%INSTALL_NLITE%"=="true" goto DO_NOT_INSTALL_NLITE
echo Installing nLite > con
nLite-1.4.9.1.installer.exe /Silent /NoRestart
:DO_NOT_INSTALL_NLITE

:: HashTab
if not "%INSTALL_HASHTAB%"=="true" goto DO_NOT_INSTALL_HASHTAB
echo Installing HashTab > con
"HashTab Setup.exe" /S
:DO_NOT_INSTALL_HASHTAB

:: Adobe Reader
if not "%INSTALL_ADOBE_READER%"=="true" goto DO_NOT_INSTALL_ADOBE_READER
echo Installing Adobe Reader > con
AdbeRdr930_en_US.exe /sPB /rs /msiEULA_ACCEPT=YES
:DO_NOT_INSTALL_ADOBE_READER

:: OpenOffice
if not "%INSTALL_OPENOFFICE%"=="true" goto DO_NOT_INSTALL_OPENOFFICE
echo Installing OpenOffice > con
"c:\Program Files\7-Zip\7z" x OOo_3.2.0_Win32Intel_install_en-GB.exe -o%TEMP%\OpenOffice > nul
"c:\Program Files\7-Zip\7z" x %TEMP%\OpenOffice\[0] -o%TEMP%\OpenOffice > nul
msiexec /i %TEMP%\OpenOffice\openofficeorg32.msi ALLUSERS=0 ADDLOCAL=ALL SELECT_WORD=1 SELECT_EXCEL=1 SELECT_POWERPOINT=1 /Qr /NoRestart
rmdir %TEMP%\OpenOffice /s /q
del "c:\Program Files (x86)\OpenOffice.org 3\program\gdiplus.dll"
:DO_NOT_INSTALL_OPENOFFICE

:: IrfanView
if not "%INSTALL_IRFANVIEW%"=="true" goto DO_NOT_INSTALL_IRFANVIEW
echo Installing IrfanView > con
iview427_setup.exe /silent /group=1 /allusers=1
:DO_NOT_INSTALL_IRFANVIEW

:: Google Picasa
if not "%INSTALL_GOOGLE_PICASA%"=="true" goto DO_NOT_INSTALL_GOOGLE_PICASA
echo Installing Google Picasa > con
picasa36-setup.exe /S && timeout /t 5 > nul
taskkill /IM Picasa3.exe /T /F > nul
:DO_NOT_INSTALL_GOOGLE_PICASA

:: VideoLAN Player
if not "%INSTALL_VIDEOLAN_PLAYER%"=="true" goto DO_NOT_INSTALL_VIDEOLAN_PLAYER
echo Installing VideoLAN Player > con
vlc-1.0.5-win32.exe /S
:DO_NOT_INSTALL_VIDEOLAN_PLAYER

:: Codecs
if not "%INSTALL_CODECS%"=="true" goto DO_NOT_INSTALL_CODECS
echo Installing Codecs > con
K-Lite_Codec_Pack_600_Full.exe /Silent /NoRestart /LoadInf="%~d0\Config\klcp.ini"
QT_Lite_322.exe /Silent /NoRestart
K-Lite_Codec_Pack_64bit_350.exe /Silent /NoRestart
:DO_NOT_INSTALL_CODECS

:: AIMP2
if not "%INSTALL_AIMP2%"=="true" goto DO_NOT_INSTALL_AIMP2
echo Installing AIMP2 > con
"c:\Program Files\7-Zip\7z" x aimp_2.51.330.zip -o%TEMP%\AIMP2 > nul
%TEMP%\AIMP2\aimp_2.51.330.exe /S /SKIN=WMP11.acs2 /ICONS=XP.dll /shortcut=101
rmdir %TEMP%\AIMP2 /s /q
:DO_NOT_INSTALL_AIMP2

:: GraphCalc
if not "%INSTALL_GRAPHCALC%"=="true" goto DO_NOT_INSTALL_GRAPHCALC
echo Installing GraphCalc > con
"c:\Program Files\7-Zip\7z" x GraphCalc4.0.1.zip -o"c:\Program Files (x86)" > nul
:DO_NOT_INSTALL_GRAPHCALC

:: KeePass Password Safe
if not "%INSTALL_KEEPASS%"=="true" goto DO_NOT_INSTALL_KEEPASS
echo Installing KeePass Password Safe > con
KeePass-2.10-Setup.exe /Silent /NoRestart
"%WINTOOLS_DIR%\gnu\bin\wget" --directory-prefix=%TEMP% http://keepass.info/extensions/v2/kpentrytemplates/KPEntryTemplates-2.10.zip
"c:\Program Files\7-Zip\7z" x %TEMP%\KPEntryTemplates-2.10.zip -o"c:\Program Files (x86)\KeePass Password Safe 2" > nul
:DO_NOT_INSTALL_KEEPASS

:: TrueCrypt
if not "%INSTALL_TRUECRYPT%"=="true" goto DO_NOT_INSTALL_TRUECRYPT
echo Installing TrueCrypt > con
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\TrueCrypt.au3 > nul
:DO_NOT_INSTALL_TRUECRYPT

:: Dropbox
if not "%INSTALL_DROPBOX%"=="true" goto DO_NOT_INSTALL_DROPBOX
echo Installing Dropbox > con
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\Dropbox.au3 > nul
:DO_NOT_INSTALL_DROPBOX

:: Perl
if not "%INSTALL_PERL%"=="true" goto DO_NOT_INSTALL_PERL
echo Installing Perl > con
start /wait msiexec /i ActivePerl-5.12.1.1201-MSWin32-x64-292674.msi /q TARGETDIR="c:\Program Files" PERL_PATH="No" PERL_EXT="Yes"
mkdir "%TOOLS_DIR%\perl"
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\perl" "c:\Program Files\Perl64" > nul
:DO_NOT_INSTALL_PERL

:: Python
if not "%INSTALL_PYTHON%"=="true" goto DO_NOT_INSTALL_PYTHON
echo Installing Python > con
start /wait msiexec /i python-3.1.2.amd64.msi /qn TARGETDIR="c:\Program Files\Python" ALLUSERS=1
mkdir "%TOOLS_DIR%\python"
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\python" "c:\Program Files\Python" > nul
:DO_NOT_INSTALL_PYTHON

:: PuTTY
if not "%INSTALL_PUTTY%"=="true" goto DO_NOT_INSTALL_PUTTY
echo Installing PuTTY > con
putty-0.60-installer.exe /sp- /silent
:DO_NOT_INSTALL_PUTTY

:: WinSCP
if not "%INSTALL_WINSCP%"=="true" goto DO_NOT_INSTALL_WINSCP
echo Installing WinSCP > con
winscp427setup.exe /verysilent /norestart /nocandy
:DO_NOT_INSTALL_WINSCP

:: Collabnet Subversion Client
if not "%INSTALL_COLLABNET_SUBVERSION_CLIENT%"=="true" goto DO_NOT_INSTALL_COLLABNET_SUBVERSION_CLIENT
echo Installing Collabnet Subversion Client > con
CollabNetSubversion-client-1.6.11-3.win32.exe /S /NCRC
:DO_NOT_INSTALL_COLLABNET_SUBVERSION_CLIENT

:: TortoiseSVN
if not "%INSTALL_TORTOISESVN%"=="true" goto DO_NOT_INSTALL_TORTOISESVN
echo Installing TortoiseSVN > con
msiexec /i TortoiseSVN-1.6.8.19260-x64-svn-1.6.11.msi /passive /norestart
:DO_NOT_INSTALL_TORTOISESVN

:: VisualSVN
if not "%INSTALL_VISUALSVN%"=="true" goto DO_NOT_INSTALL_VISUALSVN
echo Installing VisualSVN > con
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\VisualSVN.au3 "%REPOSITORIES_DIR%" 10443 > nul
echo net %%1 VisualSVNServer > "c:\Program Files (x86)\VisualSVN Server\server.cmd"
:DO_NOT_INSTALL_VISUALSVN

:: Git
if not "%INSTALL_GIT%"=="true" goto DO_NOT_INSTALL_GIT
echo Installing Git > con
start /wait Git-1.7.0.2-preview20100309.exe /Silent /NoRestart
:DO_NOT_INSTALL_GIT

:: GIMP
if not "%INSTALL_GIMP%"=="true" goto DO_NOT_INSTALL_GIMP
echo Installing GIMP > con
gimp-2.6.8-x64-setup.exe /Silent /SP- /NoRestart
:DO_NOT_INSTALL_GIMP

:: Blender
if not "%INSTALL_BLENDER%"=="true" goto DO_NOT_INSTALL_BLENDER
echo Installing Blender > con
"c:\Program Files\7-Zip\7z" x blender-2.49b-win64-python26.zip -o"c:\Program Files\Blender" > nul
:DO_NOT_INSTALL_BLENDER

:: Java JDK
if not "%INSTALL_JAVA_JDK%"=="true" goto DO_NOT_INSTALL_JAVA_JDK
echo Installing Java JDK > con
mkdir "%TOOLS_DIR%\jdk"
jdk-6u20-windows-i586.exe /s /v\"/qn INSTALLDIR=%TOOLS_DIR%\jdk ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 REBOOT=ReallySuppress JAVAUPDATE=0\""
:DO_NOT_INSTALL_JAVA_JDK

:: Eclipse
if not "%INSTALL_ECLIPSE%"=="true" goto DO_NOT_INSTALL_ECLIPSE
echo Installing Eclipse > con
"c:\Program Files\7-Zip\7z" x eclipse-SDK-3.6RC3-win32.zip -o"%TOOLS_DIR%" > nul
"c:\Program Files\7-Zip\7z" x emf-runtime-2.6.0RC2.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x xsd-runtime-2.6.0RC2.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x GEF-ALL-3.6.0RC2.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x dtp-sdk-1.8.0RC3-201005281244.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x wtp-sdk-S-3.2.0RC3-20100529234347.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x wtp-wst-sdk-S-3.2.0RC3-20100529234347.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x dltk-core-sdk-S-2.0RC1-201005190624.zip -o"%TOOLS_DIR%" -aoa > nul
mkdir "%TOOLS_DIR%\eclipse\configuration\.settings"
set TMP_PROJECTS_DIR=%PROJECTS_DIR::\=\:\\%
echo RECENT_WORKSPACES_PROTOCOL=3%NL%MAX_RECENT_WORKSPACES=5%NL%SHOW_WORKSPACE_SELECTION_DIALOG=false%NL%eclipse.preferences.version=1%NL%RECENT_WORKSPACES=%TMP_PROJECTS_DIR% > "%TOOLS_DIR%\eclipse\configuration\.settings\org.eclipse.ui.ide.prefs"
set TMP_TOOLS_DIR=%TOOLS_DIR:\=\\%
"%WINTOOLS_DIR%\gnu\bin\sed" "s/^256m/256m\n-vm\n%TMP_TOOLS_DIR%\\jdk\\bin\\javaw.exe/g" "%TOOLS_DIR%\eclipse\eclipse.ini" > "%TOOLS_DIR%\eclipse\eclipse.ini.tmp"
del "%TOOLS_DIR%\eclipse\eclipse.ini"
rename "%TOOLS_DIR%\eclipse\eclipse.ini.tmp" eclipse.ini
:DO_NOT_INSTALL_ECLIPSE

:: JUnit
if not "%INSTALL_JUNIT%"=="true" goto DO_NOT_INSTALL_JUNIT
echo Installing JUnit > con
"c:\Program Files\7-Zip\7z" x junit4.8.2.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\junit4.8.2" junit
:DO_NOT_INSTALL_JUNIT

:: Ant
if not "%INSTALL_ANT%"=="true" goto DO_NOT_INSTALL_ANT
echo Installing Ant > con
"c:\Program Files\7-Zip\7z" x apache-ant-1.8.1-bin.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\apache-ant-1.8.1" ant
:DO_NOT_INSTALL_ANT

:: Maven
if not "%INSTALL_MAVEN%"=="true" goto DO_NOT_INSTALL_MAVEN
echo Installing Maven > con
"c:\Program Files\7-Zip\7z" x apache-maven-3.0-beta-1-bin.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\apache-maven-3.0-beta-1" maven
:DO_NOT_INSTALL_MAVEN

:: Java Libraries
if not "%INSTALL_JAVA_LIBRARIES%"=="true" goto DO_NOT_INSTALL_JAVA_LIBRARIES
echo Installing Java Libraries > con
"c:\Program Files\7-Zip\7z" x apache-log4j-1.2.16.zip -o"%LIBRARIES_DIR%" > nul
rename "%LIBRARIES_DIR%\apache-log4j-1.2.16" log4j
"c:\Program Files\7-Zip\7z" x guava-r05.zip -o"%LIBRARIES_DIR%" > nul
rename "%LIBRARIES_DIR%\guava-r05" guava
"c:\Program Files\7-Zip\7z" x javamail-1.4.3.zip -o"%LIBRARIES_DIR%" > nul
rename "%LIBRARIES_DIR%\javamail-1.4.3" javamail
"c:\Program Files\7-Zip\7z" x one-jar-sdk-0.96.jar -o"%LIBRARIES_DIR%\one-jar" > nul
copy json.zip "%LIBRARIES_DIR%" > nul
"c:\Program Files\7-Zip\7z" x axis-bin-1_4.zip -o"%LIBRARIES_DIR%" > nul
rename "%LIBRARIES_DIR%\axis-1_4" axis
"c:\Program Files\7-Zip\7z" x poi-bin-3.6-20091214.zip -o"%LIBRARIES_DIR%" > nul
rename "%LIBRARIES_DIR%\poi-3.6" poi
copy iText-5.0.2.jar "%LIBRARIES_DIR%" > nul
"c:\Program Files\7-Zip\7z" x flyingsaucer-R8.zip -o"%LIBRARIES_DIR%\flyingsaucer" > nul
copy jtidy-r938.jar "%LIBRARIES_DIR%" > nul
"c:\Program Files\7-Zip\7z" x android-sdk_r06-windows.zip -o"%LIBRARIES_DIR%" > nul
:DO_NOT_INSTALL_JAVA_LIBRARIES

:: Apache Tomcat
if not "%INSTALL_APACHE_TOMCAT%"=="true" goto DO_NOT_INSTALL_APACHE_TOMCAT
echo Installing Apache Tomcat > con
"c:\Program Files\7-Zip\7z" x apache-tomcat-6.0.26-windows-x86.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\apache-tomcat-6.0.26" tomcat
"%WINTOOLS_DIR%\gnu\bin\sed" "s/8005/9005/g" "%TOOLS_DIR%\tomcat\conf\server.xml" > "%TOOLS_DIR%\tomcat\conf\server.xml.tmp"
"%WINTOOLS_DIR%\gnu\bin\sed" "s/8080/9080/g" "%TOOLS_DIR%\tomcat\conf\server.xml.tmp" > "%TOOLS_DIR%\tomcat\conf\server.xml"
"%WINTOOLS_DIR%\gnu\bin\sed" "s/8443/9443/g" "%TOOLS_DIR%\tomcat\conf\server.xml" > "%TOOLS_DIR%\tomcat\conf\server.xml.tmp"
"%WINTOOLS_DIR%\gnu\bin\sed" "s/8009/9009/g" "%TOOLS_DIR%\tomcat\conf\server.xml.tmp" > "%TOOLS_DIR%\tomcat\conf\server.xml"
del "%TOOLS_DIR%\tomcat\conf\server.xml.tmp"
:DO_NOT_INSTALL_APACHE_TOMCAT

:: Apache HTTP Server
if not "%INSTALL_APACHE_HTTP_SERVER%"=="true" goto DO_NOT_INSTALL_APACHE_HTTP_SERVER
echo Installing Apache HTTP Server > con
msiexec /a httpd-2.2.15-win32-x86-openssl-0.9.8m-r2.msi /qb TARGETDIR=%TEMP%\httpd
xcopy "%TEMP%\httpd\program files\Apache Software Foundation\Apache2.2" "%TOOLS_DIR%\httpd\" /e > nul
rmdir %TEMP%\httpd /s /q
mkdir "%TOOLS_DIR%\httpd\conf\extra"
mkdir "%TOOLS_DIR%\httpd\logs"
"%WINTOOLS_DIR%\gnu\bin\sed" "s/ServerSslPort = \" serverport/ServerSSLPort = \" serversslport/g" "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk" > "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk.tmp"
del "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk"
rename "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk.tmp" installwinconf.awk
"%WINTOOLS_DIR%\gnu\bin\gawk" -f "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk" localhost localhost admin@localhost 80 443 %TOOLS_DIR%\httpd conf/original/
"%TOOLS_DIR%\httpd\bin\httpd" -k install > nul 2>&1
"%WINTOOLS_DIR%\gnu\bin\sed" ^
	-e "s/#ServerName localhost:80/ServerName localhost:80/g" ^
	-e "s/#LoadModule rewrite_module/LoadModule rewrite_module/g" ^
	-e "s/#LoadModule ssl_module/LoadModule ssl_module/g" ^
	-e "s/DirectoryIndex index.html/DirectoryIndex index.html index.php/g" ^
	"%TOOLS_DIR%\httpd\conf\httpd.conf" > "%TOOLS_DIR%\httpd\conf\httpd.conf.tmp"
del "%TOOLS_DIR%\httpd\conf\httpd.conf"
rename "%TOOLS_DIR%\httpd\conf\httpd.conf.tmp" httpd.conf
:DO_NOT_INSTALL_APACHE_HTTP_SERVER

:: NetBeans
if not "%INSTALL_NETBEANS%"=="true" goto DO_NOT_INSTALL_NETBEANS
echo Installing NetBeans > con
netbeans-6.9rc1-ml-windows.exe --silent --state %~d0\Config\netbeans.xml > nul
:DO_NOT_INSTALL_NETBEANS

:: PHP
if not "%INSTALL_PHP%"=="true" goto DO_NOT_INSTALL_PHP
echo Installing PHP > con
"c:\Program Files\7-Zip\7z" x pdt-SDK-2.2.0M3.zip -o"%TOOLS_DIR%" -aoa > nul
"c:\Program Files\7-Zip\7z" x php-5.3.2-Win32-VC9-x86.zip -o"%TOOLS_DIR%\php" > nul
set TMP_TOOLS_DIR=%TOOLS_DIR:\=/%
echo. >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo # *** BEGIN PHP Settings *** >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo LoadModule php5_module "%TMP_TOOLS_DIR%/php/php5apache2_2.dll" >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo AddType application/x-httpd-php .php >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo PHPIniDir "%TMP_TOOLS_DIR%/php" >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo # *** END   PHP Settings *** >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
set TMP_TOOLS_DIR=%TOOLS_DIR:\=\\%
set TMP_LIBRARIES_DIR=%LIBRARIES_DIR:\=\\%
"%WINTOOLS_DIR%\gnu\bin\sed" ^
	-e "s/;include_path = \".;c:\\php\\includes\"/include_path = \".;%TMP_LIBRARIES_DIR%\\zendframework\\1.10.5\\library;%TMP_TOOLS_DIR%\\php\\PEAR\"/g" ^
	-e "s/; extension_dir = \"ext\"/extension_dir = \"%TMP_TOOLS_DIR%\\php\\ext\\\"/g" ^
	-e "s/short_open_tag = Off/short_open_tag = On/g" ^
	-e "s/;extension=php_mbstring.dll/extension=php_mbstring.dll/g" ^
	-e "s/;extension=php_mysql.dll/extension=php_mysql.dll/g" ^
	-e "s/;extension=php_mysqli.dll/extension=php_mysqli.dll/g" ^
	-e "s/;extension=php_openssl.dll/extension=php_openssl.dll/g" ^
	-e "s/;extension=php_pdo_mysql.dll/extension=php_pdo_mysql.dll/g" ^
	"%TOOLS_DIR%\php\php.ini-development" > "%TOOLS_DIR%\php\php.ini"
%DESTINATION_DRIVE%:
cd %TOOLS_DIR%\php
set PHP_BIN=%TOOLS_DIR%\php\php-win.exe
%PHP_BIN% -d output_buffering=0 %TOOLS_DIR%\php\PEAR\go-pear.phar
%~d0
cd %~dp0
:DO_NOT_INSTALL_PHP

:: Phing
if not "%INSTALL_PHING%"=="true" goto DO_NOT_INSTALL_PHING
echo Installing Phing > con
"c:\Program Files\7-Zip\7z" x phing-2.4.1.zip -o"%TOOLS_DIR%\phing" > nul
:DO_NOT_INSTALL_PHING

:: Zend Framework
if not "%INSTALL_ZEND_FRAMEWORK%"=="true" goto DO_NOT_INSTALL_ZEND_FRAMEWORK
echo Installing Zend Framework > con
rem TODO check it
"c:\Program Files\7-Zip\7z" x ZendFramework-1.10.5.zip -o"%LIBRARIES_DIR%\zendframework" > nul
rename "%LIBRARIES_DIR%\zendframework\ZendFramework-1.10.5" 1.10.5
:DO_NOT_INSTALL_ZEND_FRAMEWORK

:: Dojo Toolkit
if not "%INSTALL_DOJO_TOOLKIT%"=="true" goto DO_NOT_INSTALL_DOJO_TOOLKIT
echo Installing Dojo Toolkit > con
rem TODO check it
"c:\Program Files\7-Zip\7z" x dojo-release-1.4.3-src.zip -o"%LIBRARIES_DIR%\dojotoolkit" > nul
rename "%LIBRARIES_DIR%\dojotoolkit\dojo-release-1.4.3-src" 1.4.3
"C:\Program Files (x86)\CollabNet\Subversion Client\svn.exe" checkout http://svn.dojotoolkit.org/src/view/anon/all/trunk "%LIBRARIES_DIR%\dojotoolkit\svn"
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\httpd\htdocs\dojotoolkit" "%LIBRARIES_DIR%\dojotoolkit"
:DO_NOT_INSTALL_DOJO_TOOLKIT

:: jQuery
if not "%INSTALL_JQUERY%"=="true" goto DO_NOT_INSTALL_JQUERY
echo Installing jQuery > con
mkdir "%LIBRARIES_DIR%\jquery"
copy jquery-1.4.2.js "%LIBRARIES_DIR%\jquery" > nul
copy jquery-1.4.2.min.js "%LIBRARIES_DIR%\jquery" > nul
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\httpd\htdocs\jquery" "%LIBRARIES_DIR%\jquery"
:DO_NOT_INSTALL_JQUERY

:: Web Debbuging Tools
if not "%INSTALL_WEB_DEBBUGING_TOOLS%"=="true" goto DO_NOT_INSTALL_WEB_DEBBUGING_TOOLS
echo Installing Web Debbuging Tools > con
Fiddler2Setup.exe /S
charles_setup64.exe /S
:DO_NOT_INSTALL_WEB_DEBBUGING_TOOLS

:: oXygen XML Editor
if not "%INSTALL_OXYGEN_XML_EDITOR%"=="true" goto DO_NOT_INSTALL_OXYGEN_XML_EDITOR
echo Installing oXygen XML Editor > con
"c:\Program Files\7-Zip\7z" x oxygen.zip -o"c:\Program Files (x86)" > nul
:DO_NOT_INSTALL_OXYGEN_XML_EDITOR

:: Wireshark
if not "%INSTALL_WIRESHARK%"=="true" goto DO_NOT_INSTALL_WIRESHARK
echo Installing Wireshark > con
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\Wireshark.au3 > nul
:DO_NOT_INSTALL_WIRESHARK

:: MySQL Workbench
if not "%INSTALL_MYSQL_WORKBENCH%"=="true" goto DO_NOT_INSTALL_MYSQL_WORKBENCH
echo Installing MySQL Workbench > con
"c:\Program Files\7-Zip\7z" x mysql-workbench-oss-5.2.21-rc-win32-noinstall.zip -o"c:\Program Files (x86)\MySQL" > nul
rename "c:\Program Files (x86)\MySQL\MySQL Workbench 5.2.21 OSS" "MySQL Workbench"
:DO_NOT_INSTALL_MYSQL_WORKBENCH

:: Microsoft SQL Server Management Studio
if not "%INSTALL_MICROSOFT_SQL_SERVER_MANAGEMENT_STUDIO%"=="true" goto DO_NOT_INSTALL_MICROSOFT_SQL_SERVER_MANAGEMENT_STUDIO
echo Installing Microsoft SQL Server Management Studio > con
start /wait SQLManagementStudio_x64_ENU.exe /ACTION=install /FEATURES=Tools /Q /HIDECONSOLE
:DO_NOT_INSTALL_MICROSOFT_SQL_SERVER_MANAGEMENT_STUDIO

:: Oracle SQL Developer
if not "%INSTALL_ORACLE_SQL_DEVELOPER%"=="true" goto DO_NOT_INSTALL_ORACLE_SQL_DEVELOPER
echo Installing Oracle SQL Developer > con
"c:\Program Files\7-Zip\7z" x sqldeveloper-2.1.1.64.45-no-jre.zip -o"c:\Program Files (x86)\Oracle" > nul
rename "c:\Program Files (x86)\Oracle\sqldeveloper" "Oracle SQL Developer"
:DO_NOT_INSTALL_ORACLE_SQL_DEVELOPER

:: Internet Explorer
if not "%INSTALL_INTERNET_EXPLORER%"=="true" goto DO_NOT_INSTALL_INTERNET_EXPLORER
echo Installing Internet Explorer > con
IE8-WindowsServer2003-x64-ENU.exe /passive /quiet /update-no /no-default /nobackup /norestart
:DO_NOT_INSTALL_INTERNET_EXPLORER

:: Opera
if not "%INSTALL_OPERA%"=="true" goto DO_NOT_INSTALL_OPERA
echo Installing Opera > con
Opera_1053_en_Setup.exe /S /V"ALLUSERS=1 CREATE_STARTMENU_ICONS=1 CREATE_DESKTOP_ICON=0 CREATE_QUICKLAUNCH_ICON=1 MULTI_USER_SETTING=1 /Passive /NoRestart"
:DO_NOT_INSTALL_OPERA

:: Safari
if not "%INSTALL_SAFARI%"=="true" goto DO_NOT_INSTALL_SAFARI
echo Installing Safari > con
SafariSetup.exe /passive /norestart
:DO_NOT_INSTALL_SAFARI

:: Google Chrome
if not "%INSTALL_CHROME%"=="true" goto DO_NOT_INSTALL_CHROME
echo Installing Google Chrome > con
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\Chrome.au3 > nul
timeout /t 5 > nul
taskkill /IM chrome.exe /T /F > nul
:DO_NOT_INSTALL_CHROME

:: Firefox
if not "%INSTALL_FIREFOX%"=="true" goto DO_NOT_INSTALL_FIREFOX
echo Installing Firefox > con
"Firefox Setup 3.6.3.exe" /S /V"/Passive /NoRestart"
"c:\Program Files (x86)\Mozilla Firefox\firefox.exe" -silent -CreateProfile %USERNAME%

echo Downloading Firefox Plugins > con
:: Adblock Plus
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/1865/addon-1865-latest.xpi
:: British English Dictionary
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/3366/addon-3366-latest.xpi
:: external IP
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/3372/addon-3372-latest.xpi
:: Flagfox
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/5791/addon-5791-latest.xpi
:: Flashblock
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/433/addon-433-latest.xpi
:: MinimizeToTray revived
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/12581/platform:5/addon-12581-latest.xpi
:: NoScript
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/722/addon-722-latest.xpi
:: Personas
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/10900/addon-10900-latest.xpi
:: Polish Spellchecker Dictionary
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/3052/addon-3052-latest.xpi
:: ShowIP
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/590/addon-590-latest.xpi
:: WorldIP
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/8661/addon-8661-latest.xpi
:: Xmarks
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/2410/addon-2410-latest.xpi

if not "%INSTALL_FIREFOX_PLUGINS%"=="true" goto DO_NOT_INSTALL_FIREFOX_PLUGINS
echo Downloading Additional Firefox Plugins > con

mkdir "%DOWNLOADS_DIR%\firefox-plugins"

:: ChatZilla
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/16/addon-16-latest.xpi
:: CSS Usage
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/10704/addon-10704-latest.xpi
:: CSS Validator
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/2289/addon-2289-latest.xpi
:: DownThemAll!
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/201/addon-201-latest.xpi
:: Firebug
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/1843/addon-1843-latest.xpi
:: Firecookie
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/6683/addon-6683-latest.xpi
:: Firepicker
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/15032/addon-15032-latest.xpi
:: FireRainbow
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/file/76450/addon-76450-latest.xpi?confirmed -O "%DOWNLOADS_DIR%\firefox-plugins\firerainbow-fx.xpi"
:: FlashGot
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/220/addon-220-latest.xpi
:: Forecastfox
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/398/addon-398-latest.xpi
:: FoxyProxy
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/2464/addon-2464-latest.xpi
:: Greasemonkey
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/748/addon-748-latest.xpi
:: Gspace
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/1593/addon-1593-latest.xpi
:: HTML Validator
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/249/platform:5/addon-249-latest.xpi
:: Jiffy
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/7613/addon-7613-latest.xpi
:: KGen
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/4788/addon-4788-latest.xpi
:: Live HTTP Headers
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/3829/addon-3829-latest.xpi
:: MeasureIt
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/539/addon-539-latest.xpi
:: Modify Headers
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/967/addon-967-latest.xpi
:: Pixel Perfect
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/7943/addon-7943-latest.xpi
:: Poster
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/2691/addon-2691-latest.xpi
:: SenSEO
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/9403/addon-9403-latest.xpi
:: SeoQuake SEO extension
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/3036/addon-3036-latest.xpi
:: Tamper Data
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/966/addon-966-latest.xpi
:: Torbutton
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/2275/addon-2275-latest.xpi
:: User Agent Switcher
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/59/addon-59-latest.xpi
:: Web Developer
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/60/addon-60-latest.xpi
:: XRefresh
call :installFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/file/76447/addon-76447-latest.xpi?confirmed -O "%TEMP%\xrefresh-fx.xpi"
:: YSlow
call :downloadFirefoxPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/5369/addon-5369-latest.xpi
:DO_NOT_INSTALL_FIREFOX_PLUGINS

echo Installing Firefox Plugins > con
for /f %%a in ('dir /b %TEMP%\*.xpi') do (
	start "" "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" %TEMP%\%%a
	"c:\Program Files\AutoIt\AutoIt3.exe" /AutoIt3ExecuteLine "WinWait('Software Installation')"
	"c:\Program Files\AutoIt\AutoIt3.exe" /AutoIt3ExecuteLine "WinActivate('Software Installation')"
	timeout /t 3 > nul
	"c:\Program Files\AutoIt\AutoIt3.exe" /AutoIt3ExecuteLine "ControlClick('Software Installation', '', '', '', 1, 360, 290)"
	timeout /t 2 > nul
	taskkill /IM firefox.exe /T /F > nul
	timeout /t 5 > nul
)

:DO_NOT_INSTALL_FIREFOX

:: Thunderbird
if not "%INSTALL_THUNDERBIRD%"=="true" goto DO_NOT_INSTALL_THUNDERBIRD
echo Installing Thunderbird > con
start "" /wait "Thunderbird Setup 3.0.4.exe" -ms

echo Installing Thunderbird Plugins > con
:: MinimizeToTray revived
call :installThunderbirdPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/12581/platform:5/addon-12581-latest.xpi
:: Personas
call :installThunderbirdPlugin https://addons.mozilla.org/en-US/firefox/downloads/latest/10900/addon-10900-latest.xpi
:DO_NOT_INSTALL_THUNDERBIRD

:: Flash Player
if not "%INSTALL_FLASH_PLAYER%"=="true" goto DO_NOT_INSTALL_FLASH_PLAYER
echo Installing Flash Player > con
install_flash_player_ax.exe /S
install_flash_player.exe /S
:DO_NOT_INSTALL_FLASH_PLAYER

:: Shockwave Player
if not "%INSTALL_SHOCKWAVE%"=="true" goto DO_NOT_INSTALL_SHOCKWAVE
echo Installing Shockwave Player > con
Shockwave_Installer_Full.exe /S
:DO_NOT_INSTALL_SHOCKWAVE

:: Silverlight
if not "%INSTALL_SILVERLIGHT%"=="true" goto DO_NOT_INSTALL_SILVERLIGHT
echo Installing Silverlight > con
Silverlight.exe /Q
:DO_NOT_INSTALL_SILVERLIGHT

:: Free Download Manager
if not "%INSTALL_FREE_DOWNLOAD_MANAGER%"=="true" goto DO_NOT_INSTALL_FREE_DOWNLOAD_MANAGER
echo Installing Free Download Manager > con
fdminst.exe /SILENT /NORESTART
"c:\Program Files (x86)\Software Informer\unins000.exe" /SILENT
rmdir "c:\Program Files (x86)\Software Informer" /s /q
:DO_NOT_INSTALL_FREE_DOWNLOAD_MANAGER

:: eMule
if not "%INSTALL_EMULE%"=="true" goto DO_NOT_INSTALL_EMULE
echo Installing eMule > con
eMule0.50a-Installer.exe /S /NCRC
:DO_NOT_INSTALL_EMULE

:: uTorrent
if not "%INSTALL_UTORRENT%"=="true" goto DO_NOT_INSTALL_UTORRENT
echo Installing uTorrent > con
utorrent.exe /PerformInstall 2
:DO_NOT_INSTALL_UTORRENT

:: Skype
if not "%INSTALL_SKYPE%"=="true" goto DO_NOT_INSTALL_SKYPE
echo Installing Skype > con
msiexec /i SkypeSetup.msi /Passive /NoRestart
:DO_NOT_INSTALL_SKYPE

:: osbuild
if not "%INSTALL_OSBUILD%"=="true" goto DO_NOT_INSTALL_OSBUILD
echo Getting osbuild > con
rem TODO it doesn't work with current svn client
"C:\Program Files (x86)\CollabNet\Subversion Client\svn.exe" checkout https://osbuild.googlecode.com/svn/trunk/ %PROJECTS_DIR%\osbuild --username daniel.stefaniuk
:DO_NOT_INSTALL_OSBUILD

if not "%OS_INSTALL%"=="true" goto IT_IS_NOT_OS_INSTALL_2

call :defragment

start %1 --run-once "%1 --pass-3 %ARGUMENTS%"

@echo off
echo.
goto:eof

:: ===========================================================================================================================================================================================

:PASS3

call :processExplorer

:IT_IS_NOT_OS_INSTALL_2

:: DAEMON Tools Lite
if not "%INSTALL_DAEMON_TOOLS_LITE%"=="true" goto DO_NOT_INSTALL_DAEMON_TOOLS_LITE
echo Installing DAEMON Tools Lite > con
DTLite4356-0091.exe /S
"c:\Program Files (x86)\DAEMON Tools Toolbar\uninst.exe" /S
timeout /t 5 > nul
rmdir "c:\Program Files (x86)\DAEMON Tools Toolbar" /s /q
start "" /wait "c:\Program Files (x86)\DAEMON Tools Lite\DTLite.exe" -set_count 2
:DO_NOT_INSTALL_DAEMON_TOOLS_LITE

:: Visual Studio Express
if not "%INSTALL_VISUAL_STUDIO%"=="true" goto DO_NOT_INSTALL_VISUAL_STUDIO
echo Installing Visual Studio Express > con
start "" /wait "c:\Program Files (x86)\DAEMON Tools Lite\DTLite.exe" -mount 0,%~d0\AddOns\VS2008ExpressWithSP1ENUX1504728.iso
for %%i in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\Setup.hta set VS_CDROM=%%i:
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\VCExpress.au3 "%VS_CDROM%" > nul
timeout /t 5 > nul
start "" /wait "c:\Program Files\AutoIt\AutoIt3.exe" %~d0\AutoIt\VCSExpress.au3 "%VS_CDROM%" > nul
start "" /wait "c:\Program Files (x86)\DAEMON Tools Lite\DTLite.exe" -unmount 0
:DO_NOT_INSTALL_VISUAL_STUDIO

:: Windows Kernel Mode Tools
if not "%INSTALL_KERNEL_MODE_TOOLS%"=="true" goto DO_NOT_INSTALL_KERNEL_MODE_TOOLS
echo Installing Windows Kernel Mode Tools > con
rem TODO wdk - install it, see http://www.winvistatips.com/installing-wdk-windows-xp-64-bit-t583599.html
"c:\Program Files\7-Zip\7z" x devicetree_v221.zip -o"%WINTOOLS_DIR%" > nul
move "%WINTOOLS_DIR%\kits\devicetree" "%WINTOOLS_DIR%\DeviceTree" > nul
rmdir "%WINTOOLS_DIR%\kits" /s /q
"c:\Program Files\7-Zip\7z" x DebugView.zip -o"%WINTOOLS_DIR%\DebugView" > nul
start "" "%WINTOOLS_DIR%\DebugView\Dbgview.exe" /accepteula && timeout /t 2 > nul
taskkill /IM Dbgview.exe /T /F > nul
"c:\Program Files\7-Zip\7z" x InstDvr.zip -o"%WINTOOLS_DIR%" > nul
rename "%WINTOOLS_DIR%\InstDvr" InstDrv
"c:\Program Files\7-Zip\7z" x PEiD-0.95-20081103.zip -o"%WINTOOLS_DIR%\PEiD" > nul
:DO_NOT_INSTALL_KERNEL_MODE_TOOLS

:: VMware Server
if not "%INSTALL_VMWARE_SERVER%"=="true" goto DO_NOT_INSTALL_VMWARE_SERVER
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_INSTALL_VMWARE_SERVER
echo Installing VMware Server > con
if not exist "%VIRTUAL_MACHINES_DIR%" mkdir "%VIRTUAL_MACHINES_DIR%"
VMware-server-2.0.2-203138.exe /a /s /v TARGETDIR="%TEMP%\VMware Server" /qn
timeout /t 60 > nul
msiexec /i "%TEMP%\VMware Server\VMware Server.msi" ADDLOCAL=ALL REBOOT=REALLYSUPPRESS SERIALNUMBER="9A54H-YHJ4Z-1G25J-4C09N" /qn
copy "%~d0\Utils\VMwareServerCtrl.cmd" "c:\Program Files (x86)\VMware\VMware Server\server.cmd" > nul
:DO_NOT_INSTALL_VMWARE_SERVER

:: MySQL Community Server
if not "%INSTALL_MYSQL%"=="true" goto DO_NOT_INSTALL_MYSQL
echo Installing MySQL Community Server > con
"c:\Program Files\7-Zip\7z" x mysql-noinstall-5.1.47-winx64.zip -o"c:\Program Files\MySQL" > nul
rename "c:\Program Files\MySQL\mysql-5.1.47-winx64" "MySQL Server"
mkdir "%TOOLS_DIR%\mysql"
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\mysql" "c:\Program Files\MySQL\MySQL Server" > nul
copy "%TOOLS_DIR%\mysql\my-small.ini" "%TOOLS_DIR%\mysql\my.ini" > nul
"%TOOLS_DIR%\mysql\bin\mysqld" --install MySQL --defaults-file="%TOOLS_DIR%\mysql\my.ini" > nul
echo net %%1 MySQL > "%TOOLS_DIR%\mysql\server.cmd"
:DO_NOT_INSTALL_MYSQL

:: Microsoft SQL Server Express
if not "%INSTALL_MSSQL%"=="true" goto DO_NOT_INSTALL_MSSQL
echo Installing Microsoft SQL Server Express > con
start /wait SQLEXPR_x64_ENU.exe /CONFIGURATIONFILE=%~d0\Config\sql2008ee.ini /Q /HIDECONSOLE
mkdir "%TOOLS_DIR%\mssql"
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\mssql" "c:\Program Files (x86)\Microsoft SQL Server" > nul
:DO_NOT_INSTALL_MSSQL

:: Oracle Express Edition
if not "%INSTALL_ORACLE%"=="true" goto DO_NOT_INSTALL_ORACLE
echo Installing Oracle Express Edition > con
mkdir "c:\Program Files (x86)\Oracle\Oracle Server"
mkdir "%TOOLS_DIR%\oracle"
"%WINTOOLS_DIR%\junction" "%TOOLS_DIR%\oracle" "c:\Program Files (x86)\Oracle\Oracle Server" > nul
set TMP_TOOLS_DIR=%TOOLS_DIR:\=\\%
"%WINTOOLS_DIR%\gnu\bin\sed" "s/${directory}/%TMP_TOOLS_DIR%/g" %~d0\Config\OracleXE.iss > %TEMP%\OracleXE.iss
start /wait OracleXE.exe /s /f1"%TEMP%\OracleXE.iss"
del %TEMP%\OracleXE.iss
copy "%~d0\Utils\OracleCtrl.cmd" "%TOOLS_DIR%\oracle\server.cmd" > nul
:DO_NOT_INSTALL_ORACLE

:: CPU-Z
if not "%INSTALL_CPU_Z%"=="true" goto DO_NOT_INSTALL_CPU_Z
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_INSTALL_CPU_Z
echo Installing CPU-Z > con
"c:\Program Files\7-Zip\7z" x cpuz64_154.zip -o"%WINTOOLS_DIR%\CPU-Z" > nul
:DO_NOT_INSTALL_CPU_Z

:: GPU-Z
if not "%INSTALL_GPU_Z%"=="true" goto DO_NOT_INSTALL_GPU_Z
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_INSTALL_GPU_Z
echo Installing GPU-Z > con
copy GPU-Z.0.4.3.exe "%WINTOOLS_DIR%\gpuz.exe" > nul
:DO_NOT_INSTALL_GPU_Z

:: ESET Smart Security
if not "%INSTALL_ESET_SMART_SECURITY%"=="true" goto DO_NOT_INSTALL_ESET_SMART_SECURITY
echo Installing ESET Smart Security > con
msiexec.exe /i ess_nt64_enu.msi ADMINCFG="%~d0\Config\ESETSmartSecurity.xml" REBOOT="ReallySuppress" /qb!
:DO_NOT_INSTALL_ESET_SMART_SECURITY

if not "%OS_INSTALL%"=="true" goto:eof

call :defragment

start %1 --run-once "%1 --pass-4 %ARGUMENTS%"

@echo off
echo.
goto:eof

:: ===========================================================================================================================================================================================

:PASS4

call :processExplorer

:: System Customization
echo Customizing System > con

:: environment variables
if "%INSTALL_JAVA_JDK%"=="true" reg add HKEY_CURRENT_USER\Environment /v JAVA_HOME /t REG_SZ /d "%TOOLS_DIR%\jdk" /f > nul
if "%INSTALL_ECLIPSE%"=="true" reg add HKEY_CURRENT_USER\Environment /v ECLPSE_HOME /t REG_SZ /d "%TOOLS_DIR%\eclipse" /f > nul
if "%INSTALL_JUNIT%"=="true" reg add HKEY_CURRENT_USER\Environment /v JUNIT_HOME /t REG_SZ /d "%TOOLS_DIR%\junit" /f > nul
if "%INSTALL_ANT%"=="true" reg add HKEY_CURRENT_USER\Environment /v ANT_HOME /t REG_SZ /d "%TOOLS_DIR%\ant" /f > nul
if "%INSTALL_MAVEN%"=="true" reg add HKEY_CURRENT_USER\Environment /v M2_HOME /t REG_SZ /d "%TOOLS_DIR%\maven" /f > nul
if "%INSTALL_APACHE_TOMCAT%"=="true" reg add HKEY_CURRENT_USER\Environment /v CATALINA_HOME /t REG_SZ /d "%TOOLS_DIR%\tomcat" /f > nul
if "%INSTALL_JUNIT%"=="true" reg add HKEY_CURRENT_USER\Environment /v CLASSPATH /t REG_EXPAND_SZ /d "%TOOLS_DIR%\junit\junit-4.8.1.jar" /f > nul
if "%INSTALL_PHING%"=="true" (
	reg add HKEY_CURRENT_USER\Environment /v PHP_COMMAND /t REG_EXPAND_SZ /d "%TOOLS_DIR%\php\php.exe" /f > nul
	reg add HKEY_CURRENT_USER\Environment /v PHING_HOME /t REG_EXPAND_SZ /d "%TOOLS_DIR%\phing" /f > nul
	reg add HKEY_CURRENT_USER\Environment /v PHP_CLASSPATH /t REG_EXPAND_SZ /d "%TOOLS_DIR%\phing\classes" /f > nul
)
set NEW_PATH="c:\Program Files\7-Zip";"c:\Program Files\AutoIt";"%WINTOOLS_DIR%";"%WINTOOLS_DIR%\gnu\bin"
if "%INSTALL_NLITE%"=="true" set NEW_PATH=%NEW_PATH%;"c:\Program Files (x86)\nLite"
if "%INSTALL_JAVA_JDK%"=="true" set NEW_PATH=%NEW_PATH%;%%JAVA_HOME%%\bin
if "%INSTALL_ANT%"=="true" set NEW_PATH=%NEW_PATH%;%%ANT_HOME%%\bin
if "%INSTALL_MAVEN%"=="true" set NEW_PATH=%NEW_PATH%;%%M2_HOME%%\bin
if "%INSTALL_JAVA_LIBRARIES%"=="true" set NEW_PATH=%NEW_PATH%;%LIBRARIES_DIR%\android-sdk-windows\tools
if "%INSTALL_PHP%"=="true" set NEW_PATH=%NEW_PATH%;%TOOLS_DIR%\php
if "%INSTALL_PHING%"=="true" set NEW_PATH=%NEW_PATH%;%%PHING_HOME%%\bin
if "%INSTALL_ZEND_FRAMEWORK%"=="true" set NEW_PATH=%NEW_PATH%;%LIBRARIES_DIR%\zendframework\1.10.5\bin
if "%INSTALL_MYSQL%"=="true" set NEW_PATH=%NEW_PATH%;"%TOOLS_DIR%\mysql\bin"
reg add HKEY_CURRENT_USER\Environment /v PATH /t REG_EXPAND_SZ /d %NEW_PATH% /f > nul
if "%INSTALL_NOTEPADPP%"=="true" reg add HKEY_CURRENT_USER\Environment /v SVN_EDITOR /t REG_EXPAND_SZ /d "C:\Program Files\Notepad++\notepad++.exe" /f > nul

:: auto run programs
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v "Free Download Manager" /f > nul
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v "Google Update" /f > nul
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v "Skype" /f > nul
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v "Software Informer" /f > nul
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /v "Adobe ARM" /f > nul
reg delete HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /v "Adobe Reader Speed Launcher" /f > nul
reg delete HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /v "SunJavaUpdateSched" /f > nul
reg delete HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /v "UnlockerAssistant" /f > nul
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v "Process Explorer" /t REG_SZ /d "\"%WINTOOLS_DIR%\procexp.exe\" /t" /f > nul

:: Internet Explorer
reg delete "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{02478D38-C3F9-4efb-9B51-7695ECA05670}" /f > nul
reg delete "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{CC59E0F9-7E43-44FA-9FAA-8377850BF205}" /f > nul
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Toolbar" /v "{32099AAC-C132-4136-9E9A-4E364A424E17}" /f > nul

:: desktop shortcuts
del "%ALLUSERSPROFILE%\Desktop\*.lnk"
del "%USERPROFILE%\Desktop\*.lnk"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\Windows XP Activation Hack.lnk" /t:"%WINTOOLS_DIR%\windows_xp_activation_hack\AntiWPA3.cmd" /w:"%WINTOOLS_DIR%\windows_xp_activation_hack\" /r:1
if "%INSTALL_APACHE_TOMCAT%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\Tomcat Start.lnk" /t:"%TOOLS_DIR%\tomcat\bin\startup.bat" /w:"%TOOLS_DIR%\tomcat\bin\" /i:"%TOOLS_DIR%\tomcat\bin\tomcat6.exe" /r:1
if "%INSTALL_APACHE_TOMCAT%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\Tomcat Stop.lnk" /t:"%TOOLS_DIR%\tomcat\bin\shutdown.bat" /w:"%TOOLS_DIR%\tomcat\bin\" /i:"%TOOLS_DIR%\tomcat\bin\tomcat6.exe" /r:1
if "%INSTALL_APACHE_HTTP_SERVER%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\HTTPD Start.lnk" /t:"%TOOLS_DIR%\httpd\bin\httpd.exe" /w:"%TOOLS_DIR%\httpd\bin\" /p:"-k start" /r:1
if "%INSTALL_APACHE_HTTP_SERVER%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\HTTPD Stop.lnk" /t:"%TOOLS_DIR%\httpd\bin\httpd.exe" /w:"%TOOLS_DIR%\httpd\bin\" /p:"-k stop" /r:1
if "%INSTALL_MYSQL%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\MySQL Start.lnk" /t:"%TOOLS_DIR%\mysql\server.cmd" /p:"start"
if "%INSTALL_MYSQL%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\MySQL Stop.lnk" /t:"%TOOLS_DIR%\mysql\server.cmd" /p:"stop"
if "%INSTALL_VISUALSVN%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\VisualSVN Start.lnk" /t:"c:\Program Files (x86)\VisualSVN Server\server.cmd" /p:"start" /i:"c:\Program Files (x86)\VisualSVN Server\htdocs\favicon.ico"
if "%INSTALL_VISUALSVN%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\VisualSVN Stop.lnk" /t:"c:\Program Files (x86)\VisualSVN Server\server.cmd" /p:"stop" /i:"c:\Program Files (x86)\VisualSVN Server\htdocs\favicon.ico"
if "%INSTALL_ORACLE%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\Oracle Start.lnk" /t:"%TOOLS_DIR%\oracle\server.cmd" /p:"start" /i:"c:\windows\Installer\{F0BC0F9E-C4A8-485C-93ED-424DB9EA3F75}\Start_Listener_F0BC0F9EC4A8485C93ED424DB9EA3F75_1.exe" /r:1
if "%INSTALL_ORACLE%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\Oracle Stop.lnk" /t:"%TOOLS_DIR%\oracle\server.cmd" /p:"stop" /i:"c:\windows\Installer\{F0BC0F9E-C4A8-485C-93ED-424DB9EA3F75}\Stop_Listener_F0BC0F9EC4A8485C93ED424DB9EA3F75_1.exe" /r:1

:: Quick Launch shortcuts
del "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\*.lnk"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Command Prompt.lnk" /t:c:\windows\system32\cmd.exe /w:%DESTINATION_DRIVE%:\ /r:3
if "%INSTALL_TRUECRYPT%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\TrueCrypt.lnk" /t:"C:\Program Files (x86)\TrueCrypt\TrueCrypt.exe"
if "%INSTALL_TOTAL_COMMANDER%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Total Commander.lnk" /t:"C:\Program Files (x86)\totalcmd\TOTALCMD.EXE"
if "%INSTALL_NOTEPADPP%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Notepad++.lnk" /t:"C:\Program Files (x86)\Notepad++\notepad++.exe" /w:"C:\Program Files (x86)\Notepad++\localization"
if "%INSTALL_NLITE%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\nLite.lnk" /t:"C:\Program Files (x86)\nLite\nLite.exe" /w:"C:\Program Files (x86)\nLite"
if "%INSTALL_AIMP2%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AIMP.lnk" /t:"C:\Program Files (x86)\AIMP2\AIMP2.exe" /w:"C:\Program Files (x86)\AIMP2\Langs"
if "%INSTALL_FIREFOX%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Firefox.lnk" /t:"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" /w:"C:\Program Files (x86)\Mozilla Firefox"
if "%INSTALL_ECLIPSE%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Eclipse.lnk" /t:"%TOOLS_DIR%\eclipse\eclipse.exe"
if "%INSTALL_NETBEANS%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\NetBeans.lnk" /t:"C:\Program Files (x86)\NetBeans\bin\netbeans.exe"
if "%INSTALL_VISUAL_STUDIO%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Visual C++.lnk" /t:"C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\VCExpress.exe" /r:1
if "%INSTALL_VISUAL_STUDIO%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Visual C#.lnk" /t:"C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\vcsexpress.exe" /r:1
if "%INSTALL_PUTTY%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\PuTTY.lnk" /t:"c:\Program Files (x86)\PuTTY\putty.exe"

:: VMware Server shortcuts
if not "%INSTALL_VMWARE_SERVER%"=="true" goto DO_NOT_CREATE_SHORTCUT_FOR_VMWARE_SERVER
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_CREATE_SHORTCUT_FOR_VMWARE_SERVER
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\VMware, Inc.\VMware Server" %TEMP%\VMwareServer.reg > nul
type %TEMP%\VMwareServer.reg | find "ProductCode" > %TEMP%\VMwareServer.txt
for /F %%N in (%TEMP%\VMwareServer.txt) do set STR_PRODUCT_CODE=%%N
set STR_PRODUCT_CODE=%STR_PRODUCT_CODE:~15,-1%
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\VMware Server.lnk" /t:"c:\Program Files (x86)\VMware\VMware Server\serverui.url" /i:"c:\windows\Installer\%STR_PRODUCT_CODE%\VMserver_App.ico1"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\VMware Server Start.lnk" /t:"c:\Program Files (x86)\VMware\VMware Server\server.cmd" /i:"c:\windows\Installer\%STR_PRODUCT_CODE%\VMserver_App.ico1" /p:"start"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%USERPROFILE%\Desktop\VMware Server Stop.lnk" /t:"c:\Program Files (x86)\VMware\VMware Server\server.cmd" /i:"c:\windows\Installer\%STR_PRODUCT_CODE%\VMserver_App.ico1" /p:"stop"
del %TEMP%\VMwareServer.*
:DO_NOT_CREATE_SHORTCUT_FOR_VMWARE_SERVER

:: Start Menu shortcuts
del "%USERPROFILE%\Start Menu\eBay.lnk"
del "%ALLUSERSPROFILE%\Start Menu\Set Program Access and Defaults.lnk"
move /Y "%ALLUSERSPROFILE%\Start Menu\*.lnk" "%ALLUSERSPROFILE%\Start Menu\Programs" > nul
mkdir "%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\Autoruns.lnk" /t:"%WINTOOLS_DIR%\autoruns.exe"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\Process Explorer.lnk" /t:"%WINTOOLS_DIR%\procexp.exe"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\RegShot.lnk" /t:"%WINTOOLS_DIR%\regshot.exe"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\TweakUI.lnk" /t:"%WINTOOLS_DIR%\TweakUI.exe"
mkdir "%ALLUSERSPROFILE%\Start Menu\Programs\AutoIt"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\AutoIt\AutoIt.lnk" /t:"c:\Program Files\AutoIt\AutoIt3_x64.exe"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\AutoIt\AutoIt Info.lnk" /t:"c:\Program Files\AutoIt\Au3Info_x64.exe"
cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\AutoIt\AutoIt Help.lnk" /t:"c:\Program Files\AutoIt\AutoIt3.chm"
if "%INSTALL_GRAPHCALC%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\GraphCalc.lnk" /t:"c:\Program Files (x86)\GraphCalc\GrphCalc.exe"
if "%INSTALL_BLENDER%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Blender.lnk" /t:"c:\Program Files\Blender\blender.exe"
if "%INSTALL_ECLIPSE%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Eclipse.lnk" /t:"%TOOLS_DIR%\eclipse\eclipse.exe"
if "%INSTALL_OXYGEN_XML_EDITOR%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\oXygen XML Editor.lnk" /t:"c:\Program Files (x86)\Oxygen\oxygen.exe"
if "%INSTALL_MYSQL_WORKBENCH%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\MySQL Workbench.lnk" /t:"c:\Program Files (x86)\MySQL\MySQL Workbench\MySQLWorkbench.exe"
if "%INSTALL_ORACLE_SQL_DEVELOPER%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Oracle SQL Developer.lnk" /t:"c:\Program Files (x86)\Oracle\Oracle SQL Developer\sqldeveloper.exe"
if "%INSTALL_KERNEL_MODE_TOOLS%"=="true" (
	cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\DeviceTree.lnk" /t:"%WINTOOLS_DIR%\DeviceTree\wnet\AMD64\DeviceTree.exe"
	cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\DebugView.lnk" /t:"%WINTOOLS_DIR%\DebugView\Dbgview.exe"
	cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\InstDrv.lnk" /t:"%WINTOOLS_DIR%\InstDrv\INSTDRV.exe"
	cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\PEiD.lnk" /t:"%WINTOOLS_DIR%\PEiD\PEiD.exe"
)
if "%IS_DESKTOP_COMPUTER%"=="true" (
	if "%INSTALL_CPU_Z%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\CPU-Z.lnk" /t:"%WINTOOLS_DIR%\CPU-Z\cpuz64.exe
	if "%INSTALL_GPU_Z%"=="true" cscript //nologo %~d0\Utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Windows Tools\GPU-Z.lnk" /t:"%WINTOOLS_DIR%\gpuz.exe
)

:END_OF_INSTALLATION

:: user pictures
copy /Y "%ALLUSERSPROFILE%\Application Data\Microsoft\User Account Pictures\Default Pictures\chess.bmp" "%ALLUSERSPROFILE%\Application Data\Microsoft\User Account Pictures\%USERNAME%.bmp" > nul
copy /Y "%ALLUSERSPROFILE%\Application Data\Microsoft\User Account Pictures\Default Pictures\dirt bike.bmp" "%ALLUSERSPROFILE%\Application Data\Microsoft\User Account Pictures\%LIMITED_USER%.bmp" > nul

:: wallpapers
xcopy %~d0\Wallpapers "%ALLUSERSPROFILE%\Wallpapers\" /e > nul
if "%IS_VIRTUAL_MACHINE%"=="true" (
	cmd /c %~d0\Utils\wallpaper.cmd "%ALLUSERSPROFILE%\Wallpapers\default-vm.bmp" > nul
) else (
	cmd /c %~d0\Utils\wallpaper.cmd "%ALLUSERSPROFILE%\Wallpapers\default-host.bmp" > nul
)

:: CD-ROM drive letters
copy %~d0\Utils\drives.cmd %TEMP% > nul
%TEMP:~0,2%
cd %TEMP%
cmd /c drives.cmd > nul
del drives.cmd
%~d0
cd %~dp0

:: Shared Folder
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa /v forceguest /t REG_DWORD /d 00000000 /f > nul
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa /v limitblankpassworduse /t REG_DWORD /d 00000000 /f > nul
net share public=%DESTINATION_DRIVE%:\public
cacls %DESTINATION_DRIVE%:\public /e /g Everyone:C

:: ===========================================================================================================================================================================================

sc query state= all > c:\windows-services.log

:: ASP.NET State Service
sc config "aspnet_state" start= disabled
:: Alerter
sc config "Alerter" start= disabled
:: Application Experience Lookup Service
sc config "AeLookupSvc" start= disabled
:: Application Layer Gateway Service
sc config "ALG" start= disabled
:: Application Management
sc config "AppMgmt" start= disabled
:: Automatic Updates
sc config "wuauserv" start= disabled
:: Background Intelligent Transfer Service
sc config "BITS" start= disabled
:: ClipBook
sc config "ClipSrv" start= disabled
:: Distributed Link Tracking Client
sc config "TrkWks" start= disabled
:: Error Reporting Service
sc config "ERSvc" start= disabled
:: Human Interface Device Access
sc config "HidServ" start= disabled
:: IAS Jet Database Access
sc config "IASJet" start= disabled
:: IMAPI CD-Burning COM Service
sc config "ImapiService" start= disabled
:: IPSEC services
sc config "PolicyAgent" start= disabled
:: Java Quick Starter
sc config "JavaQuickStarterService" start= disabled
:: Logical Disk Manager
sc config "dmserver" start= demand
:: Logical Disk Manager Administrative
sc config "dmadmin" start= demand
:: Messenger
sc config "Messenger" start= disabled
:: Microsoft Software Shadow Copy Provider
sc config "swprv" start= disabled
:: NT LM Security Support Provider
sc config "NtLmSsp" start= disabled
:: Net Logon
sc config "Netlogon" start= disabled
:: Network DDE
sc config "NetDDE" start= demand
:: Network DDE DSDM
sc config "NetDDEdsdm" start= demand
:: Performance Logs and Alerts
sc config "SysmonLog" start= disabled
:: Remote Desktop Help Session Manager
sc config "RDSessMgr" start= disabled
:: Remote Registry
sc config "RemoteRegistry" start= disabled
:: SSDP Discovery Service
sc config "SSDPSRV" start= disabled
:: Shell Hardware Detection
sc config "ShellHWDetection" start= disabled
:: System Restore Service
sc config "srservice" start= disabled
:: TCP/IP NetBIOS Helper
sc config "LmHosts" start= demand
:: TP AutoConnect Service
sc config "TPAutoConnSvc" start= disabled
:: Telephony
sc config "TapiSrv" start= disabled
:: Terminal Services
sc config "TermService" start= disabled
:: Uninterruptible Power Supply
sc config "UPS" start= disabled
:: Universal Plug and Play Device Host
sc config "upnphost" start= disabled
:: Volume Shadow Copy
sc config "VSS" start= disabled
:: WebClient
sc config "WebClient" start= disabled
:: WinHTTP Web Proxy Auto-Discovery Service
sc config "WinHttpAutoProxySvc" start= disabled
:: Windows Time
sc config "W32Time" start= disabled

:: .NET Runtime Optimization
if "%INSTALL_DOTNET_FRAMEWORK20%"=="true" sc config "clr_optimization_v2.0.50727_32" start= disabled
if "%INSTALL_DOTNET_FRAMEWORK20%"=="true" sc config "clr_optimization_v2.0.50727_64" start= disabled
:: Google Updater Service
if "%INSTALL_CHROME%"=="true" sc config "gusvc" start= disabled

:: VisualSVN Server
if "%INSTALL_VISUALSVN%"=="true" sc config "VisualSVNServer" start= demand
:: Apache HTTP Server
if "%INSTALL_APACHE_HTTP_SERVER%"=="true" sc config "Apache2.2" start= demand
:: VMware Server
if not "%IS_DESKTOP_COMPUTER%"=="true" goto DO_NOT_TURN_OFF_VMWARE_SERVER_SERVICES
if "%INSTALL_VMWARE_SERVER%"=="true" sc config "VMAuthdService" start= demand
if "%INSTALL_VMWARE_SERVER%"=="true" sc config "VMnetDHCP" start= demand
if "%INSTALL_VMWARE_SERVER%"=="true" sc config "VMware NAT Service" start= demand
if "%INSTALL_VMWARE_SERVER%"=="true" sc config "VMwareHostd" start= demand
if "%INSTALL_VMWARE_SERVER%"=="true" sc config "VMwareServerWebAccess" start= demand
if "%INSTALL_VMWARE_SERVER%"=="true" sc config "vmwriter" start= demand
:DO_NOT_TURN_OFF_VMWARE_SERVER_SERVICES
:: MySQL
if "%INSTALL_MYSQL%"=="true" sc config "MySQL" start= demand
:: Oracle
if "%INSTALL_ORACLE%"=="true" sc config "OracleJobSchedulerXE" start= demand
if "%INSTALL_ORACLE%"=="true" sc config "OracleMTSRecoveryService" start= demand
if "%INSTALL_ORACLE%"=="true" sc config "OracleServiceXE" start= demand
if "%INSTALL_ORACLE%"=="true" sc config "OracleXEClrAgent" start= demand
if "%INSTALL_ORACLE%"=="true" sc config "OracleXETNSListener" start= demand

:: ===========================================================================================================================================================================================

del %TEMP%\*.* /f /s /q
del c:\WINDOWS\*.PIF /f /q
del c:\WINDOWS\*.tmp /f /q
del %DESTINATION_DRIVE%:\*.bmp /f /q
del %DESTINATION_DRIVE%:\*.cab /f /q
del %DESTINATION_DRIVE%:\*.dll /f /q
del %DESTINATION_DRIVE%:\*.exe /f /q
del %DESTINATION_DRIVE%:\*.ini /f /q
del %DESTINATION_DRIVE%:\*.msi /f /q
del %DESTINATION_DRIVE%:\*.txt /f /q

rmdir "%USERPROFILE%\Favorites" /s /q && mkdir "%USERPROFILE%\Favorites"
rmdir "%USERPROFILE%\My Documents" /s /q && mkdir "%USERPROFILE%\My Documents"
rmdir "%USERPROFILE%\SendTo" /s /q && mkdir "%USERPROFILE%\SendTo"
xcopy "%USERPROFILE%\Start Menu\Programs" "%ALLUSERSPROFILE%\Start Menu\Programs" /e > nul
rmdir "%USERPROFILE%\Start Menu\Programs" /s /q && mkdir "%USERPROFILE%\Start Menu\Programs"

rem TODO set up limited user's environment
rem http://technet.microsoft.com/en-us/library/bb457090.aspx
rem http://www.microsoft.com/downloads/details.aspx?familyid=799AB28C-691B-4B36-B7AD-6C604BE4C595&displaylang=en

call :cleanup
call :defragment

@echo off
echo.
echo *** Installation ended at %TIME%

shutdown /r /f /t 0
goto:eof

:: ===========================================================================================================================================================================================

:: USAGE: call :setOption option
:setOption
	if "%1"=="--pass-1" goto:eof
	if "%1"=="--pass-2" goto:eof
	if "%1"=="--pass-3" goto:eof
	if "%1"=="--pass-4" goto:eof
	set ARGUMENTS=%ARGUMENTS% %1
	@goto:eof

:: USAGE: call :processExplorer
:processExplorer
	echo Starting Process Explorer > con
	start "" "%WINTOOLS_DIR%\procexp.exe" /accepteula
	@goto:eof

:: USAGE: call :installFirefoxPlugin url [-O fileName]
:installFirefoxPlugin
	"%WINTOOLS_DIR%\gnu\bin\wget" --directory-prefix=%TEMP% --no-check-certificate %*
	@goto:eof

:: USAGE: call :downloadFirefoxPlugin url [-O fileName]
:downloadFirefoxPlugin
	"%WINTOOLS_DIR%\gnu\bin\wget" --directory-prefix="%DOWNLOADS_DIR%\firefox-plugins" --no-check-certificate %*
	@goto:eof

:: USAGE: call :installThunderbirdPlugin url [-O fileName]
:installThunderbirdPlugin
	"%WINTOOLS_DIR%\gnu\bin\wget" --directory-prefix="c:\Program Files (x86)\Mozilla Thunderbird\extensions" --no-check-certificate %*
	@goto:eof

:: USAGE: call :defragment
:defragment
	echo Defragmenting Files > con
	"c:\Program Files\Defraggler\df64.exe" C:
	@goto:eof

:: USAGE: call :cleanup
:cleanup
	echo Cleaning Up > con
	"c:\Program Files (x86)\CCleaner\CCleaner.exe" /AUTO
	@goto:eof
