::@echo off

:: turn off UAC

:: install.cmd -vm >> c:\install.log 2>&1

:: install Adobe Reader
:: install Chrome extensions http://code.google.com/chrome/extensions/external_extensions.html
::      Xmarks Bookmark Sync - https://chrome.google.com/webstore/detail/ajpgkpeckebdhofmmjfgcjjiiejpodla
::      Chrome Flags - https://chrome.google.com/webstore/detail/jhejngphiacapbgllhagbpdkkdieeaej
::      ScriptNo - https://chrome.google.com/webstore/detail/oiigbmnaadbkfbmpbfijlflahbdbdgdf
::      Web Developer - https://chrome.google.com/webstore/detail/bfbameneiokkgbdmiekhjnmfkcnldhhm
::      Firebug Lite - https://chrome.google.com/webstore/detail/bmagokdooijbeehmkpknfglimnifench
::      Forget Me - https://chrome.google.com/webstore/detail/gekpdemielcmiiiackmeoppdgaggjgda
::      Edit This Cookie - https://chrome.google.com/webstore/detail/fngmhnnpilhplaeedifhccceomclgfbg
:: install Eclipse plugins http://help.eclipse.org/indigo/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fmisc%2Fupdate_standalone.html
::      http://www.jgit.org/updates
::      http://m2eclipse.sonatype.org/sites/archives/
::      http://eclipse-color-theme.github.com/update
:: install DAEMON Tools Lite
:: install VistaSwitcher
:: FileZilla client
:: set CD/DVD drive letter to Z:
:: create CD/DVD virtual drives X: and Y:
:: install Visual Studio Express
:: install Wireshark
:: install tor-browser
:: set hostname
:: customise taskbar
:: show all notification icons
:: turn off system restore
:: disable remote assistance
:: turn off autoplay
:: customise action center (hide notifications)
:: add Polish keyboard
:: customize cmd.exe
:: increase mouse pointer speed
:: config process explorer
:: check autoruns
:: run ccleaner on startup
:: install updates

echo.
echo Installation script
echo.

:: =====================================================================================================================

::
:: set installation flags (group)
::

set INSTALL_BASE=true
set INSTALL_TOOLS=true
set INSTALL_UPDATES=true
set INSTALL_APPLICATIONS=true
set INSTALL_VCS_TOOLS=true
set INSTALL_DEVELOPMENT_TOOLS=true
set INSTALL_DATABASES=true
set INSTALL_SERVER_TOOLS=true
set INSTALL_GRAPHIC_TOOLS=true
set INSTALL_BROWSERS=true
set INSTALL_UTILS=true

:: =====================================================================================================================

::
:: set installation flags (package)
::

:: --- base
set INSTALL_COREUTILS=true
set INSTALL_SEVENZIP=true

:: --- tools
set INSTALL_PROCESSEXPLORER=true
set INSTALL_AUTORUNS=true
set INSTALL_SYSINTERNALSSUITE=true
set INSTALL_AUTOIT=true
set INSTALL_SCSI_PASS_THROUGH_DIRECT=true

:: --- updates
set INSTALL_MICROSOFT_VISUAL_CPP_REDISTRIBUTABLE_PACKAGE=true
set INSTALL_DOT_NET_FRAMEWORK_4=true

:: --- applications
set INSTALL_TOTAL_COMMANDER=true
set INSTALL_NOTEPADPP=true
set INSTALL_ADOBE_READER=false
set INSTALL_TRUECRYPT=true

:: --- vcs tools
set INSTALL_COLLABNET_SUBVERSION_CLIENT=true
set INSTALL_TORTOISESVN=true
set INSTALL_GIT=true
set INSTALL_TORTOISEGIT=true

:: --- development tools
set INSTALL_APACHE_HTTPD_SERVER=true
set INSTALL_PHP=true
set INSTALL_JDK5=true
set INSTALL_JDK6=true
set INSTALL_JDK7=true
set INSTALL_TOMCAT5=true
set INSTALL_TOMCAT6=true
set INSTALL_TOMCAT7=true
set CREATE_JAVA_LINKS=true
set INSTALL_ANT=true
set INSTALL_MAVEN=true
set INSTALL_ECLIPSE=true
set INSTALL_PERL=true
set INSTALL_PYTHON=true
set INSTALL_RUBY_ON_RAILS=true
set INSTALL_NODEJS=true

:: --- databases
set INSTALL_MYSQL=true
set INSTALL_MYSQL_WORKBENCH=true

:: --- server tools
set INSTALL_PUTTY=true
set INSTALL_WINSCP=true

:: --- graphic tools
set INSTALL_IMAGEMAGICK=true
set INSTALL_GIMP=true

:: --- browsers
set INSTALL_FIREFOX=false
set INSTALL_CHROME=false

:: --- utils
set INSTALL_DEFRAGGLER=true
set INSTALL_CCLEANER=true

:: =====================================================================================================================

::
:: process parameters
::

set OPTIONS=
for %%A in (%*) do (

    :: long
    if "%%A"=="--virtual-machine" set IS_VIRTUAL_MACHINE=true
    if "%%A"=="--desktop-computer" set IS_DESKTOP_COMPUTER=true

    :: short
    if "%%A"=="-vm" set IS_VIRTUAL_MACHINE=true
    if "%%A"=="-dc" set IS_DESKTOP_COMPUTER=true

    call :setOption %%A
)

if "%OPTIONS%"=="" goto:eof

:: =====================================================================================================================

::
:: set variables
::

if "%IS_VIRTUAL_MACHINE%"=="true" (
    set DESTINATION_DRIVE=c
) else (
    set DESTINATION_DRIVE=d
)

set DOWNLOADS_DIR=%DESTINATION_DRIVE%:\downloads
set PROJECTS_DIR=%DESTINATION_DRIVE%:\projects
set PUBLIC_DIR=%DESTINATION_DRIVE%:\public
set TEMP_DIR=%DESTINATION_DRIVE%:\temp
set TOOLS_DIR=%DESTINATION_DRIVE%:\tools
set VIRTUAL_MACHINES_DIR=%DESTINATION_DRIVE%:\virtual machines

:: =====================================================================================================================

::
:: set software versions
::

:: --- base
set SEVENZIP_VER=920-x64

:: --- tools
set SCSI_PASS_THROUGH_DIRECT_VER=179-x64

:: --- updates

:: --- applications
set TCMD_VER=756a
set NOTEPADPP_VER=5.9.8
set TRUECRYPT_VER=7.1

:: --- vcs tools
set SVN_VER=1.7.2-1-x64
set TORTOISESVN_VER=1.7.3.22386-x64-svn-1.7.2
set GIT_VER=1.7.8-preview20111206
set TORTOISEGIT_VER=1.7.6.0-64bit

