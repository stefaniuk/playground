#!/bin/bash
#
# File: bin/install/build.sh
#
# Description: This script compiles, installs and configures predefined or
#              customized list of packages.
#
# Usage:
#
#    . ./build.sh \
#        --timestamp $TIMESTAMP \
#        --initialise \
#        <packages> \
#        --finalise \
#        --notify \
#    2>&1 | tee $HOST4GE_DIR/log/$TIMESTAMP/build.log

echo "Script started on `date +\"%T %Z (%d %b %G)\"`"

###
### variables
###

TIME_START=`date +%s`

CURRENT_DIR=$SCRIPT_DIR
ARGS=$*

TIMESTAMP=
CHROOT="N"

INITIALISE="N"
FINALISE="N"
SELECTIVE_CONFIG="N"

NOTIFY="N"

ZLIB_INSTALL="N"
LZO_INSTALL="N"
OPENSSL_INSTALL="N"
OPENSSH_INSTALL="N"
OPENVPN_INSTALL="N"
LIBICONV_INSTALL="N"
CURL_INSTALL="N"
LIBEVENT_INSTALL="N"
TOR_INSTALL="N"
GEOIP_INSTALL="N"
MYSQL_INSTALL="N"
NGINX_INSTALL="N"
APR_INSTALL="N"
HTTPD_INSTALL="N"
MOD_SECURITY_INSTALL="N"
MOD_FASTCGI_INSTALL="N"
MOD_GEOIP_INSTALL="N"
PERL_INSTALL="N"
PHP_INSTALL="N"
PHP_FPM_INSTALL="N"
APC_INSTALL="N"
GEOIP_SO_INSTALL="N"
MEMCACHED_INSTALL="N"
IMAGEMAGICK_INSTALL="N"
IMAGICK_INSTALL="N"
PROFTPD_INSTALL="N"
POSTFIX_INSTALL="N"
DOVECOT_INSTALL="N"
GIT_INSTALL="N"
OPENJDK_INSTALL="N"
TOMCAT_INSTALL="N"
LXC_INSTALL="N"
PHPMYADMIN_INSTALL="N"
ROUNDCUBE_INSTALL="N"
UPDATE_ENVIRONMENT_INSTALL="N"
HOST4GE_INSTALL="N"
KERNEL_INSTALL="N"

KERNEL_FORCE_COMPILATION="N"
PACKAGES_FORCE_COMPILATION="N"
DO_NOT_USE_CACHED_UPDATES="N"

i=1

###
### parse arguments
###

while [ "$1" != "" ]; do
    case $1 in
        --timestamp)                    shift; TIMESTAMP=$1
                                        ;;
        --chroot)                       CHROOT="Y"
                                        ;;
        --initialise)                   INITIALISE="Y"
                                        ;;
        --finalise)                     FINALISE="Y"
                                        ;;
        --selective-config)             SELECTIVE_CONFIG="Y"
                                        ;;
        --notify)                       NOTIFY="Y"
                                        ;;
        --zlib)                         ZLIB_INSTALL="Y"
                                        ;;
        --lzo)                          LZO_INSTALL="Y"
                                        ;;
        --openssl)                      OPENSSL_INSTALL="Y"
                                        ;;
        --openssh)                      OPENSSH_INSTALL="Y"
                                        ;;
        --openvpn)                      OPENVPN_INSTALL="Y"
                                        ;;
        --libiconv)                     LIBICONV_INSTALL="Y"
                                        ;;
        --curl)                         CURL_INSTALL="Y"
                                        ;;
        --libevent)                     LIBEVENT_INSTALL="Y"
                                        ;;
        --tor)                          TOR_INSTALL="Y"
                                        ;;
        --geoip)                        GEOIP_INSTALL="Y"
                                        ;;
        --mysql)                        MYSQL_INSTALL="Y"
                                        ;;
        --nginx)                        NGINX_INSTALL="Y"
                                        ;;
        --apr)                          APR_INSTALL="Y"
                                        ;;
        --httpd)                        HTTPD_INSTALL="Y"
                                        ;;
        --mod-security)                 MOD_SECURITY_INSTALL="Y"
                                        ;;
        --mod-fastcgi)                  MOD_FASTCGI_INSTALL="Y"
                                        ;;
        --mod-geoip)                    MOD_GEOIP_INSTALL="Y"
                                        ;;
        --perl)                         PERL_INSTALL="Y"
                                        ;;
        --php)                          PHP_INSTALL="Y"
                                        ;;
        --php-fpm)                      PHP_FPM_INSTALL="Y"
                                        ;;
        --apc)                          APC_INSTALL="Y"
                                        ;;
        --geoip-so)                     GEOIP_SO_INSTALL="Y"
                                        ;;
        --memcached)                    MEMCACHED_INSTALL="Y"
                                        ;;
        --imagemagick)                  IMAGEMAGICK_INSTALL="Y"
                                        ;;
        --imagick)                      IMAGICK_INSTALL="Y"
                                        ;;
        --proftpd)                      PROFTPD_INSTALL="Y"
                                        ;;
        --postfix)                      POSTFIX_INSTALL="Y"
                                        ;;
        --dovecot)                      DOVECOT_INSTALL="Y"
                                        ;;
        --git)                          GIT_INSTALL="Y"
                                        ;;
        --openjdk)                      OPENJDK_INSTALL="Y"
                                        ;;
        --tomcat)                       TOMCAT_INSTALL="Y"
                                        ;;
        --lxc)                          LXC_INSTALL="Y"
                                        ;;
        --phpmyadmin)                   PHPMYADMIN_INSTALL="Y"
                                        ;;
        --roundcube)                    ROUNDCUBE_INSTALL="Y"
                                        ;;
        --update-environment)           UPDATE_ENVIRONMENT_INSTALL="Y"
                                        ;;
        --host4ge)                      HOST4GE_INSTALL="Y"
                                        ;;
        --kernel)                       KERNEL_INSTALL="Y"
                                        ;;
        --kernel-force-compilation)     KERNEL_FORCE_COMPILATION="Y"
                                        ;;
        --packages-force-compilation)   PACKAGES_FORCE_COMPILATION="Y"
                                        ;;
        --do-not-use-cached-updates)    DO_NOT_USE_CACHED_UPDATES="Y"
                                        ;;
    esac
    shift
