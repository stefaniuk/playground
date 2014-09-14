#!/bin/bash

##
## download
##

PKG_NAME="openssh-$OPENSSH_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://www.mirrorservice.org/sites/ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$OPENSSH_VERSION.tar.gz"
    FILE=openssh-$OPENSSH_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 1000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

# add jail group
groupadd -g 10000 sshjail

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile OpenSSH:"
    [ -d $INSTALL_DIR/openssh ] && rm -rf $INSTALL_DIR/openssh
    tar -zxf openssh-$OPENSSH_VERSION.tar.gz
    cd openssh-$OPENSSH_VERSION
    ./configure \
        --prefix=$INSTALL_DIR/openssh \
        --bindir=$INSTALL_DIR/openssh/bin \
        --sbindir=$INSTALL_DIR/openssh/bin \
        --libexecdir=$INSTALL_DIR/openssh/bin \
        --sysconfdir=$INSTALL_DIR/openssh/conf \
        --without-openssl-header-check \
    && make && make install && echo "OpenSSH installed successfully!" \
    && rm -rf $INSTALL_DIR/openssh/share
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/openssh/bin
    echo "Create package:"
    package_create $INSTALL_DIR/openssh $PKG_NAME
else
    echo "Install OpenSSH from package:"
    package_restore $PKG_NAME
fi

# check
if [ ! -f $INSTALL_DIR/openssh/bin/sshd ]; then
	echo "Error: OpenSSH has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/openssh/bin/sshd:"
ldd $INSTALL_DIR/openssh/bin/sshd

# bin/ssh-agent-start
cat <<EOF > $INSTALL_DIR/openssh/bin/ssh-agent-start
#!/bin/bash

PID=\`ps ax | grep "\$INSTALL_DIR/openssh/bin/ssh-agent$" | grep -v grep | cut -c1-5 | paste -s -\`
if [ ! "\$PID" ]; then
    \$INSTALL_DIR/openssh/bin/ssh-agent | sed 's/^echo/#echo/' > \$SSH_ENV
    chmod 400 \$SSH_ENV
    . \$SSH_ENV > /dev/null
    \$INSTALL_DIR/openssh/bin/ssh-add
fi

exit 0
EOF

# SEE: http://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html

# set files permission
mkdir -p /root/.ssh/keys
chown -R root:root $INSTALL_DIR/openssh
chmod 555 $INSTALL_DIR/openssh/bin/ssh-agent-start
chmod 700 /root/.ssh{,/keys}

# configure the other instance
replace_in_file "Port 2200" "Port 22" /etc/ssh/sshd_config
replace_in_file "Port 22" "Port 2200" /etc/ssh/sshd_config
replace_in_file "Subsystem sftp \/usr\/lib\/openssh\/sftp-server" "Subsystem sftp internal-sftp \/usr\/lib\/openssh\/sftp-server" /etc/ssh/sshd_config
if [ "`file_contains sshjail /etc/ssh/sshd_config`" == "no" ]; then
    (   echo -e "\nMatch group sshjail" && \
        echo -e "\tChrootDirectory %h" && \
        echo -e "\tX11Forwarding no" && \
        echo -e "\tAllowTcpForwarding no" && \
        echo -e "\tForceCommand internal-sftp" \
    ) >> /etc/ssh/sshd_config
fi

##
## post install
##

[ -f openssh-$OPENSSH_VERSION.tar.gz ] && rm openssh-$OPENSSH_VERSION.tar.gz
[ -d openssh-$OPENSSH_VERSION ] && rm -rf openssh-$OPENSSH_VERSION

# log event
logger -p local0.notice -t host4ge "openssh $OPENSSH_VERSION installed successfully"

# save package version
package_add_version "openssh" "$OPENSSH_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/openssh/bin

exit 0
