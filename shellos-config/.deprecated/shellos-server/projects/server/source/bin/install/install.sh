#!/bin/bash
#
# File: bin/install/install.sh
#
# Description: This script compiles, installs and configures predefined or
#              customized list of packages.
#
# Usage:
#
#   cd /srv/host4ge/bin/install && chmod u+x *.sh && ./install.sh --force-all | --predefined | --custom <packages> [--debug]

# check architecture
[ "$(dpkg --print-architecture)" != "amd64" ] && echo "64-bit architecture is required" && exit 1

# set variables
TIMESTAMP=$(date +"%G%m%d%H%M")
SCRIPT_DIR=`dirname $(readlink -f $0)`
ARGS=$*
PACKAGES=$ARGS
FORCE_ALL=
PREDEFINED=
CUSTOM=
DEBUG=
RESULT=0

# parse arguments
while [ "$1" != "" ]; do
    case $1 in
        --force-all)    FORCE_ALL="Y"
                        ;;
        --predefined)   PREDEFINED="Y"
                        ;;
        --custom)       CUSTOM="Y"
                        ;;
        --debug)        DEBUG="Y"
                        ;;
    esac
    shift
done

# switch on debuging
[ "$DEBUG" == "Y" ] && set -xv

# change current directory to the script's directory
cd $SCRIPT_DIR

if [ "$FORCE_ALL" == "Y" ] || [ "$PREDEFINED" == "Y" ] || [ "$CUSTOM" == "Y" ]; then
    # source versions
    source ./versions.sh
    # source variables
    source ./variables.sh
    # source common constants and functions
    source ../../conf/includes.sh
fi

if [ "$FORCE_ALL" == "Y" ] || [ "$PREDEFINED" == "Y" ]; then

    # select all packages by default
    PACKAGES=$(cat <<EOF
        $ARGS \
        --initialise \
        --lzo \
        --openssh \
        --openvpn \
        --geoip \
        --mysql mysql 3306 mysql mysql \
        --nginx nginx 80 443 nginx nginx \
        --apr \
        --httpd httpd 80 443 httpd httpd \
        --mod-security httpd \
        --mod-geoip httpd \
        --perl \
        --php mysql httpd 80 httpd httpd \
        --apc httpd 80 php \
        --geoip-so php \
        --imagemagick \
        --imagick \
        --proftpd mysql \
        --postfix mysql \
        --dovecot mysql \
        --git \
        --openjdk \
        --lxc \
        --phpmyadmin mysql httpd \
        --roundcube mysql httpd \
        --update-environment \
        --host4ge mysql \
        --kernel \
        --finalise
EOF
)

    # server role: development
    if [ $(server_has_role development) == "yes" ] && [ "$FORCE_ALL" != "Y" ]; then
        PACKAGES=$(cat <<EOF
            $ARGS \
            --initialise \
            --lzo \
            --openssh \
            --openvpn \
            --geoip \
            --mysql mysql 3306 mysql mysql \
            --apr \
            --httpd httpd 80 443 httpd httpd \
            --mod-security httpd \
            --mod-geoip httpd \
            --perl \
            --php mysql httpd 80 httpd httpd \
            --geoip-so php \
            --imagemagick \
            --imagick \
            --proftpd mysql \
            --postfix mysql \
            --dovecot mysql \
            --git \
            --phpmyadmin mysql httpd \
            --roundcube mysql httpd \
            --host4ge mysql \
            --finalise
EOF
)

    # server role: live
    elif [ $(server_has_role live) == "yes" ] && [ $(server_has_role host) == "yes" ] && [ "$FORCE_ALL" != "Y" ]; then
        PACKAGES=$(cat <<EOF
            $ARGS \
            --initialise \
            --openssh \
            --geoip \
            --mysql mysql 3306 mysql mysql \
            --apr \
            --httpd httpd 80 443 httpd httpd \
            --mod-geoip httpd \
            --perl \
            --php mysql httpd 80 httpd httpd \
            --geoip-so php \
            --imagemagick \
            --imagick \
            --postfix mysql \
            --git \
            --phpmyadmin mysql httpd \
            --host4ge mysql \
            --finalise
EOF
)
    fi

fi

# log event
if [ "$SERVER_MODE" != "installation" ]; then
    logger -p local0.notice -t host4ge "build started"
fi

# run build script
[ ! -d $HOST4GE_DIR/log/$TIMESTAMP ] && mkdir $HOST4GE_DIR/log/$TIMESTAMP
chmod u+x ./build.sh
. ./build.sh \
    --timestamp $TIMESTAMP \
    $PACKAGES \
    --notify \
2>&1 | tee $HOST4GE_DIR/log/$TIMESTAMP/build.log
RESULT=${PIPESTATUS[0]}

if [ "$RESULT" == 0 ]; then

    # move files and set permissions
    if [ "$CHROOT" = "N" ]; then
        mv $HOST4GE_DIR/bin/install/packages/*.{dat.gz,tar.bz2,tar.gz,tgz,patch} $DOWNLOADS_DIR > /dev/null 2>&1
    else
        echo "no" | mv -i $HOST4GE_DIR/bin/install/packages/*.{dat.gz,tar.bz2,tar.gz,tgz,patch} $DOWNLOADS_DIR > /dev/null 2>&1
    fi
    chmod 400 $DOWNLOADS_DIR/*.{dat.gz,tar.bz2,tar.gz,tgz,patch} > /dev/null 2>&1
    chmod 500 $HOST4GE_DIR/log/$TIMESTAMP > /dev/null 2>&1
    chmod 400 $HOST4GE_DIR/log/$TIMESTAMP/*.{log,out} > /dev/null 2>&1
    chmod 400 $HOST4GE_DIR/log/*.{log,out} > /dev/null 2>&1

    # log event
    logger -p local0.notice -t host4ge "build completed"
    if [ "$SERVER_MODE" == "installation" ]; then
        logger -p local0.notice -t host4ge "reboot"
        reboot
    fi

fi

# switch off debuging
[ "$DEBUG" == "Y" ] && set +xv

exit $RESULT
