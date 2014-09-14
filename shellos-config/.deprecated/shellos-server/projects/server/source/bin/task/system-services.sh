#!/bin/bash
#
# File: bin/task/system-services.sh
#
# Description: Scheduled job. This script checks if all the services are running.
#
# Usage:
#
#   system-services.sh

# include
source $HOST4GE_DIR/conf/includes.sh

# variables
INITIAL_REBOOT="N"
ON_REBOOT="N"
IGNORE_LOCK="N"
LOG_ERRORS="N"

# parse arguments
while [ "$1" != "" ]; do
    case $1 in
        --initial-reboot)   shift && INITIAL_REBOOT="Y"
                            ;;
        --on-reboot)        shift && ON_REBOOT="Y"
                            ;;
        --ignore-lock)      shift && IGNORE_LOCK="Y"
                            ;;
        --log-errors)       shift && LOG_ERRORS="Y"
                            ;;
    esac
    shift
done

T1=`date +%s`
MSG=

if [ "$INITIAL_REBOOT" == "Y" ] || [ "$ON_REBOOT" == "Y" ]; then
    $HOST4GE_DIR/bin/firewall.sh
fi

if [ "$INITIAL_REBOOT" != "Y" ] && [ "$ON_REBOOT" != "Y" ]; then
    # do not run job if server is not online
    [ "$SERVER_MODE" != "online" ] && exit 0
    # check lock
    if [ "$IGNORE_LOCK" == "N" ] && [ `job_lock_exists $( basename $0 .sh )` == "yes" ]; then
        logger -p local0.notice -t host4ge "job $( basename $0 .sh ) is locked"
        exit 0
    fi
fi

# set lock
job_lock_set $( basename $0 .sh )

# ---------- BEGIN ----------

# ssh-agent
if [ -x $INSTALL_DIR/openssh/bin/ssh-agent ]; then
    PID=`ps ax | grep "$INSTALL_DIR/openssh/bin/ssh-agent$" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "SSH agent not running"
        logger -p local0.notice -t host4ge "start SSH agent"
        $INSTALL_DIR/openssh/bin/ssh-agent-start
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "$INSTALL_DIR/openssh/bin/ssh-agent$" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "SSH agent NOT started!"
            fi
        fi
    fi
fi

# openvpn
if [ -x $INSTALL_DIR/openvpn/bin/openvpn ] && [ -f /srv/openvpn/keys/$(hostname).key ]; then
    PID=`ps ax | grep "$INSTALL_DIR/openvpn/bin/openvpn --config $INSTALL_DIR/openvpn/conf/openvpn-default.conf" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "OpenVPN not running"
        logger -p local0.notice -t host4ge "start OpenVPN"
        $INSTALL_DIR/openvpn/bin/openvpn --config $INSTALL_DIR/openvpn/conf/openvpn-default.conf
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "$INSTALL_DIR/openvpn/bin/openvpn --config $INSTALL_DIR/openvpn/conf/openvpn-default.conf" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "OpenVPN NOT started!"
            fi
        fi
    fi
fi


# mysql
if [ -x $INSTALL_DIR/mysql/bin/mysql.server ]; then
    PID=`ps ax | grep "$INSTALL_DIR/mysql/bin/mysqld" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "MySQL not running"
        logger -p local0.notice -t host4ge "start MySQL"
        $INSTALL_DIR/mysql/bin/mysql.server start
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "$INSTALL_DIR/mysql/bin/mysqld" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "MySQL NOT started!"
            fi
        fi
    fi
fi

# httpd
if [ -x $INSTALL_DIR/httpd/bin/apachectl ]; then
    PID=`ps ax | grep "$INSTALL_DIR/httpd/bin/httpd" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "Apache HTTPD not running"
        logger -p local0.notice -t host4ge "start Apache HTTPD"
        nohup $HOST4GE_DIR/bin/additional-scripts/support/log-httpd-vhost.pl > /dev/null 2>&1 &
        $INSTALL_DIR/httpd/bin/apachectl -k start
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "$INSTALL_DIR/httpd/bin/httpd" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "Apache HTTPD NOT started!"
            fi
        fi
    fi
fi

# proftpd
if [ -x $INSTALL_DIR/proftpd/bin/proftpd ]; then
    PID=`ps ax | grep "proftpd:" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "ProFTPD not running"
        logger -p local0.notice -t host4ge "start ProFTPD"
        nohup $HOST4GE_DIR/bin/additional-scripts/support/log-proftpd.pl > /dev/null 2>&1 &
        $INSTALL_DIR/proftpd/bin/proftpd
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "proftpd:" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "ProFTPD NOT started!"
            fi
        fi
    fi
fi

# postfix
if [ -x $INSTALL_DIR/postfix/bin/postfix ]; then
    PID=`ps ax | grep "$INSTALL_DIR/postfix/bin/master" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "Postfix not running"
        logger -p local0.notice -t host4ge "start Postfix"
        $INSTALL_DIR/postfix/bin/postfix start
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "$INSTALL_DIR/postfix/bin/master" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "Postfix NOT started!"
            fi
        fi
    fi
fi

# dovecot
if [ -x $INSTALL_DIR/dovecot/bin/dovecot ]; then
    PID=`ps ax | grep "$INSTALL_DIR/dovecot/bin/dovecot" | grep -v grep | cut -c1-5 | paste -s -`
    if [ ! "$PID" ]; then
        pkill dovecot;
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "Dovecot not running"
        logger -p local0.notice -t host4ge "start Dovecot"
        $INSTALL_DIR/dovecot/bin/dovecot
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps ax | grep "$INSTALL_DIR/dovecot/bin/dovecot" | grep -v grep | cut -c1-5 | paste -s -`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "Dovecot NOT started!"
            fi
        fi
    fi
fi

# tomcat
if [ -x $INSTALL_DIR/tomcat/bin/tomcat7.sh ]; then
    PID=`ps aux | grep "jsvc.exec" | grep "^tomcat" | grep -v grep | awk '{ print $2 }'`
    if [ ! "$PID" ]; then
        pkill jsvc;
        [ "$LOG_ERRORS" == "Y" ] && logger -p local0.err -t host4ge "Tomcat not running"
        logger -p local0.notice -t host4ge "start Tomcat"
        $INSTALL_DIR/tomcat/bin/tomcat7.sh start
        if [ "$LOG_ERRORS" == "Y" ]; then
            sleep 3
            PID=`ps aux | grep "jsvc.exec" | grep "^tomcat" | grep -v grep | awk '{ print $2 }'`
            if [ ! "$PID" ]; then
                logger -p local0.err -t host4ge "Tomcat NOT started!"
            fi
        fi
    fi
fi

# ---------- END ------------

# remove lock
job_lock_unset $( basename $0 .sh )

# remove all locks on reboot
if [ "$INITIAL_REBOOT" != "Y" ] && [ "$ON_REBOOT" == "Y" ]; then
    job_unlock_all
fi

# measure time
T2=`date +%s`
TIME=$((T2-T1))

# log an event only if it takes longer than specified number of seconds or there is a message
[ $TIME -le $JOB_LOG_EVENT_TIME ] && [ "$MSG" == "" ] && exit 0
if [ "$MSG" == "" ]; then
    logger -p local0.notice -t host4ge "job $( basename $0 .sh ) run (time: $TIME s)"
else
    logger -p local0.notice -t host4ge "job $( basename $0 .sh ) run - $MSG (time: $TIME s)"
fi

exit 0
