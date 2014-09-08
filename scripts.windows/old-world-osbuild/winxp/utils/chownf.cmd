@echo off
set /p USER=User: 
set /p DIR=Directory: 
set /p FILES=File(s): 
echo.
dir "%DIR%\%FILES%" /w /p
echo.
set /p CONFIRM=If you wish to proceed enter OK (match case):
if %CONFIRM%==OK subinacl /File "%DIR%" /Grant="%USER%"
if %CONFIRM%==OK subinacl /File "%DIR%\%FILES%" /Grant="%USER%"
pause
