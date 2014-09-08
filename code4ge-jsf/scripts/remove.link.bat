@echo off

VER | findstr /i "5.1." > nul
IF %ERRORLEVEL% EQU 0 set version=WINXP
VER | findstr /i "6.1." > nul
IF %ERRORLEVEL% EQU 0 set version=WIN7

if "%version%"=="WINXP" (
	if exist "%1" junction -d "%1"
)
if "%version%"=="WIN7" (
	if exist "%1" rmdir "%1"
)
