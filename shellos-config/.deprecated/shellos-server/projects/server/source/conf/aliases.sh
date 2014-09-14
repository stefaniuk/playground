#!/bin/bash
#
# File: conf/aliases.sh
#
# Description: Bash aliases.
#
# Usage:
#
#   source conf/aliases.sh

alias srcinc='source $HOST4GE_DIR/conf/includes.sh'
alias srcver='source $HOST4GE_DIR/bin/install/versions.sh'

# search/replace files
alias ffi='file_find_in'
alias fri='file_replace_in'

# mysql login
alias mur='mysql --user=root --password=`mysql_get_user_password root`'

# lock/unlock jobs
alias jla='job_lock_all'
alias jua='job_unlock_all'

# check file hashes
alias hcb='hashes_count_bad'
alias hlb='hashes_list_bad'

# print logs
alias tlau='tail /var/log/auth.log'
alias tlsy='tail /var/log/sys.log'
alias tlcr='tail /var/log/cron.log'
alias tlda='tail /var/log/daemon.log'
alias tlke='tail /var/log/kern.log'
alias tlus='tail /var/log/user.log'
alias tlho='tail /var/log/host4ge.log'
alias tlhoe='tail /var/log/host4ge.err'
alias tlov='tail /var/log/openvpn.log'
alias tlove='tail /var/log/openvpn.err'
alias tlms='tail /var/log/mysql.log'
alias tlmse='tail /var/log/mysql.err'
alias tlht='tail /var/log/httpd.log'
alias tlhte='tail /var/log/httpd.err'
alias tlft='tail /var/log/ftp.log'
alias tlma='tail /var/log/mail.log'
alias tlmae='tail /var/log/mail.err'

# change current directory
alias cba='cd $BACKUP_ACCOUNTS_DIR'
alias cbd='cd $BACKUP_DATABASES_DIR'
alias cbl='cd $BACKUP_LOGS_DIR'
alias ccd='cd $DOWNLOADS_DIR'
alias cck='cd $KERNELS_DIR'
alias ccp='cd $PACKAGES_DIR'
alias chac='cd $HOSTING_ACCOUNTS_DIR'
alias chap='cd $HOSTING_APPLICATIONS_DIR'
alias cvl='cd /var/log'

# manage httpd service
alias shta='apachectl -k start'
alias shto='apachectl -k stop'
alias shtr='httpd_restart'

# TODO: add all services
