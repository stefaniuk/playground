#!/bin/bash

##
## variables
##

DOVECOT_MYSQL_NAME=
VMAILID=1100
MAIL_DIR_ESC=`echo "$MAIL_DIR" | sed 's/\//\\\\\//g'`

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --dovecot)  shift && DOVECOT_MYSQL_NAME=$1
                    ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$DOVECOT_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: Dovecot requires MySQL!"
    exit 1
fi
if [ ! -f $INSTALL_DIR/postfix/bin/postfix ]; then
    echo "Error: Dovecot requires postfix!"
    exit 1
fi

##
## download
##

PKG_NAME="dovecot-$DOVECOT_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://dovecot.org/releases/2.1/dovecot-$DOVECOT_VERSION.tar.gz"
    FILE=dovecot-$DOVECOT_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 3000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

pkill dovecot

# create user and group
user_create "dovecot" 550 "dovecot" 550
user_create "dovenull" 551 "dovenull" 551

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile Dovecot":
    [ -d $INSTALL_DIR/dovecot ] && rm -rf $INSTALL_DIR/dovecot
    tar -zxf dovecot-$DOVECOT_VERSION.tar.gz
    cd dovecot-$DOVECOT_VERSION
    CPPFLAGS="-I/usr/include" LDFLAGS="-L/lib -ldl" ./configure \
        --prefix=$INSTALL_DIR/dovecot \
        --sbindir=$INSTALL_DIR/dovecot/bin \
        --with-zlib \
        --with-ssl=openssl \
        --with-ssldir=/usr \
        --with-mysql \
        --with-sql=plugin \
    && make && make install && echo "Dovecot installed successfully!" \
    && mkdir $INSTALL_DIR/dovecot/log
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols_file $INSTALL_DIR/dovecot/bin
    strip_debug_symbols_file $INSTALL_DIR/dovecot/libexec/dovecot
    strip_debug_symbols_file $INSTALL_DIR/dovecot/lib/dovecot
    echo "Create package:"
    package_create $INSTALL_DIR/dovecot $PKG_NAME
else
    echo "Install Dovecot from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/dovecot/bin/dovecot ]; then
    echo "Error: Dovecot has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/dovecot/bin/dovecot:"
ldd $INSTALL_DIR/dovecot/bin/dovecot

# create link to the log file
ln -sfv /var/log/mail.log $INSTALL_DIR/dovecot/log/mail.log
ln -sfv /var/log/mail.err $INSTALL_DIR/dovecot/log/mail.err

# generate certificate
generate_certificate "dovecot"

MAIL_DB_NAME="mail"
MAIL_DB_USER="mail"
MAIL_DB_PASS=`mysql_get_user_password $MAIL_DB_USER`

# config files
cp -rf $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/conf.d $INSTALL_DIR/dovecot/etc/dovecot
cp $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/dovecot.conf $INSTALL_DIR/dovecot/etc/dovecot
cp $INSTALL_DIR/dovecot/share/doc/dovecot/example-config/dovecot-*.conf.ext $INSTALL_DIR/dovecot/etc/dovecot
rm -rf $INSTALL_DIR/dovecot/share

# dovecot.conf
cp $INSTALL_DIR/dovecot/etc/dovecot/dovecot.conf $INSTALL_DIR/dovecot/etc/dovecot/dovecot.conf.old
replace_in_file "#protocols = imap pop3 lmtp" "protocols = imap pop3" $INSTALL_DIR/dovecot/etc/dovecot/dovecot.conf
# 10-auth.conf
cp $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-auth.conf $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-auth.conf.old
replace_in_file "auth_mechanisms = plain" "auth_mechanisms = plain login" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-auth.conf
replace_in_file '!include auth-system.conf.ext' '#!include auth-system.conf.ext' $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-auth.conf
replace_in_file '#!include auth-sql.conf.ext' '!include auth-sql.conf.ext' $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-auth.conf
# auth-sql.conf.ext
mv $INSTALL_DIR/dovecot/etc/dovecot/conf.d/auth-sql.conf.ext $INSTALL_DIR/dovecot/etc/dovecot/conf.d/auth-sql.conf.ext.old
cat <<EOF > $INSTALL_DIR/dovecot/etc/dovecot/conf.d/auth-sql.conf.ext
passdb {
    driver = sql
    args = $INSTALL_DIR/dovecot/etc/dovecot/dovecot-sql.conf.ext
}
userdb {
    driver = static
    args = uid=$VMAILID gid=$VMAILID home=$MAIL_DIR/%d/%n/Maildir allow_all_users=yes
}
EOF
# 10-mail.conf
cp $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-mail.conf $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-mail.conf.old
replace_in_file "#mail_location = " "mail_location = maildir:$MAIL_DIR_ESC\/%d\/%n\/Maildir" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-mail.conf
replace_in_file "  inbox = yes" "  #inbox = yes" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-mail.conf
cat <<EOF >> $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-mail.conf