done

###
### functions
###

# parameters:
#   $1 package
function install_package() {

    cd $CURRENT_DIR/packages

    PACKAGE=$1
    SCRIPT=./$PACKAGE.sh

    if [ ! -f $SCRIPT ]; then
        return
    fi

    NUMBER=`printf %02d $i`
    chmod u+x $SCRIPT
    . $SCRIPT $ARGS 2>&1 | tee $HOST4GE_DIR/log/$TIMESTAMP/$NUMBER-$PACKAGE.log
    RETVAL=${PIPESTATUS[0]}
    [ "$RETVAL" == "1" ] && exit 1
    i=`expr $i + 1`
}

###
### initialise
###

if [ "$INITIALISE" == "Y" ] || [ "$SELECTIVE_CONFIG" == "Y" ]; then

    cd $CURRENT_DIR

    FILES=$(ls -1 ../config/config-a*.sh | sort)
    for SCRIPT in $FILES; do
        NAME=$(substring $SCRIPT '../config/' '.sh')
        if [ "$INITIALISE" != "Y" ] && [ "$SELECTIVE_CONFIG" == "Y" ] && [ -z "$(echo $ARGS | grep $NAME)" ]; then
            continue
        fi
        cd $CURRENT_DIR
        if [ ! -f $SCRIPT ]; then
            return
        fi
        chmod u+x $SCRIPT
        . $SCRIPT $ARGS 2>&1 | tee $HOST4GE_DIR/log/$TIMESTAMP/$NAME.log
        RETVAL=${PIPESTATUS[0]}
        [ "$RETVAL" == "1" ] && exit 1
    done

fi

###
### install
###

# install zlib
[ "$ZLIB_INSTALL" == "Y" ] && \
    install_package "zlib"

# install lzo
[ "$LZO_INSTALL" == "Y" ] && \
    install_package "lzo"

# install openssl
[ "$OPENSSL_INSTALL" == "Y" ] && \
    install_package "openssl"

# install openssh
[ "$OPENSSH_INSTALL" == "Y" ] && \
    install_package "openssh"

# install openvpn
[ "$OPENVPN_INSTALL" == "Y" ] && \
    install_package "openvpn"

# install libiconv
[ "$LIBICONV_INSTALL" == "Y" ] && \
    install_package "libiconv"

# install curl
[ "$CURL_INSTALL" == "Y" ] && \
    install_package "curl"

# install libevent
[ "$LIBEVENT_INSTALL" == "Y" ] && \
    install_package "libevent"

# install tor
[ "$TOR_INSTALL" == "Y" ] && \
    install_package "tor"

# install geoip
[ "$GEOIP_INSTALL" == "Y" ] && \
    install_package "geoip"

# install mysql
[ "$MYSQL_INSTALL" == "Y" ] && \
    install_package "mysql"

# install nginx
[ "$NGINX_INSTALL" == "Y" ] && \
    install_package "nginx"

# install apr
[ "$APR_INSTALL" == "Y" ] && \
    install_package "apr"