:: --- development tools
set HTTPD_VER=2.2.21
set PHP_VER=5.3.8
set JDK5_UPD=22
set JDK6_UPD=30
set JDK7_UPD=2
set TOMCAT5_VER=5.5.34
set TOMCAT6_VER=6.0.35
set TOMCAT7_VER=7.0.23
set ANT_VER=1.8.2
set MAVEN_VER=3.0.3
set ECLIPSE_VER=indigo-SR1-win32
set PERL_VER=5.14.2.1402-MSWin32-x64-295342
set PYTHON_VER=3.2.2.amd64
set RUBY_VER=1.9.3-p0
set NODEJS_VER=0.6.6

:: --- databases
set MYSQL_VER=5.5.19-winx64
set MYSQL_WORKBENCH_VER=5.2.37

:: --- server tools
set PUTTY_VER=0.62
set WINSCP_VER=505

:: --- graphic tools
set IMAGEMAGICK_VER=6.7.4-Q16
set GIMP_VER=2.6.11-i686

:: --- browsers
set FIREFOX_VER=9.0.1

:: --- utils
set DEFRAGGLER_VER=208
set CCLEANER_VER=314

:: =====================================================================================================================

::
:: define commands
::

set CP=%TOOLS_DIR%\gnuwin\bin\cp
set MV=%TOOLS_DIR%\gnuwin\bin\mv
set RM=%TOOLS_DIR%\gnuwin\bin\rm
set SED=%TOOLS_DIR%\gnuwin\bin\sed
set GAWK=%TOOLS_DIR%\gnuwin\bin\gawk
set EGREP=%TOOLS_DIR%\gnuwin\bin\egrep
set WGET=%TOOLS_DIR%\gnuwin\bin\wget
set SEVENZIP="c:\Program Files\7-Zip\7z"
set AUTOIT="c:\Program Files\AutoIt\AutoIt3"
set GIT="c:\Program Files (x86)\Git\bin\git"

:: =====================================================================================================================

::
:: create directory structure
::

if not exist %DOWNLOADS_DIR% mkdir %DOWNLOADS_DIR%
if not exist %PROJECTS_DIR% mkdir %PROJECTS_DIR%
if not exist %PUBLIC_DIR% mkdir %PUBLIC_DIR%
if not exist %TEMP_DIR% mkdir %TEMP_DIR%
if not exist %TOOLS_DIR% mkdir %TOOLS_DIR%

:: =====================================================================================================================

::
:: run installation process
::

::
:: ------- base ------------------------
::

:: GnuWin
if not "%INSTALL_BASE%"=="true" goto DO_NOT_INSTALL_WIN_GNU
if not "%INSTALL_COREUTILS%"=="true" goto DO_NOT_INSTALL_WIN_GNU
    echo Installing CoreUtils > con
    coreutils-5.3.0.exe /dir="%TOOLS_DIR%\gnuwin" /verysilent /norestart
    echo Installing Grep > con
    grep-2.5.4-setup.exe /dir="%TOOLS_DIR%\gnuwin" /verysilent /norestart
    echo Installing Sed > con
    sed-4.2.1-setup.exe /dir="%TOOLS_DIR%\gnuwin" /verysilent /norestart
    echo Installing Gawk > con
    gawk-3.1.6-1-setup.exe /dir="%TOOLS_DIR%\gnuwin" /verysilent /norestart
    echo Installing Wget > con
    wget-1.11.4-1-setup.exe /dir="%TOOLS_DIR%\gnuwin" /verysilent /norestart
:DO_NOT_INSTALL_WIN_GNU

:: 7-Zip
if not "%INSTALL_BASE%"=="true" goto DO_NOT_INSTALL_SEVENZIP
if not "%INSTALL_SEVENZIP%"=="true" goto DO_NOT_INSTALL_SEVENZIP
    echo Installing 7-Zip > con
    msiexec /i 7z%SEVENZIP_VER%.msi /passive /norestart
:DO_NOT_INSTALL_SEVENZIP

::
:: ------- tools -----------------------
::

:: ProcessExplorer
if not "%INSTALL_TOOLS%"=="true" goto DO_NOT_INSTALL_PROCESSEXPLORER
if not "%INSTALL_PROCESSEXPLORER%"=="true" goto DO_NOT_INSTALL_PROCESSEXPLORER
    echo Installing ProcessExplorer > con
    if not exist "c:\Program Files\ProcessExplorer" %SEVENZIP% x ProcessExplorer.zip -o"c:\Program Files\ProcessExplorer" > nul
    call :processExplorer
:DO_NOT_INSTALL_PROCESSEXPLORER

:: Autorun
if not "%INSTALL_TOOLS%"=="true" goto DO_NOT_INSTALL_AUTORUNS
if not "%INSTALL_AUTORUNS%"=="true" goto DO_NOT_INSTALL_AUTORUNS
    echo Installing Autoruns > con
    if exist "c:\Program Files\Autoruns" rmdir /s /q "c:\Program Files\Autoruns"
    %SEVENZIP% x Autoruns.zip -o"c:\Program Files\Autoruns" > nul
    start "" "c:\Program Files\Autoruns\autoruns.exe" /accepteula && timeout /t 2 > nul
    taskkill /IM autoruns.exe /T /F > nul
:DO_NOT_INSTALL_AUTORUNS

:: SysinternalsSuite
if not "%INSTALL_TOOLS%"=="true" goto DO_NOT_INSTALL_SYSINTERNALSSUITE
if not "%INSTALL_SYSINTERNALSSUITE%"=="true" goto DO_NOT_INSTALL_SYSINTERNALSSUITE
    echo Installing SysinternalsSuite > con
    if exist "c:\Program Files\SysinternalsSuite" rmdir /s /q "c:\Program Files\SysinternalsSuite"
    %SEVENZIP% x SysinternalsSuite.zip -o"c:\Program Files\SysinternalsSuite" > nul
:DO_NOT_INSTALL_SYSINTERNALSSUITE

:: AutoIt
if not "%INSTALL_TOOLS%"=="true" goto DO_NOT_INSTALL_AUTOIT
if not "%INSTALL_AUTOIT%"=="true" goto DO_NOT_INSTALL_AUTOIT
    echo Installing AutoIt > con
    %SEVENZIP% x -sfx autoit-v3-sfx.exe -o%TEMP_DIR%\AutoIt > nul
    rename %TEMP_DIR%\AutoIt\install AutoIt
    xcopy %TEMP_DIR%\AutoIt\AutoIt "c:\Program Files\AutoIt\" /e > nul
    rmdir %TEMP_DIR%\AutoIt /s /q
