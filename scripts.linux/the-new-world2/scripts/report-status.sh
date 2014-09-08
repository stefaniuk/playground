#!/bin/bash

INSTALL_DIR=/srv
ADMIN_EMAIL_ADDRESS="daniel.stefaniuk@gmail.com"

# log event
logger -p local0.notice -t host4ge "report status"

# SEE: http://elinux.org/Runtime_Memory_Measurement

TIME=`date +"%T"`

(	echo -e "Time: $TIME `date +\"%Z (%d %b %G)\"`" && \
	echo -e "\nConnections (`expr \`netstat -tuapn | wc -l\` - 2`):\n" && \
	echo -e "`netstat -tuapn`" && \
	echo -e "\nProcesses (`expr \`ps aux --sort -vsize | wc -l\` - 2`):\n" && \
	echo -e "`ps aux --sort -vsize`" && \
	echo -e "\nMemory:\n" && \
	echo -e "`free -m`" && \
	echo -e "\nUpdates:\n" && \
	echo -e "`cat /var/log/update.log`" \
) | $INSTALL_DIR/postfix/bin/mailx -s "`hostname -f` - status at $TIME" $ADMIN_EMAIL_ADDRESS
