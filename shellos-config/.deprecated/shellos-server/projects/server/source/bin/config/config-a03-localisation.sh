#!/bin/bash

# set time zone
dpkg-reconfigure -f noninteractive tzdata
if [ "$LOCATION" == "GB" ]; then
    echo "Europe/London" > /etc/timezone
fi
if [ "$LOCATION" == "PL" ]; then
    echo "Europe/Warsaw" > /etc/timezone
fi
dpkg-reconfigure -f noninteractive tzdata

# set locale
if [ "$LOCATION" == "GB" ]; then
    locale-gen en_GB.UTF-8
    update-locale LANG=en_GB.UTF-8 LC_MESSAGES=POSIX
fi
if [ "$LOCATION" == "PL" ]; then
    locale-gen pl_PL
    update-locale LANG=pl_PL.ISO-8859-2 LC_MESSAGES=POSIX
fi

exit 0