:DO_NOT_INSTALL_AUTOIT

:: SCSI Pass Through Direct
if not "%INSTALL_TOOLS%"=="true" goto DO_NOT_INSTALL_SCSI_PASS_THROUGH_DIRECT
if not "%INSTALL_SCSI_PASS_THROUGH_DIRECT%"=="true" goto DO_NOT_INSTALL_SCSI_PASS_THROUGH_DIRECT
    echo Installing SCSI Pass Through Direct > con
    SPTDinst-v%SCSI_PASS_THROUGH_DIRECT_VER%.exe add /q
:DO_NOT_INSTALL_SCSI_PASS_THROUGH_DIRECT

::
:: ------- updates ---------------------
::

:: Microsoft Visual C++ Redistributable Package
if not "%INSTALL_UPDATES%"=="true" goto DO_NOT_INSTALL_MICROSOFT_VISUAL_CPP_REDISTRIBUTABLE_PACKAGE
if not "%INSTALL_MICROSOFT_VISUAL_CPP_REDISTRIBUTABLE_PACKAGE%"=="true" goto DO_NOT_INSTALL_MICROSOFT_VISUAL_CPP_REDISTRIBUTABLE_PACKAGE
    echo Installing Microsoft Visual C++ Redistributable Package > con
    vcredist_x86.exe /Q
    vcredist_x64.exe /Q
:DO_NOT_INSTALL_MICROSOFT_VISUAL_CPP_REDISTRIBUTABLE_PACKAGE

:: .NET Framework 4
if not "%INSTALL_UPDATES%"=="true" goto DO_NOT_INSTALL_DOT_NET_FRAMEWORK_4
if not "%INSTALL_DOT_NET_FRAMEWORK_4%"=="true" goto DO_NOT_INSTALL_DOT_NET_FRAMEWORK_4
    echo Installing .NET Framework 4 > con
    dotNetFx40_Full_x86_x64.exe /q /norestart > nul
:DO_NOT_INSTALL_DOT_NET_FRAMEWORK_4

::
:: ------- applications ----------------
::

:: Total Commander
if not "%INSTALL_APPLICATIONS%"=="true" goto DO_NOT_INSTALL_TOTAL_COMMANDER
if not "%INSTALL_TOTAL_COMMANDER%"=="true" goto DO_NOT_INSTALL_TOTAL_COMMANDER
    echo Installing Total Commander > con
    %SEVENZIP% x -tzip tcmd%TCMD_VER%.exe -o%TEMP_DIR%\tc > nul
    %SED% -e "s/auto=0/auto=1/g" -e "s/alllang=1/alllang=0/g" -e "s/Dir=c:\\totalcmd/Dir=c:\\Program Files (x86)\\totalcmd/g" %TEMP_DIR%\tc\INSTALL.INF > %TEMP_DIR%\tc\INSTALL.INF.tmp
    del %TEMP_DIR%\tc\INSTALL.INF
    rename %TEMP_DIR%\tc\INSTALL.INF.tmp INSTALL.INF
    %TEMP_DIR%\tc\INSTALL.EXE
    rmdir %TEMP_DIR%\tc /s /q
    copy config\TotalCommander.ini "%USERPROFILE%\Application Data\GHISLER\" > nul
    del "%USERPROFILE%\Application Data\GHISLER\wincmd.ini"
    rename "%USERPROFILE%\Application Data\GHISLER\TotalCommander.ini" wincmd.ini
:DO_NOT_INSTALL_TOTAL_COMMANDER

:: Notepad++
if not "%INSTALL_APPLICATIONS%"=="true" goto DO_NOT_INSTALL_NOTEPADPP
if not "%INSTALL_NOTEPADPP%"=="true" goto DO_NOT_INSTALL_NOTEPADPP
    echo Installing Notepad++ > con
    if exist "c:\Program Files (x86)\Notepad++" rmdir /s /q "c:\Program Files (x86)\Notepad++"
    %SEVENZIP% x npp.%NOTEPADPP_VER%.bin.zip -o"c:\Program Files (x86)\Notepad++" > nul
    xcopy /s /r /y config\notepad++\ansi "c:\Program Files (x86)\Notepad++\ansi" > nul
    xcopy /s /r /y config\notepad++\unicode "c:\Program Files (x86)\Notepad++\unicode" > nul
:DO_NOT_INSTALL_NOTEPADPP

:: Adobe Reader
if not "%INSTALL_APPLICATIONS%"=="true" goto DO_NOT_INSTALL_ADOBE_READER
if not "%INSTALL_ADOBE_READER%"=="true" goto DO_NOT_INSTALL_ADOBE_READER
    echo Installing Adobe Reader > con
    %CP% install_reader10_uk_air_mssd_aih.exe %TEMP_DIR%
    :: TODO: fix the problem ...
    %TEMP_DIR%\install_reader10_uk_air_mssd_aih.exe /sAll /rs /msi EULA_ACCEPT=YES
:DO_NOT_INSTALL_ADOBE_READER

:: TrueCrypt
if not "%INSTALL_APPLICATIONS%"=="true" goto DO_NOT_INSTALL_TRUECRYPT
if not "%INSTALL_TRUECRYPT%"=="true" goto DO_NOT_INSTALL_TRUECRYPT
    echo Installing TrueCrypt > con
    :: TODO: fix the problem ...
    start "" /wait %AUTOIT% autoit\truecrypt.au3 %TRUECRYPT_VER% > nul
:DO_NOT_INSTALL_TRUECRYPT

::
:: ------- vcs tools -------------------
::

:: Collabnet Subversion Client
if not "%INSTALL_VCS_TOOLS%"=="true" goto DO_NOT_INSTALL_COLLABNET_SUBVERSION_CLIENT
if not "%INSTALL_COLLABNET_SUBVERSION_CLIENT%"=="true" goto DO_NOT_INSTALL_COLLABNET_SUBVERSION_CLIENT
    echo Installing Collabnet Subversion Client > con
    CollabNetSubversion-client-%SVN_VER%.exe /S /NCRC
:DO_NOT_INSTALL_COLLABNET_SUBVERSION_CLIENT

:: TortoiseSVN
if not "%INSTALL_VCS_TOOLS%"=="true" goto DO_NOT_INSTALL_TORTOISESVN
if not "%INSTALL_TORTOISESVN%"=="true" goto DO_NOT_INSTALL_TORTOISESVN
    echo Installing TortoiseSVN > con
    msiexec /i TortoiseSVN-%TORTOISESVN_VER%.msi /passive /norestart
:DO_NOT_INSTALL_TORTOISESVN

