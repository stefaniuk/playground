@echo off

set WORKSPACE_DIR=workspace

:: change directory to script's directory
%~d0
cd %~dp0

:: remove links
if exist %WORKSPACE_DIR%\AddOns junction -d %WORKSPACE_DIR%\AddOns
if exist %WORKSPACE_DIR%\AutoIt junction -d %WORKSPACE_DIR%\AutoIt
if exist %WORKSPACE_DIR%\Config junction -d %WORKSPACE_DIR%\Config
if exist %WORKSPACE_DIR%\Drivers junction -d %WORKSPACE_DIR%\Drivers
if exist %WORKSPACE_DIR%\Utils junction -d %WORKSPACE_DIR%\Utils
if exist %WORKSPACE_DIR%\Wallpapers junction -d %WORKSPACE_DIR%\Wallpapers

:: remove directory content
if exist %WORKSPACE_DIR% rmdir /S /Q %WORKSPACE_DIR%

:: extract Windows XP from a ZIP archive
7z x windows\winxp.zip -o%WORKSPACE_DIR%
copy windows\script.cmd %WORKSPACE_DIR%

:: create links
if exist programs junction %WORKSPACE_DIR%\AddOns programs
if exist scripts junction %WORKSPACE_DIR%\AutoIt scripts
if exist config junction %WORKSPACE_DIR%\Config config
if exist drivers junction %WORKSPACE_DIR%\Drivers drivers
if exist utils junction %WORKSPACE_DIR%\Utils utils
if exist wallpapers junction %WORKSPACE_DIR%\Wallpapers wallpapers

:: customize Windows installation
nLite /preset:"%CD%\windows\Last Session.ini" /path:"%CD%\%WORKSPACE_DIR%"

:: autorun.inf file
if exist %WORKSPACE_DIR%\AUTORUN.INF del /f %WORKSPACE_DIR%\AUTORUN.INF
mkdir %WORKSPACE_DIR%\Resources
copy windows\win_cd.ico %WORKSPACE_DIR%\Resources
copy windows\autorun.inf %WORKSPACE_DIR%

:: TODO automated CD/DVD image creation
