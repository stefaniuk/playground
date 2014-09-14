#!/bin/bash

# cgrup
[ -d /sys/fs/cgroup ] && mkdir -p /sys/fs/cgroup

if [ "$SERVER_MODE" == "installation" ]; then
    chown -R root:root $INSTALL_DIR > /dev/null 2>&1
    chown -R root:root $HOST4GE_DIR > /dev/null 2>&1
fi

chmod 755 $HOST4GE_DIR

# bin directory
chmod 500 $HOST4GE_DIR/bin > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/{host4ge,host4ged,run} > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/*.{pl,sh} > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/additional-scripts/{custom,hosting,support}/*.{pl,sh} > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/config/*.sh > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/install/*.sh > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/install/packages/*.sh > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/task/*.sh > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/bin/update/*.sh > /dev/null 2>&1

# conf directory
chmod 700 $HOST4GE_DIR/conf > /dev/null 2>&1
chmod 600 $HOST4GE_DIR/conf/{.crontab,.database-users,.hash-directories,.hash-files,.packages,.profile,.repositories,*.conf} > /dev/null 2>&1
chmod 500 $HOST4GE_DIR/conf/*.sh > /dev/null 2>&1

# lib directory
chmod 555 $HOST4GE_DIR/lib > /dev/null 2>&1

# log directory
chmod 700 $HOST4GE_DIR/log > /dev/null 2>&1

# var directory
chmod 700 $BACKUP_DIR > /dev/null 2>&1
chmod 700 $BACKUP_ACCOUNTS_DIR > /dev/null 2>&1
chmod 700 $BACKUP_DATABASES_DIR > /dev/null 2>&1
chmod 700 $BACKUP_LOGS_DIR > /dev/null 2>&1
chmod 700 $CACHE_DIR > /dev/null 2>&1
chmod 700 $DOWNLOADS_DIR > /dev/null 2>&1
chmod 700 $KERNELS_DIR > /dev/null 2>&1
chmod 700 $PACKAGES_DIR > /dev/null 2>&1
chmod 700 $UPDATES_DIR > /dev/null 2>&1
chmod 700 $CERTIFICATES_DIR > /dev/null 2>&1
chmod 700 $MAIL_DIR > /dev/null 2>&1
chmod 700 $TMP_DIR > /dev/null 2>&1
chmod 500 $WWW_DIR > /dev/null 2>&1

exit 0
