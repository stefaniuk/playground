#!/bin/bash

COUNTRY=$(echo $LOCATION | tr '[:upper:]' '[:lower:]')

# remove unwanted packages
pkill apache
pkill sendmail
dpkg --get-selections | \
    awk '{ print $1 }' | \
    egrep -i "apache|portmap|sendmail|sysklogd" | \
    xargs apt-get --purge -y remove

# /etc/apt/sources.list
[ ! -f /etc/apt/sources.list.old ] && cp /etc/apt/sources.list /etc/apt/sources.list.old
if [ "$CODENAME" == "lucid" ]; then
    cat <<EOF > /etc/apt/sources.list
## main & restricted repositories
deb http://${COUNTRY}.archive.ubuntu.com/ubuntu/ ${CODENAME} main restricted
deb-src http://${COUNTRY}.archive.ubuntu.com/ubuntu/ ${CODENAME} main restricted

deb http://security.ubuntu.com/ubuntu ${CODENAME}-updates main restricted
deb-src http://security.ubuntu.com/ubuntu ${CODENAME}-updates main restricted

deb http://security.ubuntu.com/ubuntu ${CODENAME}-security main restricted
deb-src http://security.ubuntu.com/ubuntu ${CODENAME}-security main restricted

## universe repositories - uncomment to enable
deb http://${COUNTRY}.archive.ubuntu.com/ubuntu/ ${CODENAME} universe
deb-src http://${COUNTRY}.archive.ubuntu.com/ubuntu/ ${CODENAME} universe

deb http://${COUNTRY}.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates universe
deb-src http://${COUNTRY}.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates universe

deb http://security.ubuntu.com/ubuntu ${CODENAME}-security universe
deb-src http://security.ubuntu.com/ubuntu ${CODENAME}-security universe

## partner repositories
deb http://archive.canonical.com/ubuntu ${CODENAME} partner
deb-src http://archive.canonical.com/ubuntu ${CODENAME} partner

deb http://archive.canonical.com/ubuntu ${CODENAME}-updates partner
deb-src http://archive.canonical.com/ubuntu ${CODENAME}-updates partner

deb http://archive.canonical.com/ubuntu ${CODENAME}-security partner
deb-src http://archive.canonical.com/ubuntu ${CODENAME}-security partner
EOF
elif [ "$CODENAME" == "precise" ]; then
    cat <<EOF > /etc/apt/sources.list
deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME} main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME} main restricted

deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates main restricted

deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME} universe
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME} universe
deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates universe

deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME} multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME} multiverse
deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-updates multiverse

deb http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-backports main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ ${CODENAME}-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu ${CODENAME}-security main restricted
deb-src http://security.ubuntu.com/ubuntu ${CODENAME}-security main restricted
deb http://security.ubuntu.com/ubuntu ${CODENAME}-security universe
deb-src http://security.ubuntu.com/ubuntu ${CODENAME}-security universe
deb http://security.ubuntu.com/ubuntu ${CODENAME}-security multiverse
deb-src http://security.ubuntu.com/ubuntu ${CODENAME}-security multiverse
EOF
fi

# download cached apt archives to speed up the installation process
if [ "$DO_NOT_USE_CACHED_UPDATES" == "N" ]; then
    RESULT=$(file_download --cache-dir-name updates --file $CODENAME.tar.gz --do-not-cache)
    if [ "$RESULT" == "success" ]; then
        mv $CODENAME.tar.gz /var/cache/apt/archives
        cd /var/cache/apt/archives
        tar -zxf $CODENAME.tar.gz
        rm $CODENAME.tar.gz
    fi
fi

# exclude packages from updates (to remove exclusion use 'echo package install | dpkg --set-selections')
(   echo bind9 hold
    echo mysql-common hold
    echo postfix hold
) | dpkg --set-selections

