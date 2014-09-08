@echo off

:: Installation script for Windows 7 x64

:: USAGE: install.cmd --putty --winscp --svn --git --jdk --ant --maven --tomcat --httpd --php --mysql --mysql-workbench --eclipse --netbeans --gimp --vim > install.log 2>&1

:: initialise parameters
set INSTALL_PUTTY=false
set INSTALL_WINSCP=false
set INSTALL_SVN=false
set INSTALL_GIT=false
set INSTALL_JDK=false
set INSTALL_ANT=false
set INSTALL_MAVEN=false
set INSTALL_TOMCAT=false
set INSTALL_HTTPD=false
set INSTALL_PHP=false
set INSTALL_MYSQL=false
set INSTALL_MYSQL_WORKBENCH=false
set INSTALL_ECLIPSE=false
set INSTALL_NETBEANS=false
set INSTALL_GIMP=false
set INSTALL_VIM=false

:: process parameters
for %%A in (%*) do (
	if "%%A"=="--putty" set INSTALL_PUTTY=true
	if "%%A"=="--winscp" set INSTALL_WINSCP=true
	if "%%A"=="--svn" set INSTALL_SVN=true
	if "%%A"=="--git" set INSTALL_GIT=true
	if "%%A"=="--jdk" set INSTALL_JDK=true
	if "%%A"=="--ant" set INSTALL_ANT=true
	if "%%A"=="--maven" set INSTALL_MAVEN=true
	if "%%A"=="--tomcat" set INSTALL_TOMCAT=true
	if "%%A"=="--httpd" set INSTALL_HTTPD=true
	if "%%A"=="--php" set INSTALL_PHP=true
	if "%%A"=="--mysql" set INSTALL_MYSQL=true
	if "%%A"=="--mysql-workbench" set INSTALL_MYSQL_WORKBENCH=true
	if "%%A"=="--eclipse" set INSTALL_ECLIPSE=true
	if "%%A"=="--netbeans" set INSTALL_NETBEANS=true
	if "%%A"=="--gimp" set INSTALL_GIMP=true
	if "%%A"=="--vim" set INSTALL_VIM=true
)

:: =====================================================================================================================

echo *** Installation started at %TIME%, invoked command "%~f0 %*"

set DESTINATION_DRIVE=d
set DOWNLOADS_DIR=%DESTINATION_DRIVE%:\downloads
set PROJECTS_DIR=%DESTINATION_DRIVE%:\projects
set TEMP_DIR=%DESTINATION_DRIVE%:\temp
set TOOLS_DIR=%DESTINATION_DRIVE%:\tools
set VIRTUAL_MACHINES_DIR=%DESTINATION_DRIVE%:\virtual machines

if not exist "%DOWNLOADS_DIR%" mkdir "%DOWNLOADS_DIR%"
if not exist "%PROJECTS_DIR%" mkdir "%PROJECTS_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"
if not exist "%VIRTUAL_MACHINES_DIR%" mkdir "%VIRTUAL_MACHINES_DIR%"

:: change directory to script's directory
%~d0
cd %~dp0

echo on

:: =====================================================================================================================

:: PuTTY
if not "%INSTALL_PUTTY%"=="true" goto DO_NOT_INSTALL_PUTTY
echo Installing PuTTY > con
putty-0.60-installer.exe /sp- /silent
:DO_NOT_INSTALL_PUTTY

:: WinSCP
if not "%INSTALL_WINSCP%"=="true" goto DO_NOT_INSTALL_WINSCP
echo Installing WinSCP > con
winscp433setup.exe /verysilent /norestart /nocandy
:DO_NOT_INSTALL_WINSCP

:: Collabnet Subversion Client
if not "%INSTALL_SVN%"=="true" goto DO_NOT_INSTALL_SVN
echo Installing Collabnet Subversion Client > con
CollabNetSubversion-client-1.6.16-1.win32.exe /S /NCRC
:DO_NOT_INSTALL_SVN

:: TortoiseSVN
if not "%INSTALL_SVN%"=="true" goto DO_NOT_INSTALL_TORTOISESVN
echo Installing TortoiseSVN > con
msiexec /i TortoiseSVN-1.6.15.21042-win32-svn-1.6.16.msi /passive /norestart
msiexec /i TortoiseSVN-1.6.15.21042-x64-svn-1.6.16.msi /passive /norestart
:DO_NOT_INSTALL_TORTOISESVN

:: Git
if not "%INSTALL_GIT%"=="true" goto DO_NOT_INSTALL_GIT
echo Installing Git > con
start /wait Git-1.7.4-preview20110204.exe /Silent /NoRestart
:DO_NOT_INSTALL_GIT

