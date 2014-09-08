@echo off
cls
echo Customized and Automated Windows XP Installation

if "%1"=="--setup" goto SETUP
if "%1"=="--run-once" goto RUNONCE

timeout /t 60
echo.
call :INSTALL %~f0 %*
goto:eof

:: ===========================================================================================================================================================================================

:SETUP
echo.
choice /C YN /N /M "Is it a virtual machine? [Y/N]: "

if ERRORLEVEL 2 set VM=--desktop-computer
if ERRORLEVEL 1 set VM=--virtual-machine

echo What is your installation type?
echo.
echo  1) Minimum
echo  2) Full
echo  3) Custom
echo  4) Predefined: Host
echo  5) Predefined: Web Development
echo  6) Predefined: Windows Development
echo  7) Predefined: Databases
echo  8) Predefined: Networking
echo.
choice /C 12345678 /N /M "Make a choice [1-8]: "
echo.

if ERRORLEVEL 8 goto PREDEFINED_PACKAGES_NETWORKING
if ERRORLEVEL 7 goto PREDEFINED_PACKAGES_DATABASES
if ERRORLEVEL 6 goto PREDEFINED_PACKAGES_WIN_DEV
if ERRORLEVEL 5 goto PREDEFINED_PACKAGES_WEB_DEV
if ERRORLEVEL 4 goto PREDEFINED_PACKAGES_HOME
if ERRORLEVEL 3 set TYPE=--custom-installation
if ERRORLEVEL 2 set TYPE=--full-installation
if ERRORLEVEL 1 set TYPE=--minimum-installation

:CUSTOMIZATION
set PACKAGES=
if not "%TYPE%"=="--minimum-installation" call :CONFIGURATION
if "%TYPE%"=="--custom-installation" echo.

call :INSTALL %~f0 --pass-1 %VM% %TYPE% %PACKAGES% --os-install
goto:eof

:PREDEFINED_PACKAGES_HOME
set PACKAGES=--windows-installer --windows-update-agent --microsoft-vcpp-redistributable-package --dotnet-framework20 --directx --java-jre --tooltipfixer --unlocker --scsi-pass-through-direct --partition-wizard --total-commander --notepadpp --cdburnerxp --imgburn --nlite --adobe-reader --openoffice --irfanview --google-picasa --videolan-player --codecs --aimp2 --graphcalc --keepass --truecrypt --dropbox --collabnet-subversion-client --tortoisesvn --internet-explorer --firefox --thunderbird --flash-player --shockwave --silverlight --free-download-manager --emule --utorrent --skype --osbuild --daemon-tools-lite --vmware-server --cpu-z --gpu-z --eset-smart-security --predefined-home
goto PREDEFINED_INSTALL

:PREDEFINED_PACKAGES_WEB_DEV
set PACKAGES=--windows-installer --windows-update-agent --microsoft-vcpp-redistributable-package --dotnet-framework20 --dotnet-framework35 --java-jre --tooltipfixer --unlocker --scsi-pass-through-direct --total-commander --notepadpp --hashtab --adobe-reader --graphcalc --dropbox --putty --winscp --collabnet-subversion-client --tortoisesvn --visualsvn --git --gimp --java-jdk --eclipse --junit --ant --maven --java-libraries --apache-tomcat --apache-http-server --netbeans --php --phing --zend-framework --dojo-toolkit --jquery --web-debbuging-tools --oxygen-xml-editor --mysql-workbench --internet-explorer --opera --safari --chrome --firefox --firefox-plugins --free-download-manager --daemon-tools-lite --mysql --predefined-web-dev
goto PREDEFINED_INSTALL

:PREDEFINED_PACKAGES_WIN_DEV
set PACKAGES=--windows-installer --windows-update-agent --microsoft-vcpp-redistributable-package --microsoft-core-xml-services --dotnet-framework20 --dotnet-framework35 --windows-powershell --java-jre --tooltipfixer --unlocker --scsi-pass-through-direct --total-commander --notepadpp --hashtab --adobe-reader --graphcalc --dropbox --winscp --collabnet-subversion-client --tortoisesvn --visualsvn --git --firefox --free-download-manager --daemon-tools-lite --visual-studio --kernel-mode-tools --predefined-win-dev
goto PREDEFINED_INSTALL

:PREDEFINED_PACKAGES_DATABASES
set PACKAGES=--windows-installer --windows-update-agent --microsoft-vcpp-redistributable-package --microsoft-core-xml-services --dotnet-framework20 --dotnet-framework35 --java-jre --tooltipfixer --unlocker --scsi-pass-through-direct --total-commander --notepadpp --hashtab --adobe-reader --graphcalc --java-jdk --mysql-workbench --microsoft-sql-server-management-studio --oracle-sql-developer --firefox --daemon-tools-lite --mysql --mssql --oracle --predefined-databases
goto PREDEFINED_INSTALL

:PREDEFINED_PACKAGES_NETWORKING
set PACKAGES=--windows-installer --windows-update-agent --microsoft-vcpp-redistributable-package --dotnet-framework20 --java-jre --tooltipfixer --unlocker --scsi-pass-through-direct --total-commander --notepadpp --hashtab --adobe-reader --graphcalc --perl --python --wireshark --firefox --free-download-manager --daemon-tools-lite --predefined-networking
goto PREDEFINED_INSTALL

:PREDEFINED_INSTALL
call :INSTALL %~f0 --pass-1 %VM% --custom-installation %PACKAGES% --os-install
goto:eof

