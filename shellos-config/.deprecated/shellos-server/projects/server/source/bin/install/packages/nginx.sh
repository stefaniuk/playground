#!/bin/bash

##
## variables
##

NGINX_NAME=
NGINX_PORT=
NGINX_PORT_SSL=
NGINX_USER=
NGINX_GROUP=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --nginx)    shift
                    NGINX_NAME=$1
                    shift
                    NGINX_PORT=$1
                    shift
                    NGINX_PORT_SSL=$1
                    shift
                    NGINX_USER=$1
                    shift
                    NGINX_GROUP=$1
                    ;;
    esac
    shift
done

##
## download
##

PKG_NAME="nginx-$NGINX_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz"
    FILE=nginx-$NGINX_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

# create user and group
user_create "$NGINX_USER" 521 "$NGINX_GROUP" 521

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile Nginx:"
    [ -d $INSTALL_DIR/$NGINX_NAME ] && rm -rf $INSTALL_DIR/$NGINX_NAME
    tar -zxf nginx-$NGINX_VERSION.tar.gz
    cd nginx-$NGINX_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/$NGINX_NAME \
        --sbin-path=$INSTALL_DIR/$NGINX_NAME/bin/nginx \
        --conf-path=$INSTALL_DIR/$NGINX_NAME/conf/nginx.conf \
        --pid-path=$INSTALL_DIR/$NGINX_NAME/log/nginx.pid \
        --lock-path=$INSTALL_DIR/$NGINX_NAME/log/nginx.lock \
        --error-log-path=$INSTALL_DIR/$NGINX_NAME/log/error.log \
        --http-log-path=$INSTALL_DIR/$NGINX_NAME/log/access.log \
        --user=$NGINX_USER \
        --group=$NGINX_GROUP \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
    && make && make install && echo "Nginx installed successfully!"
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols_file $INSTALL_DIR/$NGINX_NAME/bin/nginx
    echo "Create package:"
    package_create $INSTALL_DIR/nginx $PKG_NAME
else
    echo "Install Nginx from package:"
    package_restore $PKG_NAME
fi

if [ ! -f $INSTALL_DIR/$NGINX_NAME/bin/nginx ]; then
    echo "Error: Nginx has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

# set files permission
chown -R root:root $INSTALL_DIR/$NGINX_NAME
chown -R $NGINX_USER:$NGINX_GROUP $INSTALL_DIR/$NGINX_NAME/log
chmod 500 $INSTALL_DIR/$NGINX_NAME/bin
chmod 500 $INSTALL_DIR/$NGINX_NAME/bin/*
chmod 700 $INSTALL_DIR/$NGINX_NAME/log

##
## post install
##

[ -f nginx-$NGINX_VERSION.tar.gz ] && rm nginx-$NGINX_VERSION.tar.gz
[ -d nginx-$NGINX_VERSION ] && rm -rf nginx-$NGINX_VERSION

# log event
logger -p local0.notice -t host4ge "nginx $NGINX_VERSION installed successfully"

# save package version
package_add_version "nginx" "$NGINX_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/$NGINX_NAME/bin

exit 0