:: Git
if not "%INSTALL_VCS_TOOLS%"=="true" goto DO_NOT_INSTALL_GIT
if not "%INSTALL_GIT%"=="true" goto DO_NOT_INSTALL_GIT
    echo Installing Git > con
    start /wait Git-%GIT_VER%.exe /Silent /NoRestart
    copy /y scripts\config-git.cmd %TOOLS_DIR% > nul
:DO_NOT_INSTALL_GIT

:: TortoiseGit
if not "%INSTALL_VCS_TOOLS%"=="true" goto DO_NOT_INSTALL_TORTOISEGIT
if not "%INSTALL_TORTOISEGIT%"=="true" goto DO_NOT_INSTALL_TORTOISEGIT
    echo Installing TortoiseGit > con
    msiexec /i TortoiseGit-%TORTOISEGIT_VER%.msi /passive /norestart
:DO_NOT_INSTALL_TORTOISEGIT

::
:: ------- development tools -----------
::

:: Apache HTTPD Server
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_APACHE_HTTPD_SERVER
if not "%INSTALL_APACHE_HTTPD_SERVER%"=="true" goto DO_NOT_INSTALL_APACHE_HTTPD_SERVER
    echo Installing Apache HTTPD Server > con
    tasklist /fi "imagename eq httpd.exe" 2> nul | find /i /n "httpd.exe" > nul
    if "%ERRORLEVEL%"=="0" taskkill /im httpd.exe /f > nul
    tasklist /fi "imagename eq ApacheMonitor.exe" 2> nul | find /i /n "ApacheMonitor.exe" > nul
    if "%ERRORLEVEL%"=="0" taskkill /im ApacheMonitor.exe /f > nul
    if exist "%TOOLS_DIR%\httpd" rmdir /s /q "%TOOLS_DIR%\httpd"
    msiexec /a httpd-%HTTPD_VER%-win32-x86-openssl-0.9.8r.msi /qb TARGETDIR=%TEMP_DIR%\httpd
    :: TODO: accept firewall changes
    xcopy "%TEMP_DIR%\httpd\program files\Apache Software Foundation\Apache2.2" "%TOOLS_DIR%\httpd\" /e > nul
    rmdir %TEMP_DIR%\httpd /s /q
    mkdir "%TOOLS_DIR%\httpd\conf\extra"
    mkdir "%TOOLS_DIR%\httpd\logs"
    %SED% "s/ServerSslPort = \" serverport/ServerSSLPort = \" serversslport/g" "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk" > "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk.tmp"
    del "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk"
    rename "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk.tmp" installwinconf.awk
    %GAWK% -f "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk" localhost localhost admin@localhost 80 443 %TOOLS_DIR%\httpd conf/original/
    "%TOOLS_DIR%\httpd\bin\httpd" -k install > nul 2>&1
    %SED% ^
        -e "s/#ServerName localhost:80/ServerName localhost:80/g" ^
        -e "s/#LoadModule rewrite_module/LoadModule rewrite_module/g" ^
        -e "s/AllowOverride None/AllowOverride All/g" ^
        -e "s/DirectoryIndex index.html/DirectoryIndex index.html index.php/g" ^
        "%TOOLS_DIR%\httpd\conf\httpd.conf" > "%TOOLS_DIR%\httpd\conf\httpd.conf.tmp"
    del "%TOOLS_DIR%\httpd\conf\httpd.conf"
    rename "%TOOLS_DIR%\httpd\conf\httpd.conf.tmp" httpd.conf
:DO_NOT_INSTALL_APACHE_HTTPD_SERVER

:: PHP
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_PHP
if not "%INSTALL_PHP%"=="true" goto DO_NOT_INSTALL_PHP
    echo Installing PHP > con
    if exist "%TOOLS_DIR%\php" rmdir /s /q "%TOOLS_DIR%\php"
    %SEVENZIP% x php-%PHP_VER%-Win32-VC9-x86.zip -o"%TOOLS_DIR%\php" > nul
    set TMP_TOOLS_DIR=%TOOLS_DIR:\=/%
    echo. >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
    echo # *** BEGIN PHP Settings *** >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
    echo LoadModule php5_module "%TMP_TOOLS_DIR%/php/php5apache2_2.dll" >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
    echo AddType application/x-httpd-php .php >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
    echo PHPIniDir "%TMP_TOOLS_DIR%/php" >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
    echo # *** END PHP Settings *** >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
    set TMP_TOOLS_DIR=%TOOLS_DIR:\=\\%
    %SED% ^
        -e "s/;include_path = \".;c:\\php\\includes\"/include_path = \".\"/g" ^
        -e "s/; extension_dir = \"ext\"/extension_dir = \"%TMP_TOOLS_DIR%\\php\\ext\\\"/g" ^
        -e "s/;extension=php_mbstring.dll/extension=php_mbstring.dll/g" ^
        -e "s/;extension=php_mysql.dll/extension=php_mysql.dll/g" ^
        -e "s/;extension=php_mysqli.dll/extension=php_mysqli.dll/g" ^
        -e "s/;extension=php_openssl.dll/extension=php_openssl.dll/g" ^
        -e "s/;extension=php_pdo_mysql.dll/extension=php_pdo_mysql.dll/g" ^
        "%TOOLS_DIR%\php\php.ini-development" > "%TOOLS_DIR%\php\php.ini"
:DO_NOT_INSTALL_PHP

:: Java 5 JDK
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_JDK5
if not "%INSTALL_JDK5%"=="true" goto DO_NOT_INSTALL_JDK5
    echo Installing Java 5 JDK > con
    wmic product where name="J2SE Development Kit 5.0 Update %JDK5_UPD%" call uninstall
    if exist "%TOOLS_DIR%\jdk5" rmdir /s /q "%TOOLS_DIR%\jdk5"
    mkdir "%TOOLS_DIR%\jdk5"
    jdk-1_5_0_%JDK5_UPD%-windows-i586-p.exe /s /v"/qn INSTALLDIR=%TOOLS_DIR%\jdk5 ADDLOCAL=ALL IEXPLORER=0 MOZILLA=0 REBOOT=ReallySuppress JAVAUPDATE=0\""
:DO_NOT_INSTALL_JDK5

:: Java 6 JDK
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_JDK6
if not "%INSTALL_JDK6%"=="true" goto DO_NOT_INSTALL_JDK6
    echo Installing Java 6 JDK > con
    wmic product where name="Java(TM) 6 Update %JDK6_UPD%" call uninstall
    wmic product where name="Java(TM) SE Development Kit 6 Update %JDK6_UPD%" call uninstall
    if exist "%TOOLS_DIR%\jdk6" rmdir /s /q "%TOOLS_DIR%\jdk6"
    mkdir "%TOOLS_DIR%\jdk6"
    jdk-6u%JDK6_UPD%-windows-i586.exe /s /v\"/qn INSTALLDIR=%TOOLS_DIR%\jdk6 ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 REBOOT=ReallySuppress JAVAUPDATE=1\""