:: TortoiseGit
if not "%INSTALL_GIT%"=="true" goto DO_NOT_INSTALL_TORTOISEGIT
echo Installing TortoiseGit > con
msiexec /i Tortoisegit-1.6.5.0-32bit.msi /passive /norestart
msiexec /i Tortoisegit-1.6.5.0-64bit.msi /passive /norestart
:DO_NOT_INSTALL_TORTOISEGIT

:: Java JDK
if not "%INSTALL_JDK%"=="true" goto DO_NOT_INSTALL_JDK
echo Installing Java JDK > con
if exist "%TOOLS_DIR%\jdk" rmdir /s /q "%TOOLS_DIR%\jdk"
mkdir "%TOOLS_DIR%\jdk"
jdk-7-ea-bin-b144-windows-i586-26_may_2011.exe /s /v\"/qn INSTALLDIR=%TOOLS_DIR%\jdk ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 REBOOT=ReallySuppress JAVAUPDATE=0\""
:DO_NOT_INSTALL_JDK

:: Apache Ant
if not "%INSTALL_ANT%"=="true" goto DO_NOT_INSTALL_ANT
echo Installing Apache Ant > con
if exist "%TOOLS_DIR%\ant" rmdir /s /q "%TOOLS_DIR%\ant"
"c:\Program Files\7-Zip\7z" x apache-ant-1.8.2-bin.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\apache-ant-1.8.2" ant
:DO_NOT_INSTALL_ANT

:: Apache Maven
if not "%INSTALL_MAVEN%"=="true" goto DO_NOT_INSTALL_MAVEN
echo Installing Apache Maven > con
if exist "%TOOLS_DIR%\maven" rmdir /s /q "%TOOLS_DIR%\maven"
"c:\Program Files\7-Zip\7z" x apache-maven-3.0.3-bin.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\apache-maven-3.0.3" maven
:DO_NOT_INSTALL_MAVEN

:: Apache Tomcat
if not "%INSTALL_TOMCAT%"=="true" goto DO_NOT_INSTALL_TOMCAT
echo Installing Apache Tomcat > con
if exist "%TOOLS_DIR%\tomcat" rmdir /s /q "%TOOLS_DIR%\tomcat"
"c:\Program Files\7-Zip\7z" x apache-tomcat-7.0.14-windows-x86.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\apache-tomcat-7.0.14" tomcat
sed "s/8005/8005/g" "%TOOLS_DIR%\tomcat\conf\server.xml" > "%TOOLS_DIR%\tomcat\conf\server.xml.tmp"
sed "s/8080/8080/g" "%TOOLS_DIR%\tomcat\conf\server.xml.tmp" > "%TOOLS_DIR%\tomcat\conf\server.xml"
sed "s/8443/8443/g" "%TOOLS_DIR%\tomcat\conf\server.xml" > "%TOOLS_DIR%\tomcat\conf\server.xml.tmp"
sed "s/8009/8009/g" "%TOOLS_DIR%\tomcat\conf\server.xml.tmp" > "%TOOLS_DIR%\tomcat\conf\server.xml"
del "%TOOLS_DIR%\tomcat\conf\server.xml.tmp"
:DO_NOT_INSTALL_TOMCAT

:: Apache HTTP Server
if not "%INSTALL_HTTPD%"=="true" goto DO_NOT_INSTALL_HTTPD
echo Installing Apache HTTP Server > con
if exist "%TOOLS_DIR%\httpd" rmdir /s /q "%TOOLS_DIR%\httpd"
msiexec /a httpd-2.2.19-win32-x86-openssl-0.9.8r.msi /qb TARGETDIR=%TEMP%\httpd
xcopy "%TEMP%\httpd\program files\Apache Software Foundation\Apache2.2" "%TOOLS_DIR%\httpd\" /e > nul
rmdir %TEMP%\httpd /s /q
mkdir "%TOOLS_DIR%\httpd\conf\extra"
mkdir "%TOOLS_DIR%\httpd\logs"
sed "s/ServerSslPort = \" serverport/ServerSSLPort = \" serversslport/g" "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk" > "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk.tmp"
del "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk"
rename "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk.tmp" installwinconf.awk
gawk -f "%TOOLS_DIR%\httpd\conf\original\installwinconf.awk" localhost localhost admin@localhost 80 443 %TOOLS_DIR%\httpd conf/original/
"%TOOLS_DIR%\httpd\bin\httpd" -k install > nul 2>&1
sed ^
	-e "s/#ServerName localhost:80/ServerName localhost:80/g" ^
	-e "s/#LoadModule rewrite_module/LoadModule rewrite_module/g" ^
	-e "s/AllowOverride None/AllowOverride All/g" ^
	-e "s/DirectoryIndex index.html/DirectoryIndex index.html index.php/g" ^
	"%TOOLS_DIR%\httpd\conf\httpd.conf" > "%TOOLS_DIR%\httpd\conf\httpd.conf.tmp"
