@echo off

rm *.log

::ant release -Ddevice.name=laptop 2>&1 | tee build.laptop.log
::ant release -Ddevice.name=vm-server 2>&1 | tee build.vm-server.log
::ant release -Ddevice.name=vm-desktop 2>&1 | tee build.vm-desktop.log
::ant release -Ddevice.name=web 2>&1 | tee build.web.log
::ant release -Ddevice.name=hosting 2>&1 | tee build.hosting.log
ant release -Ddevice.name=test 2>&1 | tee build.test.log

