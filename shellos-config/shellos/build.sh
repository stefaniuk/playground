#!/bin/bash

rm *.log > /dev/null 2>&1

#ant release -Ddevice.name=laptop 2>&1 | tee build.laptop.log
#ant release -Ddevice.name=vm-server 2>&1 | tee build.vm-server.log
#ant release -Ddevice.name=vm-desktop 2>&1 | tee build.vm-desktop.log
#ant release -Ddevice.name=web 2>&1 | tee build.web.log
#ant release -Ddevice.name=hosting 2>&1 | tee build.hosting.log
ant release -Ddevice.name=test 2>&1 | tee build.test.log

#cp -v /var/shellos/workspace/shellos/build/shellos-laptop.tar.gz /srv
#cp -v /var/shellos/workspace/shellos/build/install /srv
#chmod +x /srv/install

exit 0