##
## custom
##

namespace {
    type = private
    location = maildir:$MAIL_DIR/%d/%n/Maildir
    separator = .
    prefix = INBOX.
    inbox = yes
}
EOF
# 10-master.conf
cp $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-master.conf $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-master.conf.old
remove_from_file "  #unix_listener \/var\/spool\/postfix\/private\/auth {.*  #}\n" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-master.conf
replace_in_file "  unix_listener auth-userdb {" "\n  unix_listener auth-userdb {\n    mode = 0600\n    user = vmail\n    group = vmail" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-master.conf
replace_in_file "  # Postfix smtp-auth" "  unix_listener \/var\/spool\/postfix\/private\/auth {\n    mode = 0660\n    user = postfix\n    group = postfix\n  }" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-master.conf

# 10-ssl.conf
CERTIFICATES_DIR_ESC=`echo "$CERTIFICATES_DIR" | sed 's/\//\\\\\//g'`
cp $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf.old
replace_in_file "#ssl = yes" "ssl = yes" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
replace_in_file "ssl_cert = <\/etc\/ssl\/certs\/dovecot.pem" "ssl_cert = <$CERTIFICATES_DIR_ESC\/dovecot.pem" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
replace_in_file "ssl_key = <\/etc\/ssl\/private\/dovecot.pem" "ssl_key = <$CERTIFICATES_DIR_ESC\/dovecot.pem" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/10-ssl.conf
# 15-lda.conf
cp $INSTALL_DIR/dovecot/etc/dovecot/conf.d/15-lda.conf $INSTALL_DIR/dovecot/etc/dovecot/conf.d/15-lda.conf.old
replace_in_file "  #mail_plugins = \$mail_plugins" "  #auth_socket_path = \/var\/run\/dovecot\/auth-master\n  postmaster_address = admin@$(hostname).$DOMAIN\n  #mail_plugins = sieve\n  #log_path = $MAIL_DIR_ESC\/dovecot-lda.err\n  #info_log_path = $MAIL_DIR_ESC\/dovecot-lda.log\n  syslog_facility = mail" $INSTALL_DIR/dovecot/etc/dovecot/conf.d/15-lda.conf
# dovecot-sql.conf.ext
cp $INSTALL_DIR/dovecot/etc/dovecot/dovecot-sql.conf.ext $INSTALL_DIR/dovecot/etc/dovecot/dovecot-sql.conf.ext.old
cat <<EOF >> $INSTALL_DIR/dovecot/etc/dovecot/dovecot-sql.conf.ext

##
## custom
##

driver = mysql
connect = host=$INSTALL_DIR/$DOVECOT_MYSQL_NAME/log/mysql.sock dbname=$MAIL_DB_NAME user=$MAIL_DB_USER password=$MAIL_DB_PASS
default_pass_scheme = PLAIN
password_query = SELECT email as user, password FROM users WHERE email='%u';
EOF

mkdir -p /var/spool/postfix/private

# postfix master.cf
cat <<EOF >> $INSTALL_DIR/postfix/conf/master.cf
dovecot unix - n n - - pipe
  flags=DRhu user=vmail:vmail argv=$INSTALL_DIR/dovecot/libexec/dovecot/dovecot-lda -f \${sender} -d \${recipient}
EOF
# postfix main.cf
$INSTALL_DIR/postfix/bin/postconf -e virtual_transport=dovecot
$INSTALL_DIR/postfix/bin/postconf -e dovecot_destination_recipient_limit=1
$INSTALL_DIR/postfix/bin/postconf -e mailbox_command=$INSTALL_DIR/dovecot/libexec/dovecot/dovecot-lda

# set files permission
chmod 755 $INSTALL_DIR/dovecot/bin
chmod 555 $INSTALL_DIR/dovecot/bin/*
chmod 400 $INSTALL_DIR/dovecot/etc/dovecot/dovecot-sql.conf.ext
chown vmail:vmail $INSTALL_DIR/dovecot/libexec/dovecot/dovecot-lda

##
## post install
##

[ -f dovecot-$DOVECOT_VERSION.tar.gz ] && rm dovecot-$DOVECOT_VERSION.tar.gz
[ -d dovecot-$DOVECOT_VERSION ] && rm -rf dovecot-$DOVECOT_VERSION

# log event
logger -p local0.notice -t host4ge "dovecot $DOVECOT_VERSION installed successfully"

# save package version
package_add_version "dovecot" "$DOVECOT_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/dovecot/bin
hashes_add_dir $INSTALL_DIR/dovecot/lib
hashes_add_dir $INSTALL_DIR/dovecot/libexec

exit 0
