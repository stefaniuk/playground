#!/bin/bash

# https://wiki.ubuntu.com/PrecisePangolin/ReleaseNotes/TechnicalOverviewUpstart

# disable upstart jobs
PATTERNS="hvc0.conf"
for PATTERN in $PATTERNS; do
    FILES=$(ls -1 /etc/init/$PATTERN)
    for FILE in $FILES; do
        [ -f $FILE ] && mv $FILE $FILE.disabled
    done
done

exit 0
