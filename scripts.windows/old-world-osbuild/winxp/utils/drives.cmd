SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set LOGFILE=c:\drives-setup.log
set LOGLINE=--------------------------------------------------------------------------------

echo %LOGLINE% >> %LOGFILE%
echo -- %TIME:~0,8% -- Starting >> %LOGFILE%
echo %LOGLINE% >> %LOGFILE%

for /F "TOKENS=3" %%I in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "SourcePath" ^| FINDSTR "SourcePath"') do set INSTCD=%%~dI

set NEWCDROM1=%1
set NEWCDROM2=%2
set NEWCDROM3=%3

if "%NEWCDROM1%"=="" set NEWCDROM1=X:
if "%NEWCDROM2%"=="" set NEWCDROM2=Y:
if "%NEWCDROM3%"=="" set NEWCDROM3=Z:

echo %LOGLINE% >> %LOGFILE%
echo CD Setup Log File >> %LOGFILE%
echo. >> %LOGFILE%
echo Install CD = %INSTCD% >> %LOGFILE%
echo. >> %LOGFILE%
echo NEWCDROM1 = %NEWCDROM1% >> %LOGFILE%
echo NEWCDROM2 = %NEWCDROM2% >> %LOGFILE%
echo NEWCDROM3 = %NEWCDROM3% >> %LOGFILE%
echo. >> %LOGFILE%
echo DOS Devices as per Registry: >> %LOGFILE%
echo. >> %LOGFILE%
reg query HKLM\SYSTEM\MountedDevices | FINDSTR "DosDevices" >> %LOGFILE%

set NEWINSTCD=
set CDCOUNT=0

for /F "TOKENS=1,3 DELIMS= " %%A in ('reg query HKLM\SYSTEM\MountedDevices ^| FINDSTR "DosDevices"') do (
	set TEST_VARA=%%A
	set TEST_VARB=%%B
	set RESULT=!TEST_VARB:~0,32!
	if "!RESULT!"=="5C003F003F005C004900440045002300" (
		set DLETTER=!TEST_VARA:~12,2!
		set /A CDCOUNT=!CDCOUNT!+1
		if "!CDCOUNT!"=="1" set CDROM1=!DLETTER!
		if "!CDCOUNT!"=="2" set CDROM2=!DLETTER!
		if "!CDCOUNT!"=="3" set CDROM3=!DLETTER!
	)
)

for /F "TOKENS=1,3 DELIMS= " %%A in ('reg query HKLM\SYSTEM\MountedDevices ^| FINDSTR "DosDevices"') do (
	set TEST_VARA=%%A
	set TEST_VARB=%%B
	set RESULT=!TEST_VARB:~0,32!
	if "!RESULT!"=="5C003F003F005C005300430053004900" (
		set DLETTER=!TEST_VARA:~12,2!
		set /A CDCOUNT=!CDCOUNT!+1
		if "!CDCOUNT!"=="1" set CDROM1=!DLETTER!
		if "!CDCOUNT!"=="2" set CDROM2=!DLETTER!
		if "!CDCOUNT!"=="3" set CDROM3=!DLETTER!
	)
)

echo. >> %LOGFILE%
echo CDs found: %CDCOUNT% >> %LOGFILE%
echo. >> %LOGFILE%
echo CDROM1 = %CDROM1% >> %LOGFILE%
echo CDROM2 = %CDROM2% >> %LOGFILE%
echo CDROM3 = %CDROM3% >> %LOGFILE%
echo. >> %LOGFILE%

if "%CDROM1%"=="" goto NOMORECDS
if "%CDROM1%"=="%INSTCD%" set NEWINSTCD=%NEWCDROM1%

echo Changing %CDROM1% to %NEWCDROM1% >> %LOGFILE%

for /F "TOKENS=1 DELIMS= " %%A in ('MOUNTVOL %CDROM1% /L') do set VOLINFO=%%A
MOUNTVOL %CDROM1% /D
MOUNTVOL %NEWCDROM1% %VOLINFO%
SUBST %CDROM1% %NEWCDROM1%\

if "%CDROM2%"=="" goto NOMORECDS
if "%CDROM2%"=="%INSTCD%" set NEWINSTCD=%NEWCDROM2%

echo Changing %CDROM2% to %NEWCDROM2% >> %LOGFILE%

for /F "TOKENS=1 DELIMS= " %%A in ('MOUNTVOL %CDROM2% /L') do set VOLINFO=%%A
MOUNTVOL %CDROM2% /D
MOUNTVOL %NEWCDROM2% %VOLINFO%

if "%CDROM3%"=="" goto NOMORECDS
if "%CDROM3%"=="%INSTCD%" set NEWINSTCD=%NEWCDROM3%

echo Changing %CDROM3% to %NEWCDROM3% >> %LOGFILE%

for /F "TOKENS=1 DELIMS= " %%A in ('MOUNTVOL %CDROM3% /L') do set VOLINFO=%%A
MOUNTVOL %CDROM3% /D
MOUNTVOL %NEWCDROM3% %VOLINFO%

:NOMORECDS

if not "%NEWINSTCD%"=="" (
	echo. >> %LOGFILE%
	echo Updating SourcePath to %NEWINSTCD%\I386 >> %LOGFILE%
	echo Creating INSTALLCD Variable = %NEWINSTCD% >> %LOGFILE%
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V "SourcePath" /T REG_SZ /D %NEWINSTCD%\I386 /F
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V INSTALLCD /T REG_SZ /D %NEWINSTCD% /F
)

echo %LOGLINE% >> %LOGFILE%
echo -- %TIME:~0,8% -- Finished >> %LOGFILE%
echo %LOGLINE% >> %LOGFILE%
