#!/bin/bash

GIT=$INSTALL_DIR/git/bin/git

# version control
if [ -x $GIT ]; then

    cat <<EOF > $INSTALL_DIR/.gitignore
/*
EOF
    [ -d $INSTALL_DIR/dovecot/etc ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!dovecot
dovecot/*
!dovecot/etc
EOF
    [ -d $INSTALL_DIR/geoip/etc ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!geoip
geoip/*
!geoip/etc
EOF
    [ -d $INSTALL_DIR/host4ge/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!host4ge
host4ge/*
!host4ge/conf
EOF
    [ -d $INSTALL_DIR/httpd/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!httpd
httpd/*
!httpd/conf
EOF
    [ -d $INSTALL_DIR/lxc/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!lxc
lxc/*
!lxc/conf
EOF
    [ -d $INSTALL_DIR/mysql/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!mysql
mysql/*
!mysql/conf
EOF
    [ -d $INSTALL_DIR/nginx/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!nginx
nginx/*
!nginx/conf
EOF
    [ -d $INSTALL_DIR/openssh/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!openssh
openssh/*
!openssh/conf
EOF
    [ -d $INSTALL_DIR/openvpn/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!openvpn
openvpn/*
!openvpn/conf
EOF
    [ -d $INSTALL_DIR/php/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!php
php/*
!php/conf
EOF
    [ -d $INSTALL_DIR/php-fpm/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!php-fpm
php-fpm/*
!php-fpm/conf
EOF
    [ -d $INSTALL_DIR/postfix/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!postfix
postfix/*
!postfix/conf
EOF
    [ -d $INSTALL_DIR/proftpd/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!proftpd
proftpd/*
!proftpd/conf
EOF
    [ -d $INSTALL_DIR/git/conf ] && cat <<EOF >> $INSTALL_DIR/.gitignore

!git
git/*
!git/conf
EOF

    chmod 400 $INSTALL_DIR/.gitignore
    cd $INSTALL_DIR

    if [ "$SERVER_MODE" == "installation" ]; then

        $GIT init && chmod 700 .git
        $GIT config user.name "$ADMIN_NAME"
        $GIT config user.email "$ADMIN_MAIL"
        $GIT config core.autocrlf false
        $GIT config core.filemode true
        $GIT add .
        $GIT commit -m "initial commit"
        repositories_add_dir $INSTALL_DIR

    else

        if [ "$($GIT status -s | wc -l)" -gt 0 ]; then

            $GIT add .
            $GIT commit -m "update"

        fi

    fi

fi

exit 0