# apt-get update and install
export DEBIAN_FRONTEND="noninteractive"
apt-get --yes update
apt-get -y --force-yes upgrade
if [ "$CODENAME" == "lucid" ]; then
    apt-get -y --ignore-missing --no-install-recommends install \
        apt-file \
        autoconf \
        automake \
        bison \
        bridge-utils \
        build-essential \
        cmake \
        debootstrap \
        dsniff \
        expect \
        fakeroot \
        gawk \
        gettext \
        kernel-package \
        libbz2-dev \
        libcap-dev \
        libcap2-bin \
        libcurl4-openssl-dev \
        libdb-dev \
        libexpat1-dev \
        libfreetype6 \
        libfreetype6-dev \
        libjpeg62-dev \
        liblua5.1-0-dev \
        liblua50-dev \
        liblualib50-dev \
        libmcrypt-dev \
        libmhash-dev \
        libncurses5-dev \
        libpcre3-dev \
        libpng12-dev \
        libsqlite0-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwrap0-dev \
        libxml2-dev \
        lshw \
        lsof \
        mkpasswd \
        nmap \
        pkg-config \
        qemu-kvm \
        re2c \
        rsync \
        samba \
        schroot \
        sqlite3 \
        strace \
        subversion \
        sysstat \
        tcpdump \
        traceroute \
        update-manager-core \
        vlan \
        whois
elif [ "$CODENAME" == "precise" ]; then
    apt-get -y --ignore-missing --no-install-recommends install \
        apt-file \
        autoconf \
        automake \
        bison \
        build-essential \
        cmake \
        expect \
        fakeroot \
        gawk \
        gettext \
        kernel-package \
        libbz2-dev \
        libcap-dev \
        libcap2-bin \
        libcurl4-openssl-dev \
        libdb-dev \
        libexpat1-dev \
        libfreetype6 \
        libfreetype6-dev \
        libjpeg62-dev \
        liblua5.1-0-dev \
        liblua50-dev \
        liblualib50-dev \
        libmcrypt-dev \
        libmhash-dev \
        libncurses5-dev \
        libpcre3-dev \
        libpng12-dev \
        libsqlite0-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwrap0-dev \
        libxml2-dev \
        lshw \
        lsof \
        nmap \
        pkg-config \
        re2c \
        rsync \
        schroot \
        sqlite3 \
        strace \
        subversion \
        sysstat \
        tcpdump \
        traceroute \
        update-manager-core \
        whois
fi
apt-get autoremove
apt-get autoclean
apt-file update

# virtualisation packages
# bridge-utils btrfs-tools cgroup-lite debootstrap dnsmasq dsniff libvirt-bin lvm2 lxc qemu-kvm qemu-user-static samba vlan

# fix libraries
if [ "$CODENAME" == "lucid" ]; then
    ln -sfv /usr/lib/libexpat.so /usr/lib/libexpat.so.0
    ln -sfv /usr/lib/libjpeg.so.62 /usr/lib/libjpeg.so
elif [ "$CODENAME" == "precise" ]; then
    # libnsl
    ln -sfv /lib/x86_64-linux-gnu/libnsl* /lib/
    ln -sfv /usr/lib/x86_64-linux-gnu/libnsl* /usr/lib/
    # libssl & libcrypto
    ln -sfv /lib/x86_64-linux-gnu/libssl* /lib/
    ln -sfv /lib/x86_64-linux-gnu/libcrypto* /lib/
    ln -sfv /usr/lib/x86_64-linux-gnu/libssl* /usr/lib/
    ln -sfv /usr/lib/x86_64-linux-gnu/libcrypto* /usr/lib/
fi

(
    echo " === libssl ==="
    echo "     /lib/x86_64-linux-gnu/libssl*"
    ls -la /lib/x86_64-linux-gnu/libssl*
    echo "     /lib/libssl*"
    ls -la /lib/libssl*
    echo "     /usr/lib/x86_64-linux-gnu/libssl*"
    ls -la /usr/lib/x86_64-linux-gnu/libssl*
    echo "     /usr/lib/libssl*"
    ls -la /usr/lib/libssl*
)

(
    echo " === libcrypto ==="
    echo "     /lib/x86_64-linux-gnu/libcrypto*"
    ls -la /lib/x86_64-linux-gnu/libcrypto*
    echo "     /lib/libcrypto*"
    ls -la /lib/libcrypto*
    echo "     /usr/lib/x86_64-linux-gnu/libcrypto*"
    ls -la /usr/lib/x86_64-linux-gnu/libcrypto*
    echo "     /usr/lib/libcrypto*"
    ls -la /usr/lib/libcrypto*
)

exit 0