:INSTALL
call %~d0\AddOns\install.cmd %* >> c:\install.log 2>&1
goto:eof

:RUNONCE
echo.
echo Your machine has to be rebooted.
timeout /t 30
set COMMAND=%2
echo @%COMMAND:"=% > %TEMP%\start.cmd
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Runonce /v command0 /d "%TEMP%\start.cmd" > nul
shutdown /r /f /t 0
goto:eof

:: ===========================================================================================================================================================================================

:CONFIGURATION
call :ADD_PACKAGE --windows-installer
call :ADD_PACKAGE --windows-update-agent
call :ADD_PACKAGE --microsoft-vcpp-redistributable-package
call :ADD_PACKAGE --microsoft-core-xml-services
call :ADD_PACKAGE --dotnet-framework20
call :ADD_PACKAGE --dotnet-framework35
call :ADD_PACKAGE --windows-powershell
call :ADD_PACKAGE --directx
call :ADD_PACKAGE --java-jre
call :ADD_PACKAGE --tooltipfixer
call :ADD_PACKAGE --unlocker
call :ADD_PACKAGE --scsi-pass-through-direct
call :ADD_PACKAGE --partition-wizard
call :ADD_PACKAGE --total-commander
call :ADD_PACKAGE --notepadpp
if "%VM%"=="--desktop-computer" call :ADD_PACKAGE --cdburnerxp
if "%VM%"=="--desktop-computer" call :ADD_PACKAGE --imgburn
call :ADD_PACKAGE --nlite
call :ADD_PACKAGE --hashtab
call :ADD_PACKAGE --adobe-reader
call :ADD_PACKAGE --openoffice
call :ADD_PACKAGE --irfanview
call :ADD_PACKAGE --google-picasa
call :ADD_PACKAGE --videolan-player
call :ADD_PACKAGE --codecs
call :ADD_PACKAGE --aimp2
call :ADD_PACKAGE --graphcalc
call :ADD_PACKAGE --keepass
call :ADD_PACKAGE --truecrypt
call :ADD_PACKAGE --dropbox
call :ADD_PACKAGE --perl
call :ADD_PACKAGE --python
call :ADD_PACKAGE --putty
call :ADD_PACKAGE --winscp
call :ADD_PACKAGE --collabnet-subversion-client
call :ADD_PACKAGE --tortoisesvn
call :ADD_PACKAGE --visualsvn
call :ADD_PACKAGE --git
call :ADD_PACKAGE --gimp
call :ADD_PACKAGE --blender
call :ADD_PACKAGE --java-jdk
call :ADD_PACKAGE --eclipse
call :ADD_PACKAGE --junit
call :ADD_PACKAGE --ant
call :ADD_PACKAGE --maven
call :ADD_PACKAGE --java-libraries
call :ADD_PACKAGE --apache-tomcat
call :ADD_PACKAGE --apache-http-server
call :ADD_PACKAGE --netbeans
call :ADD_PACKAGE --php
call :ADD_PACKAGE --phing
call :ADD_PACKAGE --zend-framework
call :ADD_PACKAGE --dojo-toolkit
call :ADD_PACKAGE --jquery
call :ADD_PACKAGE --web-debbuging-tools
call :ADD_PACKAGE --oxygen-xml-editor
call :ADD_PACKAGE --wireshark
call :ADD_PACKAGE --mysql-workbench
call :ADD_PACKAGE --microsoft-sql-server-management-studio
call :ADD_PACKAGE --oracle-sql-developer
call :ADD_PACKAGE --internet-explorer
call :ADD_PACKAGE --opera
call :ADD_PACKAGE --safari
call :ADD_PACKAGE --chrome
call :ADD_PACKAGE --firefox
call :ADD_PACKAGE --firefox-plugins
call :ADD_PACKAGE --thunderbird
call :ADD_PACKAGE --flash-player
call :ADD_PACKAGE --shockwave
call :ADD_PACKAGE --silverlight
call :ADD_PACKAGE --free-download-manager
call :ADD_PACKAGE --emule
call :ADD_PACKAGE --utorrent
call :ADD_PACKAGE --skype
call :ADD_PACKAGE --osbuild
call :ADD_PACKAGE --daemon-tools-lite
call :ADD_PACKAGE --visual-studio
call :ADD_PACKAGE --kernel-mode-tools
if "%VM%"=="--desktop-computer" call :ADD_PACKAGE --vmware-server
call :ADD_PACKAGE --mysql
call :ADD_PACKAGE --mssql
call :ADD_PACKAGE --oracle
if "%VM%"=="--desktop-computer" call :ADD_PACKAGE --cpu-z
if "%VM%"=="--desktop-computer" call :ADD_PACKAGE --gpu-z
call :ADD_PACKAGE --eset-smart-security
goto:eof

:ADD_PACKAGE
set PACKAGE=%1
if "%TYPE%"=="--full-installation" goto YES
if "%TYPE%"=="--custom-installation" goto CHOICE
goto:eof

:CHOICE
set NAME=%PACKAGE:--=%
set NAME=%NAME:-= %
choice /C YN /N /M "%NAME% [Y/N]: "
if ERRORLEVEL 2 goto NO
if ERRORLEVEL 1 goto YES
goto:eof

:NO
goto:eof

:YES
set PACKAGES=%PACKAGES% %PACKAGE%
goto:eof
