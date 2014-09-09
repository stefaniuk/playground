set JRE_VER="7"
set JDK_VER="7"
set TOMCAT_VER="7"

if "%1"=="5" (
    set JRE_VER="5"
    set JDK_VER="5"
    set TOMCAT_VER="55"
)

if "%1"=="6" (
    set JRE_VER="6"
    set JDK_VER="6"
    set TOMCAT_VER="6"
)

rmdir jdk
mklink /d jdk jdk%JDK_VER%

rmdir jre
mklink /d jre jdk\jre

rmdir tomcat
mklink /d tomcat tomcat%TOMCAT_VER%
