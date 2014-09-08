@echo off
set /p USER=User: 
set /p DIR=Directory: 
echo.
dir "%DIR%" /w /p
echo.
set /p CONFIRM=If you wish to proceed enter OK (match case):
if %CONFIRM%==OK subinacl /File "%DIR%" /Revoke="%USER%"
if %CONFIRM%==OK subinacl /SubDIRtories "%DIR%"\ /ObjectExclude="%SYSTEMDRIVE%\Documents and Settings\%USER%*" /Revoke="%USER%"
if %CONFIRM%==OK subinacl /File "%SYSTEMDRIVE%\Documents and Settings\%USER%" /Grant="%USER%"
pause