del "%TOOLS_DIR%\httpd\conf\httpd.conf"
rename "%TOOLS_DIR%\httpd\conf\httpd.conf.tmp" httpd.conf
:DO_NOT_INSTALL_HTTPD

:: PHP
if not "%INSTALL_PHP%"=="true" goto DO_NOT_INSTALL_PHP
echo Installing PHP > con
if exist "%TOOLS_DIR%\php" rmdir /s /q "%TOOLS_DIR%\php"
"c:\Program Files\7-Zip\7z" x php-5.3.6-Win32-VC9-x86.zip -o"%TOOLS_DIR%\php" > nul
set TMP_TOOLS_DIR=%TOOLS_DIR:\=/%
echo. >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo # *** BEGIN PHP Settings *** >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo LoadModule php5_module "%TMP_TOOLS_DIR%/php/php5apache2_2.dll" >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo AddType application/x-httpd-php .php >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo PHPIniDir "%TMP_TOOLS_DIR%/php" >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
echo # *** END PHP Settings *** >> "%TOOLS_DIR%\httpd\conf\httpd.conf"
set TMP_TOOLS_DIR=%TOOLS_DIR:\=\\%
sed ^
	-e "s/;include_path = \".;c:\\php\\includes\"/include_path = \".\"/g" ^
	-e "s/; extension_dir = \"ext\"/extension_dir = \"%TMP_TOOLS_DIR%\\php\\ext\\\"/g" ^
	-e "s/;extension=php_mbstring.dll/extension=php_mbstring.dll/g" ^
	-e "s/;extension=php_mysql.dll/extension=php_mysql.dll/g" ^
	-e "s/;extension=php_mysqli.dll/extension=php_mysqli.dll/g" ^
	-e "s/;extension=php_openssl.dll/extension=php_openssl.dll/g" ^
	-e "s/;extension=php_pdo_mysql.dll/extension=php_pdo_mysql.dll/g" ^
	"%TOOLS_DIR%\php\php.ini-development" > "%TOOLS_DIR%\php\php.ini"
:DO_NOT_INSTALL_PHP

:: MySQL Community Server
if not "%INSTALL_MYSQL%"=="true" goto DO_NOT_INSTALL_MYSQL
echo Installing MySQL Community Server > con
if exist "%TOOLS_DIR%\mysql" rmdir /s /q "%TOOLS_DIR%\mysql"
"c:\Program Files\7-Zip\7z" x mysql-5.5.12-winx64.zip -o"%TOOLS_DIR%" > nul
rename "%TOOLS_DIR%\mysql-5.5.12-winx64" mysql
copy "%TOOLS_DIR%\mysql\my-small.ini" "%TOOLS_DIR%\mysql\my.ini" > nul
"%TOOLS_DIR%\mysql\bin\mysqld" --install MySQL --defaults-file="%TOOLS_DIR%\mysql\my.ini" > nul
echo net %%1 MySQL > "%TOOLS_DIR%\mysql\server.cmd"
:DO_NOT_INSTALL_MYSQL

:: MySQL Workbench
if not "%INSTALL_MYSQL_WORKBENCH%"=="true" goto DO_NOT_INSTALL_MYSQL_WORKBENCH
echo Installing MySQL Workbench > con
if exist "c:\Program Files (x86)\MySQL\MySQL Workbench" rmdir /s /q "c:\Program Files (x86)\MySQL\MySQL Workbench"
"c:\Program Files\7-Zip\7z" x mysql-workbench-gpl-5.2.34-win32-noinstall.zip -o"c:\Program Files (x86)\MySQL" > nul
rename "c:\Program Files (x86)\MySQL\MySQL Workbench 5.2.34 CE" "MySQL Workbench"
:DO_NOT_INSTALL_MYSQL_WORKBENCH

:: Eclipse
if not "%INSTALL_ECLIPSE%"=="true" goto DO_NOT_INSTALL_ECLIPSE
echo Installing Eclipse > con
if exist "%TOOLS_DIR%\eclipse" rmdir "%TOOLS_DIR%\eclipse" /s /q
"c:\Program Files\7-Zip\7z" x eclipse-jee-helios-SR2-win32.zip -o"%TOOLS_DIR%" -aoa > nul
:DO_NOT_INSTALL_ECLIPSE

