@echo off
set /p USER=User: 
set /p DIR=Directory: 
echo.
dir "%DIR%" /w /p
echo.
set /p CONFIRM=If you wish to proceed enter OK (match case): 
if %CONFIRM%==OK subinacl /File "%DIR%" /Grant="%USER%"
if %CONFIRM%==OK subinacl /Subdirectories "%DIR%"\ /ObjectExclude=%SYSTEMROOT%* /ObjectExclude="*\System Volume Info*" /ObjectExclude=%SYSTEMROOT%\*.sys /ObjectExclude=%SYSTEMROOT%\AUTOEXEC.BAT /ObjectExclude=%SYSTEMROOT%\boot.ini /ObjectExclude=%SYSTEMROOT%\NTDETECT.COM /ObjectExclude=%SYSTEMROOT%\ntldr /Grant="%USER%"
pause
