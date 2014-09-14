#!/bin/bash

cd /srv/host4ge/sbin
./install \
    --lzo \
    --zlib \
    --openssl \
    --git \
    --geoip \
    --openssh \
    --openvpn \
    --mysql \
    --postfix \
    --lxc \
    --libvirt \
    --perl \
    --libiconv \
    --imagemagick \
    --httpd \
    --httpd-geoip \
    --php \
    --php-geoip \
    --php-imagick \
    --proftpd \
    --dovecot \
    --openjdk \
    --tomcat \
    --phpmyadmin \
    --roundcube \
    --host4ge --notify 2>&1 | tee /srv/host4ge/log/install.log

exit 0