:DO_NOT_INSTALL_JDK6

:: Java 7 JDK
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_JDK7
if not "%INSTALL_JDK7%"=="true" goto DO_NOT_INSTALL_JDK7
    echo Installing Java 7 JDK > con
    wmic product where name="Java(TM) 7 Update %JDK7_UPD%" call uninstall
    wmic product where name="Java(TM) SE Development Kit 7 Update %JDK7_UPD%" call uninstall
    if exist "%TOOLS_DIR%\jdk7" rmdir /s /q "%TOOLS_DIR%\jdk7"
    mkdir "%TOOLS_DIR%\jdk7"
    jdk-7u%JDK7_UPD%-windows-i586.exe /s /v\"/qn INSTALLDIR=%TOOLS_DIR%\jdk7 ADDLOCAL=ALL IEXPLORER=0 MOZILLA=0 REBOOT=ReallySuppress JAVAUPDATE=0\""
    :: uninstall Java Auto Updater
    wmic product where name="Java Auto Updater" call uninstall > nul
    wmic product get name,version | %EGREP% -i "j2se|java"
:DO_NOT_INSTALL_JDK7

:: Apache Tomcat 5
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_TOMCAT5
if not "%INSTALL_TOMCAT5%"=="true" goto DO_NOT_INSTALL_TOMCAT5
    echo Installing Apache Tomcat 5 > con
    if exist "%TOOLS_DIR%\tomcat5" rmdir /s /q "%TOOLS_DIR%\tomcat5"
    %SEVENZIP% x apache-tomcat-%TOMCAT5_VER%.zip -o"%TOOLS_DIR%" > nul
    rename "%TOOLS_DIR%\apache-tomcat-%TOMCAT5_VER%" tomcat5
:DO_NOT_INSTALL_TOMCAT5

:: Apache Tomcat 6
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_TOMCAT6
if not "%INSTALL_TOMCAT6%"=="true" goto DO_NOT_INSTALL_TOMCAT6
    echo Installing Apache Tomcat 6 > con
    if exist "%TOOLS_DIR%\tomcat6" rmdir /s /q "%TOOLS_DIR%\tomcat6"
    %SEVENZIP% x apache-tomcat-%TOMCAT6_VER%.zip -o"%TOOLS_DIR%" > nul
    rename "%TOOLS_DIR%\apache-tomcat-%TOMCAT6_VER%" tomcat6
:DO_NOT_INSTALL_TOMCAT6

:: Apache Tomcat 7
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_TOMCAT7
if not "%INSTALL_TOMCAT7%"=="true" goto DO_NOT_INSTALL_TOMCAT7
    echo Installing Apache Tomcat 7 > con
    if exist "%TOOLS_DIR%\tomcat7" rmdir /s /q "%TOOLS_DIR%\tomcat7"
    %SEVENZIP% x apache-tomcat-%TOMCAT7_VER%.zip -o"%TOOLS_DIR%" > nul
    rename "%TOOLS_DIR%\apache-tomcat-%TOMCAT7_VER%" tomcat7
    if not exist "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml.bak" %CP% "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml" "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml.bak"
    %SED% ^
        -e "s/<tomcat-users>/<tomcat-users>\n<user username=\"admin\" password=\"admin\" roles=\"manager-gui,admin-gui\"\/>/g" ^
        "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml" > "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml.new"
    %MV% "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml.new" "%TOOLS_DIR%\tomcat7\conf\tomcat-users.xml"
:DO_NOT_INSTALL_TOMCAT7

:: create links
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_CREATE_JAVA_LINKS
if not "%CREATE_JAVA_LINKS%"=="true" goto DO_NOT_CREATE_JAVA_LINKS
    if exist "%TOOLS_DIR%\jdk" rmdir "%TOOLS_DIR%\jdk"
    if exist "%TOOLS_DIR%\jdk7" mklink /d %TOOLS_DIR%\jdk %TOOLS_DIR%\jdk7 > nul
    if exist "%TOOLS_DIR%\jre" rmdir "%TOOLS_DIR%\jre"
    if exist "%TOOLS_DIR%\jdk\jre" mklink /d %TOOLS_DIR%\jre %TOOLS_DIR%\jdk\jre > nul
    if exist "%TOOLS_DIR%\tomcat" rmdir "%TOOLS_DIR%\tomcat"
    if exist "%TOOLS_DIR%\tomcat7" mklink /d %TOOLS_DIR%\tomcat %TOOLS_DIR%\tomcat7 > nul
    copy /y scripts\set-java-env.cmd %TOOLS_DIR% > nul
:DO_NOT_CREATE_JAVA_LINKS

:: Apache Ant
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_ANT
if not "%INSTALL_ANT%"=="true" goto DO_NOT_INSTALL_ANT
    echo Installing Apache Ant > con
    if exist "%TOOLS_DIR%\ant" rmdir /s /q "%TOOLS_DIR%\ant"
    %SEVENZIP% x apache-ant-%ANT_VER%-bin.zip -o"%TOOLS_DIR%" > nul
    rename "%TOOLS_DIR%\apache-ant-%ANT_VER%" ant
:DO_NOT_INSTALL_ANT

:: Apache Maven
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_MAVEN
if not "%INSTALL_MAVEN%"=="true" goto DO_NOT_INSTALL_MAVEN
    echo Installing Apache Maven > con
    if exist "%TOOLS_DIR%\maven" rmdir /s /q "%TOOLS_DIR%\maven"
    %SEVENZIP% x apache-maven-%MAVEN_VER%-bin.zip -o"%TOOLS_DIR%" > nul
    rename "%TOOLS_DIR%\apache-maven-%MAVEN_VER%" maven
:DO_NOT_INSTALL_MAVEN

:: Eclipse
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_ECLIPSE
if not "%INSTALL_ECLIPSE%"=="true" goto DO_NOT_INSTALL_ECLIPSE
    echo Installing Eclipse > con
    if exist "%TOOLS_DIR%\eclipse" rmdir "%TOOLS_DIR%\eclipse" /s /q
    %SEVENZIP% x eclipse-jee-%ECLIPSE_VER%.zip -o"%TOOLS_DIR%" -aoa > nul
:DO_NOT_INSTALL_ECLIPSE