# install httpd
[ "$HTTPD_INSTALL" == "Y" ] && \
    install_package "httpd"

# install mod-security
[ "$MOD_SECURITY_INSTALL" == "Y" ] && \
    install_package "mod-security"

# install mod-fastcgi
[ "$MOD_FASTCGI_INSTALL" == "Y" ] && \
    install_package "mod-fastcgi"

# install mod-geoip
[ "$MOD_GEOIP_INSTALL" == "Y" ] && \
    install_package "mod-geoip"

# install perl
[ "$PERL_INSTALL" == "Y" ] && \
    install_package "perl"

# install php
[ "$PHP_INSTALL" == "Y" ] && \
    install_package "php"

# install php-fpm
[ "$PHP_FPM_INSTALL" == "Y" ] && \
    install_package "php-fpm"

# install apc
[ "$APC_INSTALL" == "Y" ] && \
    install_package "apc"

# install geoip-so
[ "$GEOIP_SO_INSTALL" == "Y" ] && \
    install_package "geoip-so"

# install memcached
[ "$MEMCACHED_INSTALL" == "Y" ] && \
    install_package "memcached"

# install imagemagick
[ "$IMAGEMAGICK_INSTALL" == "Y" ] && \
    install_package "imagemagick"

# install imagick
[ "$IMAGICK_INSTALL" == "Y" ] && \
    install_package "imagick"

# install proftpd
[ "$PROFTPD_INSTALL" == "Y" ] && \
    install_package "proftpd"

# install postfix
[ "$POSTFIX_INSTALL" == "Y" ] && \
    install_package "postfix"

# install dovecot
[ "$DOVECOT_INSTALL" == "Y" ] && \
    install_package "dovecot"

# install git
[ "$GIT_INSTALL" == "Y" ] && \
    install_package "git"

# install openjdk
[ "$OPENJDK_INSTALL" == "Y" ] && \
    install_package "openjdk"

# install tomcat
[ "$TOMCAT_INSTALL" == "Y" ] && \
    install_package "tomcat"

# install lxc
[ "$LXC_INSTALL" == "Y" ] && \
    install_package "lxc"

# install phpmyadmin
[ "$PHPMYADMIN_INSTALL" == "Y" ] && \
    install_package "phpmyadmin"

# install roundcube
[ "$ROUNDCUBE_INSTALL" == "Y" ] && \
    install_package "roundcube"

# install update environment
#[ "$UPDATE_ENVIRONMENT_INSTALL" == "Y" ] && \
#    install_package "update-environment"

# install host4ge
[ "$HOST4GE_INSTALL" == "Y" ] && \
    install_package "host4ge"

# install kernel
[ "$KERNEL_INSTALL" == "Y" ] && \
    install_package "kernel"

###
### finalise
###

if [ "$FINALISE" == "Y" ] || [ "$SELECTIVE_CONFIG" == "Y" ]; then

    cd $CURRENT_DIR

    FILES=$(ls -1 ../config/config-z*.sh | sort)
    for SCRIPT in $FILES; do
        NAME=$(substring $SCRIPT '../config/' '.sh')
        if [ "$INITIALISE" != "Y" ] && [ "$SELECTIVE_CONFIG" == "Y" ] && [ -z "$(echo $ARGS | grep $NAME)" ]; then
            continue
        fi
        cd $CURRENT_DIR
        if [ ! -f $SCRIPT ]; then
            return
        fi
        chmod u+x $SCRIPT
        . $SCRIPT $ARGS 2>&1 | tee $HOST4GE_DIR/log/$TIMESTAMP/$NAME.log
        RETVAL=${PIPESTATUS[0]}
        [ "$RETVAL" == "1" ] && exit 1
    done

fi

###
### notify
###

TIME_END=`date +%s`
TIME=$((TIME_END-TIME_START))

# send notification by e-mail
if [ "$CHROOT" == "N" ] && [ "$NOTIFY" == "Y" ] && [ -x $INSTALL_DIR/postfix/bin/mailx ]; then
    (   echo -e "`hostname -f` ($IP_ADDRESS) has been build at `date +\"%T %Z (%d %b %G)\"`, the whole process took `expr $TIME / 60` minutes.\n\nList of installed packages:\n";
        cat $PACKAGES_FILE | sed 's/=/ /g'
    ) | $INSTALL_DIR/postfix/bin/mailx -r "admin@$(hostname).$DOMAIN" -s "$(hostname).$DOMAIN - build: completed successfully" $ADMIN_MAIL
fi

echo "Script ended at `date +\"%T %Z (%d %b %G)\"` (time: `expr $TIME / 60` min)"

exit 0
