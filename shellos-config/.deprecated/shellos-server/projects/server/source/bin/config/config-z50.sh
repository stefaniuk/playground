#!/bin/bash

# clean up
rm -rfv /srv/cvs
rm -rfv /tmp/*
rm -rfv /var/www
touch /var/log/wtmp && chmod 600 /var/log/wtmp

echo -e "\nSystem info BEGIN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"

echo -e "Host\n"
host $IP_ADDRESS
nslookup $IP_ADDRESS

echo -e "CPU\n"
cat /proc/cpuinfo

echo -e "Memory\n"
cat /proc/meminfo

echo -e "Hard drives\n"
fdisk -l

echo -e "Hardware\n"
lshw

echo -e "Disk usage\n"
df -h

echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< System info END\n"

exit 0
