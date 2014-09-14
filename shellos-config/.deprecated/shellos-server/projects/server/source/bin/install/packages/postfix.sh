#!/bin/bash

##
## variables
##

POSTFIX_MYSQL_NAME=
VMAILID=1100

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --postfix)  shift && POSTFIX_MYSQL_NAME=$1
                    ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysqld ]; then
    echo "Error: Postfix requires MySQL!"
    exit 1
fi

##
## download
##

PKG_NAME="postfix-$POSTFIX_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://mirror.tje.me.uk/pub/mirrors/postfix-release/official/postfix-$POSTFIX_VERSION.tar.gz"
    FILE=postfix-$POSTFIX_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 3000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
    URL="http://downloads.sourceforge.net/project/heirloom/heirloom-mailx/$MAILX_VERSION/mailx-$MAILX_VERSION.tar.bz2"
    FILE=mailx-$MAILX_VERSION.tar.bz2
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 200000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
    URL="http://www.linuxfromscratch.org/patches/blfs/svn/mailx-$MAILX_VERSION-openssl_1.0.0_build_fix-1.patch"
    FILE=mailx-$MAILX_VERSION-openssl_1.0.0_build_fix-1.patch
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 4000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

pkill master

# create user and group
user_create "postfix" 540 "postfix" 540
groupadd -g 541 postdrop

# create virtual mail user
groupadd -g $VMAILID vmail
useradd -u $VMAILID -d $HOST4GE_DIR/var/mail -s /usr/sbin/nologin -g vmail vmail
chown -R vmail:vmail $HOST4GE_DIR/var/mail
chmod 700 $HOST4GE_DIR/var/mail

if [ "$PKG_RESULT" != "success" ]; then

    echo "Compile Postfix:"
    [ -d $INSTALL_DIR/postfix ] && rm -rf $INSTALL_DIR/postfix
    tar -zxf postfix-$POSTFIX_VERSION.tar.gz
    cd postfix-$POSTFIX_VERSION
    make makefiles \
    CCARGS='-DDEF_COMMAND_DIR=\"/srv/postfix/bin\" \
        -DDEF_CONFIG_DIR=\"/srv/postfix/conf\" \
        -DDEF_DAEMON_DIR=\"/srv/postfix/bin\" \
        -DDEF_DATA_DIR=\"/srv/postfix/data\" \
        -DDEF_HTML_DIR=\"/srv/postfix/doc/html\" \
        -DDEF_MANPAGE_DIR=\"/srv/postfix/man\" \
        -DDEF_QUEUE_DIR=\"/srv/postfix/queue\" \
        -DDEF_README_DIR=\"/srv/postfix/doc/README\" \
        -DDEF_MAILQ_PATH=\"/srv/postfix/bin/mailq\" \
        -DDEF_SENDMAIL_PATH=\"/srv/postfix/bin/sendmail\" \
        -DUSE_TLS -I/usr/include/openssl \
        -DHAS_MYSQL -I/srv/mysql/include' \
        AUXLIBS='-L/usr/lib -lresolv -lssl -lcrypto -lmysqlclient -lz -lm' \
    && make && chmod u+x ./postfix-install && sh ./postfix-install -non-interactive && echo "Postfix installed successfully!" \
    && mkdir $INSTALL_DIR/postfix/log \
    && rm -rf $INSTALL_DIR/postfix/{doc,man} \
    && cat $INSTALL_DIR/postfix/bin/postfix-files | grep -vP "html_directory|manpage_directory|readme_directory|sample_directory" > $INSTALL_DIR/postfix/bin/postfix-files.new \
    && mv $INSTALL_DIR/postfix/bin/postfix-files.new $INSTALL_DIR/postfix/bin/postfix-files
    cd ..

    echo "Compile Mailx:"
    tar -jxf mailx-$MAILX_VERSION.tar.bz2
    cd mailx-$MAILX_VERSION
    patch -Np1 -i ../mailx-$MAILX_VERSION-openssl_1.0.0_build_fix-1.patch && \
        replace_in_file 'SSLv2_client_method' 'SSLv3_client_method' ./openssl.c && \
        make SENDMAIL=$INSTALL_DIR/postfix/bin/sendmail && \
        make PREFIX=$INSTALL_DIR/postfix MAILSPOOL=$HOST4GE_DIR/var/mail UCBINSTALL=/usr/bin/install install && \
        ln -sfv $INSTALL_DIR/postfix/bin/mailx $INSTALL_DIR/postfix/bin/mail && \
        ln -sfv $INSTALL_DIR/postfix/bin/mailx $INSTALL_DIR/postfix/bin/nail && \
    echo "Mailx installed successfully!"
    rm -rf $INSTALL_DIR/postfix/share
    cd ..

    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/postfix/bin
    strip_debug_symbols_file $INSTALL_DIR/postfix/bin/mailx
    echo "Create package:"
    package_create $INSTALL_DIR/postfix $PKG_NAME

