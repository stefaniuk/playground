#!/bin/bash

# remove predefined crontab jobs
rm -v /etc/cron.{hourly,daily,weekly,monthly}/{.placeholder,*} > /dev/null 2>&1
cat <<EOF > /etc/cron.hourly/.placeholder
# DO NOT EDIT OR REMOVE
# This file is a simple placeholder to keep dpkg from removing this directory
EOF
cp -v /etc/cron.hourly/.placeholder /etc/cron.daily
cp -v /etc/cron.hourly/.placeholder /etc/cron.weekly
cp -v /etc/cron.hourly/.placeholder /etc/cron.monthly

exit 0
