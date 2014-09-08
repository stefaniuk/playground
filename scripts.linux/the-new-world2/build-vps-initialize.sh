#!/bin/bash

echo "System:" `uname -a`
echo "Disk usage:" `du -hcs / | grep total`

# set time zone
dpkg-reconfigure -f noninteractive tzdata
echo "Europe/London" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
update-locale

# load firewall rules
[ -f $INSTALL_DIR/scripts/load-firewall-rules.sh ] &&  $INSTALL_DIR/scripts/load-firewall-rules.sh

# configure ssh
groupadd -g 10000 sshjail
replace_in_file "Port 2200" "Port 22" /etc/ssh/sshd_config
replace_in_file "Port 22" "Port 2200" /etc/ssh/sshd_config
replace_in_file "Subsystem sftp \/usr\/lib\/openssh\/sftp-server" "Subsystem sftp internal-sftp \/usr\/lib\/openssh\/sftp-server" /etc/ssh/sshd_config
(	echo -e "\nMatch group sshjail" && \
	echo -e "\tChrootDirectory %h" && \
	echo -e "\tX11Forwarding no" && \
	echo -e "\tAllowTcpForwarding no" && \
	echo -e "\tForceCommand internal-sftp" \
) >> /etc/ssh/sshd_config
service ssh restart

# remove sendmail and apache
pkill sendmail
pkill apache
dpkg --get-selections | awk '{ print $1 }' | egrep -i "sysklogd|sendmail|apache|portmap" | xargs apt-get --purge -y remove

# exclude packages from updates (to remove exclusion use 'echo package install | dpkg --set-selections')
echo bind9 hold | dpkg --set-selections
echo openssh-client hold | dpkg --set-selections
echo openssh-server hold | dpkg --set-selections
echo openssl hold | dpkg --set-selections
echo samba hold | dpkg --set-selections
echo samba-common-bin hold | dpkg --set-selections

# /etc/apt/sources.list
cat <<EOF > /etc/apt/sources.list
## main & restricted repositories
deb http://gb.archive.ubuntu.com/ubuntu/ lucid main restricted
deb-src http://gb.archive.ubuntu.com/ubuntu/ lucid main restricted

deb http://security.ubuntu.com/ubuntu lucid-updates main restricted
deb-src http://security.ubuntu.com/ubuntu lucid-updates main restricted

deb http://security.ubuntu.com/ubuntu lucid-security main restricted
deb-src http://security.ubuntu.com/ubuntu lucid-security main restricted

## universe repositories - uncomment to enable
deb http://gb.archive.ubuntu.com/ubuntu/ lucid universe
deb-src http://gb.archive.ubuntu.com/ubuntu/ lucid universe

deb http://gb.archive.ubuntu.com/ubuntu/ lucid-updates universe
deb-src http://gb.archive.ubuntu.com/ubuntu/ lucid-updates universe

deb http://security.ubuntu.com/ubuntu lucid-security universe
deb-src http://security.ubuntu.com/ubuntu lucid-security universe

## partner repositories
deb http://archive.canonical.com/ubuntu lucid partner
deb-src http://archive.canonical.com/ubuntu lucid partner

deb http://archive.canonical.com/ubuntu lucid-updates partner
deb-src http://archive.canonical.com/ubuntu lucid-updates partner

deb http://archive.canonical.com/ubuntu lucid-security partner
deb-src http://archive.canonical.com/ubuntu lucid-security partner
EOF

# apt-get update and install
apt-get update && apt-get -y --force-yes upgrade && apt-get -y --force-yes install \
	wget build-essential autoconf cmake bison re2c strace \
	libncurses5-dev libssl-dev libpcre3 libpcre3-dev libxml2-dev libexpat1-dev libbz2-dev libjpeg62-dev libpng12-dev libmcrypt-dev libdb-dev libwrap0-dev \
	libfreetype6 libfreetype6-dev libtool mkpasswd rsyslog iptables dnsutils dsniff nmap cpulimit \
	git-core perl curl \
	&& apt-get clean

# install Perl modules
$INSTALL_DIR/scripts/perlmod_installer.pl && rm -v $INSTALL_DIR/scripts/perlmod_installer.pl
$INSTALL_DIR/scripts/perlmod.pl -i Config::IniFiles File::Slurp

# configure rsyslog
service rsyslog stop
find /var/log/* -maxdepth 0 -not -name 'apt' -not -name 'lastlog' -exec rm -rf '{}' ';'
cat <<EOF > /etc/rsyslog.d/50-default.conf
# /etc/rsyslog.d/50-default.conf

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
local3.* -/var/log/mysql.log
local3.err -/var/log/mysql.err
local4.* -/var/log/httpd.log
local4.err -/var/log/httpd.err
ftp.* -/var/log/ftp.log
mail.* -/var/log/mail.log
mail.err -/var/log/mail.err
EOF
replace_in_file '$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat' '#$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat' /etc/rsyslog.conf
replace_in_file '$FileCreateMode 0640' '$FileCreateMode 0600' /etc/rsyslog.conf
service rsyslog start

# cron jobs
rm -v /etc/cron.{hourly,daily,weekly,monthly}/{.placeholder,*}
cat <<EOF > /etc/cron.hourly/.placeholder
# DO NOT EDIT OR REMOVE
# This file is a simple placeholder to keep dpkg from removing this directory
EOF
cp -v /etc/cron.hourly/.placeholder /etc/cron.daily
cp -v /etc/cron.hourly/.placeholder /etc/cron.weekly
cp -v /etc/cron.hourly/.placeholder /etc/cron.monthly

# configure logrotate
rm -v /etc/logrotate.d/samba

# /etc/cron.hourly/logrotate
cat <<EOF > /etc/cron.hourly/logrotate
#!/bin/bash
#
# file: /etc/cron.hourly/logrotate

test -x /usr/sbin/logrotate || exit 0
/usr/sbin/logrotate /etc/logrotate.conf
EOF
chmod 755 /etc/cron.hourly/logrotate

# /etc/logrotate.conf
cat <<EOF > /etc/logrotate.conf
# file: /etc/logrotate.conf

include /etc/logrotate.d
EOF

# /etc/logrotate.d/rsyslog
cat <<EOF > /etc/logrotate.d/rsyslog
# file: /etc/logrotate.d/rsyslog

/var/log/auth.log
/var/log/sys.log
/var/log/cron.log
/var/log/daemon.log
/var/log/kern.log
/var/log/user.log
/var/log/host4ge.log
/var/log/host4ge.err
/var/log/mysql.log
/var/log/mysql.err
/var/log/httpd.log
/var/log/httpd.err
/var/log/ftp.log
/var/log/mail.log
/var/log/mail.err
{
    start 0
    rotate 6
    size 5M
    notifempty
    copytruncate
    compress
    delaycompress
    sharedscripts
    postrotate
        reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF

# fix libraries
ln -sfv /usr/lib/libexpat.so /usr/lib/libexpat.so.0
ln -sfv /usr/lib/libjpeg.so.62 /usr/lib/libjpeg.so