else
    echo "Install Postfix from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/postfix/bin/postfix ] || [ ! -f $INSTALL_DIR/postfix/bin/mailx ]; then
    echo "Error: Postfix has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/postfix/bin/postfix:"
ldd $INSTALL_DIR/postfix/bin/postfix
echo "Shared library dependencies for $INSTALL_DIR/postfix/bin/mailx:"
ldd $INSTALL_DIR/postfix/bin/mailx

# create link to the log file
ln -sfv /var/log/mail.log $INSTALL_DIR/postfix/log/mail.log
ln -sfv /var/log/mail.err $INSTALL_DIR/postfix/log/mail.err

# database access
MAIL_DB_NAME="mail"
MAIL_DB_USER="mail"
MAIL_DB_PASS=`get_random_string 32`
mysql_add_user_password "$MAIL_DB_USER" "$MAIL_DB_PASS"
host4ge_conf_set_option "mail_db_name" "$MAIL_DB_NAME"
host4ge_conf_set_option "mail_db_user" "$MAIL_DB_USER"
host4ge_conf_set_option "mail_db_pass" "$MAIL_DB_PASS"

# generate certificate
generate_certificate "postfix"

# virtual-mailbox-domains.cf
cat <<EOF > $INSTALL_DIR/postfix/conf/virtual-mailbox-domains.cf
user = $MAIL_DB_USER
password = $MAIL_DB_PASS
hosts = unix:$INSTALL_DIR/$POSTFIX_MYSQL_NAME/log/mysql.sock
dbname = $MAIL_DB_NAME
query = SELECT 1 FROM domains WHERE name='%s'
EOF
# virtual-mailbox-users.cf
cat <<EOF > $INSTALL_DIR/postfix/conf/virtual-mailbox-maps.cf
user = $MAIL_DB_USER
password = $MAIL_DB_PASS
hosts = unix:$INSTALL_DIR/$POSTFIX_MYSQL_NAME/log/mysql.sock
dbname = $MAIL_DB_NAME
query = SELECT 1 FROM users WHERE email='%s'
EOF
# virtual-alias-maps.cf
cat <<EOF > $INSTALL_DIR/postfix/conf/virtual-alias-maps.cf
user = $MAIL_DB_USER
password = $MAIL_DB_PASS
hosts = unix:$INSTALL_DIR/$POSTFIX_MYSQL_NAME/log/mysql.sock
dbname = $MAIL_DB_NAME
query = SELECT destination FROM aliases WHERE source='%s'
EOF
# virtual-email-to-email.cf
cat <<EOF > $INSTALL_DIR/postfix/conf/virtual-email-to-email.cf
user = $MAIL_DB_USER
password = $MAIL_DB_PASS
hosts = unix:$INSTALL_DIR/$POSTFIX_MYSQL_NAME/log/mysql.sock
dbname = $MAIL_DB_NAME
query =  SELECT email FROM users WHERE email='%s'
EOF
# main.cf
cp $INSTALL_DIR/postfix/conf/main.cf $INSTALL_DIR/postfix/conf/main.cf.old
replace_in_file '#myhostname = virtual.domain.tld' "myhostname = $(hostname).$DOMAIN" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#mydomain = domain.tld' "mydomain = $(hostname).$DOMAIN" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#myorigin = $myhostname' "myorigin = $(hostname).$DOMAIN" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,' "mydestination = localhost" $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#mynetworks = 168.100.189.0\/28, 127.0.0.0\/8' 'mynetworks = 127.0.0.0\/8' $INSTALL_DIR/postfix/conf/main.cf
replace_in_file '#smtpd_banner = $myhostname ESMTP $mail_name ($mail_version)' 'smtpd_banner = $myhostname SMTP Server' $INSTALL_DIR/postfix/conf/main.cf
cat <<EOF >>  $INSTALL_DIR/postfix/conf/main.cf

