#!/bin/bash

##
## vaiables
##

OPENVPN_KEY_SIZE=4096

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/lzo/lib/liblzo2.a ]; then
    echo "Error: OpenVPN requires lzo!"
    exit 1
fi

##
## download
##

PKG_NAME="openvpn-$OPENVPN_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://swupdate.openvpn.org/community/releases/openvpn-$OPENVPN_VERSION.tar.gz"
    FILE=openvpn-$OPENVPN_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 500000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile OpenVPN:"
    [ -d $INSTALL_DIR/openvpn ] && rm -rf $INSTALL_DIR/openvpn
    tar -zxf openvpn-$OPENVPN_VERSION.tar.gz
    cd openvpn-$OPENVPN_VERSION
    replace_in_file '#define LOG_OPENVPN LOG_DAEMON' '#define LOG_OPENVPN LOG_LOCAL1' ./error.c
    ./configure \
        --prefix=$INSTALL_DIR/openvpn \
        --sbindir=$INSTALL_DIR/openvpn/bin \
    && make && make install && echo "OpenVPN installed successfully!" \
    && rm -rf $INSTALL_DIR/openvpn/share \
    && mkdir -p $INSTALL_DIR/openvpn/{bin,clients,conf,keys,log} \
    && cp ./easy-rsa/2.0/* $INSTALL_DIR/openvpn/bin \
    && cp ./sample-config-files/* $INSTALL_DIR/openvpn/conf \
    && ln -s $INSTALL_DIR/openvpn/bin/openssl-1.0.0.cnf $INSTALL_DIR/openvpn/bin/openssl.cnf
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/openvpn/bin
    echo "Create package:"
    package_create $INSTALL_DIR/openvpn $PKG_NAME
else
    echo "Install OpenVPN from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/openvpn/bin/openvpn ]; then
	echo "Error: OpenVPN has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/openvpn/bin/openvpn:"
ldd $INSTALL_DIR/openvpn/bin/openvpn

# create user and group
user_create "vpn" 605 "vpn" 605 --shell /bin/bash

# vars
cat <<EOF > $INSTALL_DIR/openvpn/bin/vars
export EASY_RSA=\`pwd\`
export OPENSSL=$CMD_OPENSSL
export PKCS11TOOL="pkcs11-tool"
export KEY_CONFIG=\`\$EASY_RSA/whichopensslcnf \$EASY_RSA\`
export KEY_DIR=$INSTALL_DIR/openvpn/keys
export PKCS11_MODULE_PATH="none"
export PKCS11_PIN="none"
export KEY_SIZE=$OPENVPN_KEY_SIZE
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY="GB"
export KEY_PROVINCE=
export KEY_CITY=
export KEY_ORG="$COMMON_NAME"
export KEY_EMAIL="admin@$DOMAIN"
EOF

# build-ca-wrapper
cat <<EOF > $INSTALL_DIR/openvpn/bin/build-ca-wrapper
#!/bin/bash
#
#   ./build-ca-wrapper
#
# \$1 = Country Name (2 letter code)
# \$2 = State or Province Name (full name)
# \$3 = Locality Name (eg, city)
# \$4 = Organization Name (eg, company)
# \$5 = Organizational Unit Name (eg, section)
# \$6 = Common Name (eg, your name or your server's hostname)
# \$7 = Name
# \$8 = Email Address

cd $INSTALL_DIR/openvpn/bin
./clean-all
umask 077; echo "\$1
\$2
\$3
\$4
\$5
\$6
\$7
\$7
\$8" | KEY_SIZE=$OPENVPN_KEY_SIZE ./build-ca --pass
EOF

# proxyarp-connect.sh
cat <<EOF > $INSTALL_DIR/openvpn/bin/proxyarp-connect.sh
#!/bin/bash
/usr/sbin/arp -i eth0 -Ds \$ifconfig_pool_remote_ip eth0 pub
EOF

# proxyarp-disconnect.sh
cat <<EOF > $INSTALL_DIR/openvpn/bin/proxyarp-disconnect.sh
#!/bin/bash
/usr/sbin/arp -i eth0 -d \$ifconfig_pool_remote_ip
EOF

# openvpn-default.conf
if [[ "$SERVER_ROLE" == *admin* ]]; then

cat <<EOF > $INSTALL_DIR/openvpn/conf/openvpn-default.conf
dev tun
proto $VPN_SERVER_PROTOCOL
lport $VPN_SERVER_PORT
rport $VPN_SERVER_PORT

server $VPN_NETWORK $VPN_NETMASK
client-to-client
topology subnet

user vpn
group vpn
persist-tun
persist-key
keepalive 10 60
ping-timer-rem
comp-lzo
script-security 2
;client-connect $INSTALL_DIR/openvpn/bin/proxyarp-connect.sh
;client-disconnect $INSTALL_DIR/openvpn/bin/proxyarp-disconnect.sh

ca $INSTALL_DIR/openvpn/keys/ca.crt
cert $INSTALL_DIR/openvpn/keys/$(hostname).crt
key $INSTALL_DIR/openvpn/keys/$(hostname).key
dh $INSTALL_DIR/openvpn/keys/dh${OPENVPN_KEY_SIZE}.pem
tls-auth $INSTALL_DIR/openvpn/keys/ta.key 0

client-config-dir $INSTALL_DIR/openvpn/clients

daemon openvpn
verb 3
;log-append $INSTALL_DIR/openvpn/log/openvpn.log
status $INSTALL_DIR/openvpn/log/openvpn.status 15
ifconfig-pool-persist $INSTALL_DIR/openvpn/log/openvpn.pool 15
EOF

else

cat <<EOF > $INSTALL_DIR/openvpn/conf/openvpn-default.conf
dev tun
proto $VPN_SERVER_PROTOCOL
port $VPN_SERVER_PORT

client
remote $VPN_SERVER_FQDN
nobind

user vpn
group vpn
persist-tun
persist-key
keepalive 10 60
ping-timer-rem
comp-lzo
script-security 2

ca /srv/openvpn/keys/ca.crt
cert /srv/openvpn/keys/$(hostname).crt
key /srv/openvpn/keys/$(hostname).key
tls-auth /srv/openvpn/keys/ta.key 1
ns-cert-type server
remote-cert-tls server

daemon openvpn
verb 3
;log-append $INSTALL_DIR/openvpn/log/openvpn.log
status $INSTALL_DIR/openvpn/log/openvpn.status 15
EOF

fi

# test configuration
if [[ "$IP_ADDRESS" == 192.168.* ]] && [[ "$SERVER_ROLE" == *test* ]]; then
    if [ "`server_has_role admin`" == "yes" ]; then
        echo "ifconfig-push $VPN_IP_POOL.2 $VPN_NETMASK" > $INSTALL_DIR/openvpn/clients/host4ge-test2
        echo "ifconfig-push $VPN_IP_POOL.3 $VPN_NETMASK" > $INSTALL_DIR/openvpn/clients/host4ge-test3
        cp $HOST4GE_DIR/install/packages/openvpn/dh*.pem $INSTALL_DIR/openvpn/keys
    fi
    cp $HOST4GE_DIR/install/packages/openvpn/{ca.crt,$(hostname).{crt,key},ta.key} $INSTALL_DIR/openvpn/keys
fi

# update /etc/sudoers
# vpn ALL=NOPASSWD: /usr/sbin/arp

# set files permission
chown -R root:root $INSTALL_DIR/openvpn
chown -R vpn:vpn $INSTALL_DIR/openvpn/clients
chmod 700 $INSTALL_DIR/openvpn/*
chmod 500 $INSTALL_DIR/openvpn/bin/*
chmod 400 $INSTALL_DIR/openvpn/bin/{Makefile,README}
chmod 400 $INSTALL_DIR/openvpn/clients/* > /dev/null 2>&1
chmod 400 $INSTALL_DIR/openvpn/keys/*.{crt,key,pem} > /dev/null 2>&1

##
## post install
##

[ -f openvpn-$OPENVPN_VERSION.tar.gz ] && rm openvpn-$OPENVPN_VERSION.tar.gz
[ -d openvpn-$OPENVPN_VERSION ] && rm -rf openvpn-$OPENVPN_VERSION

# log event
logger -p local0.notice -t host4ge "openvpn $OPENVPN_VERSION installed successfully"

# save package version
package_add_version "openvpn" "$OPENVPN_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/openvpn/bin

exit 0

:<<comment

A list of commands needed to setup VPN:
=======================================

cd /srv/openvpn/bin
. ./vars
./build-ca-wrapper "$LOCATION" "." "." "$COMMON_NAME" "." "$COMMON_NAME CA" "." "admin@$DOMAIN"
./build-key-server --batch $(hostname) # server
./build-key --batch $(hostname) # client
./build-dh
openvpn --genkey --secret /srv/openvpn/keys/ta.key
openssl x509 -subject -noout -in $(hostname).crt

comment
