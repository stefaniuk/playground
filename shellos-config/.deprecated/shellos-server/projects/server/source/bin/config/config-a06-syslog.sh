#!/bin/bash

# stop syslog service
service rsyslog stop

# remove old syslog files
#if [ "$SERVER_MODE" == "installation" ]; then
#    find /var/log/* -maxdepth 0 -type f \
#        -not -name 'lastlog' \
#        -not -name 'udev' \
#        -not -name 'wtmp' \
#        -exec rm -rf '{}' ';'
#fi

# /etc/rsyslog.d/50-default.conf
[ ! -f /etc/rsyslog.d/50-default.conf.old ] && cp /etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf.old
cat <<EOF > /etc/rsyslog.d/50-default.conf
auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
cron.* -/var/log/cron.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
user.* -/var/log/user.log
*.emerg *

# custom facilities
local0.* -/var/log/host4ge.log
local0.err -/var/log/host4ge.err
local1.* -/var/log/openvpn.log
local1.err -/var/log/openvpn.err
local3.* -/var/log/mysql.log
local3.err -/var/log/mysql.err
local4.* -/var/log/httpd.log
local4.err -/var/log/httpd.err
ftp.* -/var/log/ftp.log
mail.* -/var/log/mail.log
mail.err -/var/log/mail.err
EOF

# /etc/rsyslog.conf
replace_in_file '$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat' '#$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat' /etc/rsyslog.conf
replace_in_file '$FileCreateMode 0640' '$FileCreateMode 0600' /etc/rsyslog.conf

# start syslog service
service rsyslog start

# /etc/logrotate.conf
cat <<EOF > /etc/logrotate.conf
include /etc/logrotate.d
EOF

# /etc/logrotate.d/rsyslog
if [ ! -d /etc/logrotate.d.old ]; then
    mv /etc/logrotate.d /etc/logrotate.d.old
    mkdir /etc/logrotate.d
fi
cat <<EOF > /etc/logrotate.d/rsyslog
/var/log/auth.log
/var/log/sys.log
/var/log/cron.log
/var/log/daemon.log
/var/log/kern.log
/var/log/user.log
/var/log/host4ge.log
/var/log/host4ge.err
/var/log/openvpn.log
/var/log/openvpn.err
/var/log/mysql.log
/var/log/mysql.err
/var/log/httpd.log
/var/log/httpd.err
/var/log/ftp.log
/var/log/mail.log
/var/log/mail.err
{
    start 0
    rotate 9
    size 10M
    notifempty
    copytruncate
    compress
    delaycompress
    sharedscripts
    $INSTALL_DIR/postfix/bin/mail $ADMIN_MAIL
    postrotate
        reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF

exit 0