##
## custom
##

message_size_limit = 30720000
alias_maps =
alias_database =
virtual_mailbox_base = $HOST4GE_DIR/var/mail
virtual_mailbox_domains = mysql:$INSTALL_DIR/postfix/conf/virtual-mailbox-domains.cf
virtual_mailbox_maps = mysql:$INSTALL_DIR/postfix/conf/virtual-mailbox-maps.cf
virtual_alias_maps = mysql:$INSTALL_DIR/postfix/conf/virtual-alias-maps.cf,mysql:$INSTALL_DIR/postfix/conf/virtual-email-to-email.cf
virtual_uid_maps = static:$VMAILID
virtual_gid_maps = static:$VMAILID
smtpd_recipient_restrictions = permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination
smtpd_use_tls = yes
smtpd_tls_cert_file = $CERTIFICATES_DIR/postfix.crt
smtpd_tls_key_file = $CERTIFICATES_DIR/postfix.key
EOF

if [ "$CHROOT" == "N" ]; then

    # get mysql root password
    MYSQL_ROOT_PASSWORD=`mysql_get_user_password root`
    # config database
    $INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysql.server start
    sleep 5
    cat <<EOF | $INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysql --user=root --password=$MYSQL_ROOT_PASSWORD
CREATE DATABASE $MAIL_DB_NAME;
GRANT SELECT, INSERT, UPDATE, DELETE ON $MAIL_DB_NAME.* TO '$MAIL_DB_USER'@'localhost' IDENTIFIED BY '$MAIL_DB_PASS';
USE $MAIL_DB_NAME;
CREATE TABLE domains (
    id int(11) NOT NULL auto_increment,
    name varchar(128) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE users (
    id int(11) NOT NULL auto_increment,
    domain_id int(11) NOT NULL,
    email varchar(128) NOT NULL,
    password varchar(256) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY email (email),
    FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE aliases (
    id int(11) NOT NULL auto_increment,
    domain_id int(11) NOT NULL,
    source varchar(128) NOT NULL,
    destination varchar(128) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
EOF
    sleep 1
    $INSTALL_DIR/$POSTFIX_MYSQL_NAME/bin/mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown
    sleep 3
    # clear password variable
    MYSQL_ROOT_PASSWORD=

fi

# set files permission
chown -R root:root $INSTALL_DIR/postfix
chmod 440 $INSTALL_DIR/postfix/conf/virtual-*.cf
chown root:postfix $INSTALL_DIR/postfix/conf/virtual-*.cf
chown -R postfix:postfix $INSTALL_DIR/postfix/{data,log}
chmod 700 $INSTALL_DIR/postfix/{data,log}
chown -R vmail:vmail $HOST4GE_DIR/var/mail
chmod 0700 $HOST4GE_DIR/var/mail
$INSTALL_DIR/postfix/bin/postfix set-permissions

##
## info
##

echo -e "\n\n *** Postfix check ***\n"
$INSTALL_DIR/postfix/bin/postfix check
echo -e "\n\n *** Postfix config ***\n"
$INSTALL_DIR/postfix/bin/postconf -n
echo -e "\n\n *** Postfix modules ***\n"
$INSTALL_DIR/postfix/bin/postconf -m

##
## post install
##

[ -f postfix-$POSTFIX_VERSION.tar.gz ] && rm postfix-$POSTFIX_VERSION.tar.gz
[ -f mailx.tar.gz ] && rm mailx-$MAILX_VERSION.tar.bz2
[ -f mailx-$MAILX_VERSION-openssl_1.0.0_build_fix-1.patch ] && rm mailx-$MAILX_VERSION-openssl_1.0.0_build_fix-1.patch
[ -d postfix-$POSTFIX_VERSION ] && rm -rf postfix-$POSTFIX_VERSION
[ -d mailx-$MAILX_VERSION ] && rm -rf mailx-$MAILX_VERSION

# log event
logger -p local0.notice -t host4ge "postfix $POSTFIX_VERSION installed successfully"

# save package version
package_add_version "postfix" "$POSTFIX_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/postfix/bin

exit 0