:: Perl
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_PERL
if not "%INSTALL_PERL%"=="true" goto DO_NOT_INSTALL_PERL
    echo Installing Perl > con
    start /wait msiexec /i ActivePerl-%PERL_VER%.msi /q TARGETDIR="c:\Program Files" PERL_PATH="No" PERL_EXT="Yes"
    if exist "%TOOLS_DIR%\perl" rmdir "%TOOLS_DIR%\perl"
    mklink /d %TOOLS_DIR%\perl "c:\Program Files\Perl64" > nul
:DO_NOT_INSTALL_PERL

:: Python
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_PYTHON
if not "%INSTALL_PYTHON%"=="true" goto DO_NOT_INSTALL_PYTHON
    echo Installing Python > con
    start /wait msiexec /i python-%PYTHON_VER%.msi /qn TARGETDIR="%TOOLS_DIR%\python" ALLUSERS=1
:DO_NOT_INSTALL_PYTHON

:: Ruby on Rails
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_RUBY_ON_RAILS
if not "%INSTALL_RUBY_ON_RAILS%"=="true" goto DO_NOT_INSTALL_RUBY_ON_RAILS
    echo Installing Ruby on Rails > con
    rubyinstaller-%RUBY_VER%.exe /silent /dir="%TOOLS_DIR%\ruby" /tasks="addtk,assocfiles"
:DO_NOT_INSTALL_RUBY_ON_RAILS

:: Node.js
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_INSTALL_NODEJS
if not "%INSTALL_NODEJS%"=="true" goto DO_NOT_INSTALL_NODEJS
    echo Installing Node.js > con
    msiexec /qb /i node-v%NODEJS_VER%.msi
    if not exist "%PROJECTS_DIR%\node-builds" %GIT% clone https://github.com/ajaxorg/node-builds %PROJECTS_DIR%\node-builds > nul
:DO_NOT_INSTALL_NODEJS

::
:: ------- databases --------------------
::

:: MySQL Community Server
if not "%INSTALL_DATABASES%"=="true" goto DO_NOT_INSTALL_MYSQL
if not "%INSTALL_MYSQL%"=="true" goto DO_NOT_INSTALL_MYSQL
    echo Installing MySQL Community Server > con
    if exist "%TOOLS_DIR%\mysql" rmdir /s /q "%TOOLS_DIR%\mysql"
    %SEVENZIP% x mysql-%MYSQL_VER%.zip -o"%TOOLS_DIR%" > nul
    rename "%TOOLS_DIR%\mysql-%MYSQL_VER%" mysql
    copy "%TOOLS_DIR%\mysql\my-small.ini" "%TOOLS_DIR%\mysql\my.ini" > nul
    "%TOOLS_DIR%\mysql\bin\mysqld" --install MySQL --defaults-file="%TOOLS_DIR%\mysql\my.ini" > nul
    echo net %%1 MySQL > "%TOOLS_DIR%\mysql\server.cmd"
:DO_NOT_INSTALL_MYSQL

:: MySQL Workbench
if not "%INSTALL_DATABASES%"=="true" goto DO_NOT_INSTALL_MYSQL_WORKBENCH
if not "%INSTALL_MYSQL_WORKBENCH%"=="true" goto DO_NOT_INSTALL_MYSQL_WORKBENCH
    echo Installing MySQL Workbench > con
    if exist "c:\Program Files (x86)\MySQL Workbench" rmdir /s /q "c:\Program Files (x86)\MySQL Workbench"
    %SEVENZIP% x mysql-workbench-gpl-%MYSQL_WORKBENCH_VER%-win32-noinstall.zip -o"c:\Program Files (x86)" > nul
    rename "c:\Program Files (x86)\MySQL Workbench %MYSQL_WORKBENCH_VER% CE" "MySQL Workbench"
:DO_NOT_INSTALL_MYSQL_WORKBENCH

::
:: ------- server tools ---------------
::

:: PuTTY
if not "%INSTALL_SERVER_TOOLS%"=="true" goto DO_NOT_INSTALL_PUTTY
if not "%INSTALL_PUTTY%"=="true" goto DO_NOT_INSTALL_PUTTY
    echo Installing PuTTY > con
    putty-%PUTTY_VER%-installer.exe /sp- /silent
:DO_NOT_INSTALL_PUTTY

:: WinSCP
if not "%INSTALL_SERVER_TOOLS%"=="true" goto DO_NOT_INSTALL_WINSCP
if not "%INSTALL_WINSCP%"=="true" goto DO_NOT_INSTALL_WINSCP
    echo Installing WinSCP > con
    winscp%WINSCP_VER%setup.exe /verysilent /norestart /nocandy
:DO_NOT_INSTALL_WINSCP

::
:: ------- graphic tools ---------------
::

:: ImageMagick
if not "%INSTALL_GRAPHIC_TOOLS%"=="true" goto DO_NOT_INSTALL_IMAGEMAGICK
if not "%INSTALL_IMAGEMAGICK%"=="true" goto DO_NOT_INSTALL_IMAGEMAGICK
    echo Installing ImageMagick > con
    if exist %TOOLS_DIR%\imagemagick rmdir /s /q %TOOLS_DIR%\imagemagick
    %SEVENZIP% x ImageMagick-%IMAGEMAGICK_VER%-windows.zip -o%TOOLS_DIR% > nul
    for /f %%a in ('dir /b %TOOLS_DIR%\ImageMagick-*') do (
        %MV% %TOOLS_DIR%\%%a %TOOLS_DIR%\imagemagick
    )
:DO_NOT_INSTALL_IMAGEMAGICK

:: GIMP
if not "%INSTALL_GRAPHIC_TOOLS%"=="true" goto DO_NOT_INSTALL_GIMP
if not "%INSTALL_GIMP%"=="true" goto DO_NOT_INSTALL_GIMP
    echo Installing GIMP > con
    gimp-%GIMP_VER%-setup-1.exe /Silent /SP- /NoRestart
:DO_NOT_INSTALL_GIMP

::
:: ------- browsers --------------------
::