:: NetBeans
if not "%INSTALL_NETBEANS%"=="true" goto DO_NOT_INSTALL_NETBEANS
echo Installing NetBeans > con
netbeans-7.0-ml-php-windows.exe --silent --state netbeans.xml > nul
:DO_NOT_INSTALL_NETBEANS

:: GIMP
if not "%INSTALL_GIMP%"=="true" goto DO_NOT_INSTALL_GIMP
echo Installing GIMP > con
gimp-2.6.11-i686-setup-1.exe /Silent /SP- /NoRestart
:DO_NOT_INSTALL_GIMP

:: Vim
if not "%INSTALL_VIM%"=="true" goto DO_NOT_INSTALL_VIM
echo Installing Vim > con
if exist "%TOOLS_DIR%\vim" rmdir "%TOOLS_DIR%\vim" /s /q
"c:\Program Files\7-Zip\7z" x vim73-x64.zip -o"%TOOLS_DIR%\vim"
"%TOOLS_DIR%\vim\vim73\install.exe" > con
:DO_NOT_INSTALL_VIM

:: =====================================================================================================================

if "%INSTALL_TOMCAT%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tomcat Start.lnk" /t:"%TOOLS_DIR%\tomcat\bin\startup.bat" /w:"%TOOLS_DIR%\tomcat\bin\" /i:"%TOOLS_DIR%\tomcat\bin\tomcat7.exe" /r:1
if "%INSTALL_TOMCAT%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Tomcat Stop.lnk" /t:"%TOOLS_DIR%\tomcat\bin\shutdown.bat" /w:"%TOOLS_DIR%\tomcat\bin\" /i:"%TOOLS_DIR%\tomcat\bin\tomcat7.exe" /r:1
if "%INSTALL_HTTPD%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\HTTPD Start.lnk" /t:"%TOOLS_DIR%\httpd\bin\httpd.exe" /w:"%TOOLS_DIR%\httpd\bin\" /p:"-k start" /r:1
if "%INSTALL_HTTPD%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\HTTPD Stop.lnk" /t:"%TOOLS_DIR%\httpd\bin\httpd.exe" /w:"%TOOLS_DIR%\httpd\bin\" /p:"-k stop" /r:1
if "%INSTALL_MYSQL%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\MySQL Start.lnk" /t:"%TOOLS_DIR%\mysql\server.cmd" /p:"start"
if "%INSTALL_MYSQL%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\MySQL Stop.lnk" /t:"%TOOLS_DIR%\mysql\server.cmd" /p:"stop"
if "%INSTALL_MYSQL_WORKBENCH%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\MySQL Workbench.lnk" /t:"c:\Program Files (x86)\MySQL\MySQL Workbench\MySQLWorkbench.exe"
if "%INSTALL_ECLIPSE%"=="true" cscript //nologo shortcut.vbs /f:"%ALLUSERSPROFILE%\Start Menu\Programs\Eclipse.lnk" /t:"%TOOLS_DIR%\eclipse\eclipse.exe"

reg add HKEY_CURRENT_USER\Environment /v GIT_SSH /t REG_SZ /d "c:\Program Files (x86)\PuTTY\plink.exe" /f > nul
reg add HKEY_CURRENT_USER\Environment /v JAVA_HOME /t REG_SZ /d "%TOOLS_DIR%\jdk" /f > nul
reg add HKEY_CURRENT_USER\Environment /v ANT_HOME /t REG_SZ /d "%TOOLS_DIR%\ant" /f > nul
reg add HKEY_CURRENT_USER\Environment /v M2_HOME /t REG_SZ /d "%TOOLS_DIR%\maven" /f > nul
reg add HKEY_CURRENT_USER\Environment /v CATALINA_HOME /t REG_SZ /d "%TOOLS_DIR%\tomcat" /f > nul
reg add HKEY_CURRENT_USER\Environment /v HTTPD_HOME /t REG_SZ /d "%TOOLS_DIR%\httpd" /f > nul
reg add HKEY_CURRENT_USER\Environment /v MYSQL_HOME /t REG_SZ /d "%TOOLS_DIR%\mysql" /f > nul

set NEW_PATH="c:\Program Files (x86)\Git\bin";%%JAVA_HOME%%\bin;%%ANT_HOME%%\bin;%%M2_HOME%%\bin;%%CATALINA_HOME%%\bin;%%HTTPD_HOME%%\bin;%%MYSQL_HOME%%\bin;"c:\Program Files (x86)\PuTTY"
reg add HKEY_CURRENT_USER\Environment /v PATH /t REG_EXPAND_SZ /d %NEW_PATH% /f > nul
