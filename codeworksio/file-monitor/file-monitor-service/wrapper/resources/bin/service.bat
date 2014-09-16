@echo off

setlocal EnableDelayedExpansion

set "CURRENT_DIR=%cd%"
cd ..
set "SERVICE_HOME=%cd%"
cd "%CURRENT_DIR%"

:: --- CUSTOM VARIABLES ------------------------------------------------------------------------------------------------

set SERVICE_NAME=FileMonitorService
call :tolower SERVICE_NAME SERVICE_NAME_LC
set SERVICE_DISPLAYNAME=File Monitor Service
set SERVICE_DESCRIPTION=File Monitor Service
set PROCRUN=%SERVICE_HOME%\bin\%SERVICE_NAME%.exe
set CLASS=io.codeworks.file.monitor.service.FileMonitorService
set JAR=%SERVICE_HOME%\lib\file-monitor-service-0.0.1-SNAPSHOT.jar

::-- fully qualified start/stop class
set START_CLASS=%CLASS%
set STOP_CLASS=%CLASS%
::-- start/stop methods
set START_METHOD=start
set STOP_METHOD=stop
::-- start/stop arguments
set START_PARAMS=start
set STOP_PARAMS=stop
::-- service startup type
set STARTUP_TYPE=auto
::-- JVM path
set PATH_TO_JVM=%JAVA_HOME%\jre\bin\server\jvm.dll
:: -- classpath
set CLASSPATH=%JAR%

:: --- SERVICE VARIABLES -----------------------------------------------------------------------------------------------

set PR_INSTALL=%PROCRUN%

:: --- RUN -------------------------------------------------------------------------------------------------------------

if "%1" == "" goto usage
if /i %1 == install goto install
if /i %1 == remove goto remove
if /i %1 == start goto start
if /i %1 == stop goto stop

:: --- USAGE -----------------------------------------------------------------------------------------------------------

:usage
echo Usage: service.bat install/remove/start/stop
goto end

:: --- INSTALL THE SERVICE ---------------------------------------------------------------------------------------------

:install
%PROCRUN% //IS//%SERVICE_NAME% ^
    --DisplayName="%SERVICE_DISPLAYNAME%" --Description="%SERVICE_DESCRIPTION%" ^
    --Startup %STARTUP_TYPE% ^
    --StartClass %START_CLASS% --StopClass %STOP_CLASS% ^
    --StartMode jvm --StopMode jvm --Jvm %PATH_TO_JVM% ^
    --StartMethod %START_METHOD% --StopMethod  %STOP_METHOD% ^
    --StartParams %START_PARAMS% --StopParams %STOP_PARAMS% ^
    --Type=interactive ^
    --LogLevel=Debug --LogPath=%SERVICE_HOME%\log --LogPrefix=%SERVICE_NAME_LC%-wrapper ^
    --StdOutput=auto --StdError=auto ^
    --Classpath=%CLASSPATH% ^
    --JvmMs 128 --JvmMx 256 ^
    ++JvmOptions "-Djava.io.tmpdir=%SERVICE_HOME%\tmp"
echo The service '%SERVICE_NAME%' has been installed
goto end

:: --- REMOVE THE SERVICE ----------------------------------------------------------------------------------------------

:remove
%PROCRUN% //DS//%SERVICE_NAME%
echo The service '%SERVICE_NAME%' has been removed
goto end

:: --- START THE SERVICE -----------------------------------------------------------------------------------------------

:start
net start %SERVICE_NAME%
goto end

:: --- STOP THE SERVICE ------------------------------------------------------------------------------------------------

:stop
net stop %SERVICE_NAME%
goto end

:: --- FUNCTIONS -------------------------------------------------------------------------------------------------------

:tolower
set _tmp=!%1!
set _abet=a b c d e f g h i j k l m n o p q r s t u v w x y z
for %%Z in (%_abet%) do set _tmp=!_tmp:%%Z=%%Z!
set %2=%_tmp%
goto end

:: ---------------------------------------------------------------------------------------------------------------------

:end