:: Firefox
if not "%INSTALL_BROWSERS%"=="true" goto DO_NOT_INSTALL_FIREFOX
if not "%INSTALL_FIREFOX%"=="true" goto DO_NOT_INSTALL_FIREFOX
    echo Installing Firefox > con
    "Firefox Setup %FIREFOX_VER%.exe" /S /V"/Passive /NoRestart"
    "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" -silent -CreateProfile default > nul
    "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" -silent -setDefaultBrowser
    :: Firebug
    call :download https://addons.mozilla.org/en-US/firefox/downloads/latest/1843/addon-1843-latest.xpi %TEMP_DIR%\firebug.xpi
    :: Firecookie
    call :download https://addons.mozilla.org/en-US/firefox/downloads/latest/6683/addon-6683-latest.xpi %TEMP_DIR%\firecookie.xpi
    :: FirePHP
    call :download https://addons.mozilla.org/firefox/downloads/file/129877/firephp-0.6.2-fx.xpi %TEMP_DIR%\firephp.xpi
    :: Web Developer
    call :download https://addons.mozilla.org/en-US/firefox/downloads/latest/60/addon-60-latest.xpi %TEMP_DIR%\web_developer.xpi
    :: Xmarks
    call :download https://addons.mozilla.org/en-US/firefox/downloads/latest/2410/addon-2410-latest.xpi %TEMP_DIR%\xmarks.xpi
    :: Installing Firefox Plugins
    echo Installing Firefox Plugins > con
    for /f %%a in ('dir /b %TEMP_DIR%\*.xpi') do (
        start "" "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" %TEMP_DIR%\%%a
        %AUTOIT% /AutoIt3ExecuteLine "WinWait('Software Installation')"
        %AUTOIT% /AutoIt3ExecuteLine "WinActivate('Software Installation')"
        timeout /t 3 > nul
        %AUTOIT% /AutoIt3ExecuteLine "Send('{TAB}{TAB}{TAB}{ENTER}')"
        timeout /t 2 > nul
        taskkill /IM firefox.exe /T /F
        timeout /t 5 > nul
    )
:DO_NOT_INSTALL_FIREFOX

:: Google Chrome
if not "%INSTALL_BROWSERS%"=="true" goto DO_NOT_INSTALL_CHROME
if not "%INSTALL_CHROME%"=="true" goto DO_NOT_INSTALL_CHROME
    echo Installing Google Chrome > con
    start "" /wait %AUTOIT% autoit\chrome.au3 > nul
:DO_NOT_INSTALL_CHROME

::
:: ------- utils -----------------------
::

:: Defraggler
if not "%INSTALL_UTILS%"=="true" goto DO_NOT_INSTALL_DEFRAGGLER
if not "%INSTALL_DEFRAGGLER%"=="true" goto DO_NOT_INSTALL_DEFRAGGLER
    echo Installing Defraggler > con
    dfsetup%DEFRAGGLER_VER%.exe /S
    copy /y config\defraggler.ini "c:\Program Files\Defraggler\" > nul
:DO_NOT_INSTALL_DEFRAGGLER

:: CCleaner
if not "%INSTALL_UTILS%"=="true" goto DO_NOT_INSTALL_CCLEANER
if not "%INSTALL_CCLEANER%"=="true" goto DO_NOT_INSTALL_CCLEANER
    echo Installing CCleaner > con
    ccsetup%CCLEANER_VER%.exe /S
    copy /y config\ccleaner.ini "c:\Program Files\CCleaner\" > nul
:DO_NOT_INSTALL_CCLEANER

:: =====================================================================================================================

::
:: create shortcuts
::

:: remove all desktop shortcuts
del "c:\Users\Public\Desktop\*.lnk"
del "%USERPROFILE%\Desktop\*.lnk"

:: tools
if not "%INSTALL_TOOLS%"=="true" goto DO_NOT_CREATE_TOOLS_SHORTCUTS
    if exist "%ALLUSERSPROFILE%\Start Menu\Programs\Tools" rmdir /s /q "%ALLUSERSPROFILE%\Start Menu\Programs\Tools"
    mkdir "%ALLUSERSPROFILE%\Start Menu\Programs\Tools"
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\ProcessExplorer.lnk" /t:"c:\Program Files\ProcessExplorer\procexp.exe" /w:"c:\Program Files\ProcessExplorer" /p:"/e" /r:1
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Autoruns.lnk" /t:"c:\Program Files\Autoruns\autoruns.exe" /w:"c:\Program Files\Autoruns" /p:"-e" /r:1
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\TCPView.lnk" /t:"c:\Program Files\SysinternalsSuite\Tcpview.exe" /w:"c:\Program Files\SysinternalsSuite" /p:"-e" /r:1
:DO_NOT_CREATE_TOOLS_SHORTCUTS

:: Notepad++
if not "%INSTALL_APPLICATIONS%"=="true" goto DO_NOT_CREATE_NOTEPADPP_SHORTCUTS
if not "%INSTALL_NOTEPADPP%"=="true" goto DO_NOT_CREATE_NOTEPADPP_SHORTCUTS
    if exist "%ALLUSERSPROFILE%\Start Menu\Programs\Notepad++" rmdir /s /q "%ALLUSERSPROFILE%\Start Menu\Programs\Notepad++"
    mkdir "%ALLUSERSPROFILE%\Start Menu\Programs\Notepad++"
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Notepad++ ANSI.lnk" /t:"c:\Program Files (x86)\Notepad++\ansi\notepad++.exe" /w:"c:\Program Files (x86)\Notepad++\ansi\" /r:1
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Notepad++ Unicode.lnk" /t:"c:\Program Files (x86)\Notepad++\unicode\notepad++.exe" /w:"c:\Program Files (x86)\Notepad++\unicode\" /r:1
:DO_NOT_CREATE_NOTEPADPP_SHORTCUTS

:: Apache HTTPD Server
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_CREATE_APACHE_HTTPD_SERVER_SHORTCUTS
if not "%INSTALL_APACHE_HTTPD_SERVER%"=="true" goto DO_NOT_CREATE_APACHE_HTTPD_SERVER_SHORTCUTS
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Apache HTTPD Start.lnk" /t:"%TOOLS_DIR%\httpd\bin\httpd.exe" /w:"%TOOLS_DIR%\httpd\bin\" /p:"-k start" /r:1
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Apache HTTPD Stop.lnk" /t:"%TOOLS_DIR%\httpd\bin\httpd.exe" /w:"%TOOLS_DIR%\httpd\bin\" /p:"-k stop" /r:1
:DO_NOT_CREATE_APACHE_HTTPD_SERVER_SHORTCUTS

:: Tomcat
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_CREATE_TOMCAT_SHORTCUTS
if not "%CREATE_JAVA_LINKS%"=="true" goto DO_NOT_CREATE_TOMCAT_SHORTCUTS
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Tomcat Start.lnk" /t:"%TOOLS_DIR%\tomcat\bin\startup.bat" /w:"%TOOLS_DIR%\tomcat\bin\" /i:"%TOOLS_DIR%\tomcat5\bin\tomcat5.exe" /r:1
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Tomcat Stop.lnk" /t:"%TOOLS_DIR%\tomcat\bin\shutdown.bat" /w:"%TOOLS_DIR%\tomcat\bin\" /i:"%TOOLS_DIR%\tomcat5\bin\tomcat5.exe" /r:1
:DO_NOT_CREATE_TOMCAT_SHORTCUTS

