#!/bin/bash

# log event
logger -p local0.notice -t host4ge "update system"

# update system
(apt-get --yes update && apt-get --yes dist-upgrade && dpkg --configure -a) 2>&1 | tee /var/log/update.log

# set permission
chown root:root /var/log/update.log
chmod 400 /var/log/update.log
