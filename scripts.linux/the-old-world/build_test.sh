#!/bin/bash

./build.sh --init --zlib --openssl --apr --download 2>&1 | tee build.base.out && source ~/.profile
./build.sh --mysql mysql3306 mysql3306 mysql3306 3306 --download 2>&1 | tee build.mysql3306.out
./build.sh --apache proxy apache80 apache80 apache80 80 443 --download 2>&1 | tee build.apache80.out
./build.sh --apache webserver apache8081 apache8081 apache8081 8081 1443 --php mod mysql3306 --apc --download 2>&1 | tee build.apache8081.out
#./build.sh --apache webserver apache8082 apache8082 apache8082 8082 2443 --php mod mysql3306 --apc --download 2>&1 | tee build.apache8082.out
#./build.sh --apache webserver apache8082 apache8082 apache8082 8082 2443 --php fpm mysql3307 --apc --download 2>&1 | tee build.apache8082.out

./build.sh --vsftpd --download 2>&1 | tee build.vsftpd.out

./build.sh --phpmyadmin --download 2>&1 | tee build.application-phpmyadmin.out

#./build.sh --openjdk --tomcat tomcat8080 tomcat8080 tomcat8080 8080 8443 --download 2>&1 | tee build.tomcat8080.out

# code4ge.com
#./build.sh --app code4ge.com apache80 tomcat8080 8080 8443 2>&1 | tee build.app-code4ge.com.out
#./build.sh --ssl-entry code4ge.com apache80 ajp 8009 2>&1 | tee build.ssl-code4ge.com.out

# stefaniuk.org
#./build.sh --site stefaniuk.org apache80 apache8081 8081 1443 2>&1 | tee build.site-stefaniuk.org.out

# hosting
#./build.sh --site wypadek.cc apache80 apache8082 8082 2443 2>&1 | tee build.site-wypadek.cc.out
#./build.sh --site polecam.cc apache80 apache8082 8082 2443 2>&1 | tee build.site-polecam.cc.out