:: Eclipse
if not "%INSTALL_DEVELOPMENT_TOOLS%"=="true" goto DO_NOT_CREATE_ECLIPSE_SHORTCUTS
if not "%INSTALL_ECLIPSE%"=="true" goto DO_NOT_CREATE_ECLIPSE_SHORTCUTS
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\Eclipse.lnk" /t:"%TOOLS_DIR%\eclipse\eclipse.exe"
:DO_NOT_CREATE_ECLIPSE_SHORTCUTS

:: MySQL
if not "%INSTALL_DATABASES%"=="true" goto DO_NOT_CREATE_MYSQL_SHORTCUTS
if not "%INSTALL_MYSQL%"=="true" goto DO_NOT_CREATE_MYSQL_SHORTCUTS
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\MySQL Start.lnk" /t:"%TOOLS_DIR%\mysql\server.cmd" /p:"start"
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\MySQL Stop.lnk" /t:"%TOOLS_DIR%\mysql\server.cmd" /p:"stop"
:DO_NOT_CREATE_MYSQL_SHORTCUTS

:: MySQL Workbench
if not "%INSTALL_DATABASES%"=="true" goto DO_NOT_CREATE_MYSQL_WORKBENCH_SHORTCUTS
if not "%INSTALL_MYSQL%"=="true" goto DO_NOT_CREATE_MYSQL_WORKBENCH_SHORTCUTS
    cscript //nologo utils\shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tools\MySQL Workbench.lnk" /t:"c:\Program Files (x86)\MySQL Workbench\MySQLWorkbench.exe"
:DO_NOT_CREATE_MYSQL_WORKBENCH_SHORTCUTS

:: =====================================================================================================================

::
:: set pagefile
::

wmic.exe pagefileset create Name='c:\pagefile.sys' > nul
if "%IS_VIRTUAL_MACHINE%"=="true" (
	wmic pagefileset set Name='c:\pagefile.sys',InitialSize=2048,MaximumSize=2048 > nul
) else (
	wmic pagefileset set Name='c:\pagefile.sys',InitialSize=0,MaximumSize=0 > nul
)

:: =====================================================================================================================

::
:: update registry keys
::

reg add HKEY_CURRENT_USER\Environment /v JAVA_HOME /t REG_SZ /d "%TOOLS_DIR%\jdk" /f > nul
reg add HKEY_CURRENT_USER\Environment /v JRE_HOME /t REG_SZ /d "%TOOLS_DIR%\jdk\jre" /f > nul
reg add HKEY_CURRENT_USER\Environment /v CATALINA_HOME /t REG_SZ /d "%TOOLS_DIR%\tomcat" /f > nul
reg add HKEY_CURRENT_USER\Environment /v ANT_HOME /t REG_SZ /d "%TOOLS_DIR%\ant" /f > nul
reg add HKEY_CURRENT_USER\Environment /v M2_HOME /t REG_SZ /d "%TOOLS_DIR%\maven" /f > nul
reg add HKEY_CURRENT_USER\Environment /v IMAGEMAGICK_HOME /t REG_SZ /d "%TOOLS_DIR%\imagemagick" /f > nul

set NEW_PATH="%TOOLS_DIR%;%%JAVA_HOME%%\bin;%%CATALINA_HOME%%\bin;%%ANT_HOME%%\bin;%%M2_HOME%%\bin;%TOOLS_DIR%\gnuwin\bin;c:\Program Files (x86)\PuTTY;c:\Program Files (x86)\Git\cmd;c:\Program Files (x86)\Git\bin;c:\Program iles\TortoiseGit\bin;c:\Program Files\CollabNet\Subversion Client;c:\Program Files\TortoiseSVN\bin;%TOOLS_DIR%\perl\bin;%TOOLS_DIR%\python\bin;%TOOLS_DIR%\ruby\bin;%PROJECTS_DIR%\node-builds\win32;c:\Program Files\SysinternalsSuite"
reg add HKEY_CURRENT_USER\Environment /v PATH /t REG_EXPAND_SZ /d %NEW_PATH% /f > nul
reg add HKEY_CURRENT_USER\Environment /v SVN_SSH /t REG_EXPAND_SZ /d "c:\Program Files (x86)\PuTTY\plink.exe" /f > nul
reg add HKEY_CURRENT_USER\Environment /v GIT_SSH /t REG_EXPAND_SZ /d "c:\Program Files (x86)\PuTTY\plink.exe" /f > nul

:: =====================================================================================================================

::
:: set autorun programs
::

reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v "ProcessExplorer" /t REG_SZ /d "\"c:\Program Files\ProcessExplorer\procexp.exe\" /e /t" /f > nul

:: =====================================================================================================================

::
:: set avatar
::

copy /y resources\avatar.bmp "%ALLUSERSPROFILE%\Application Data\Microsoft\User Account Pictures\%USERNAME%.bmp" > nul
copy /y resources\avatar.bmp "%ALLUSERSPROFILE%\Application Data\Microsoft\User Account Pictures\user.bmp" > nul

:: =====================================================================================================================

::
:: set wallpaper
::

if not exist "%ALLUSERSPROFILE%\Wallpapers" mkdir "%ALLUSERSPROFILE%\Wallpapers"
copy /y resources\wallpaper.bmp "%ALLUSERSPROFILE%\Wallpapers" > nul
cmd /c utils\wallpaper.cmd "%ALLUSERSPROFILE%\Wallpapers\wallpaper.bmp" > nul

:: =====================================================================================================================

::
:: remove wat
::

if exist "c:\Program Files\RemoveWAT" goto DO_NOT_INSTALL_WINDOWS_7_ACTIVATION
    %SEVENZIP% x windows_7_activation_hack.zip -o"c:\Program Files\RemoveWAT" > nul
    "c:\Program Files\RemoveWAT\RemoveWAT.exe" /s
:DO_NOT_INSTALL_WINDOWS_7_ACTIVATION

:: =====================================================================================================================

goto:eof

:: USAGE: call :setOption option
:setOption
    set OPTIONS=%OPTIONS% %1
    @goto:eof

:: USAGE: call :processExplorer
:processExplorer
    echo Starting Process Explorer > con
    start "" "c:\Program Files\ProcessExplorer\procexp.exe" /accepteula
    @goto:eof

:: USAGE: call :download url fileName
:download
    if exist %TEMP_DIR%\%2 goto:eof
    echo Downloading %1 > con
    %WGET% --directory-prefix=%TEMP_DIR% --no-check-certificate %1 -O %2 > nul
    @goto:eof
