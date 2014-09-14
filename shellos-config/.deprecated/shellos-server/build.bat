@echo off

rm *.log

::goto earth

:vms1
:: vms1 nodes
ant release -Dserver.name=vm11 2>&1 | tee build.vm11.log
ant release -Dserver.name=vm12 2>&1 | tee build.vm12.log
ant release -Dserver.name=vm13 2>&1 | tee build.vm13.log
ant release -Dserver.name=vm14 2>&1 | tee build.vm14.log
ant release -Dserver.name=vm15 2>&1 | tee build.vm15.log
:: vms1
ant release -Dserver.name=vms1 2>&1 | tee build.vms1.log
:: remove vms1 nodes
rm build\host4ge-vm1*.tar.gz
:: exit
::goto:eof

:vms2
:: vms2 nodes
ant release -Dserver.name=vm21 2>&1 | tee build.vm21.log
ant release -Dserver.name=vm22 2>&1 | tee build.vm22.log
ant release -Dserver.name=vm23 2>&1 | tee build.vm23.log
:: vms2
ant release -Dserver.name=vms2 2>&1 | tee build.vms2.log
:: remove vms2 nodes
rm build\host4ge-vm2*.tar.gz
:: exit
::goto:eof

:earth
:: earth nodes
ant release -Dserver.name=mars 2>&1 | tee build.mars.log
ant release -Dserver.name=jupiter 2>&1 | tee build.jupiter.log
ant release -Dserver.name=saturn 2>&1 | tee build.saturn.log
ant release -Dserver.name=uranus 2>&1 | tee build.uranus.log
ant release -Dserver.name=neptune 2>&1 | tee build.neptune.log
:: earth
ant release -Dserver.name=earth 2>&1 | tee build.earth.log
:: remove earth nodes
rm build\host4ge-mars.tar.gz
rm build\host4ge-jupiter.tar.gz
rm build\host4ge-saturn.tar.gz
rm build\host4ge-uranus.tar.gz
rm build\host4ge-neptune.tar.gz
:: exit
::goto:eof
