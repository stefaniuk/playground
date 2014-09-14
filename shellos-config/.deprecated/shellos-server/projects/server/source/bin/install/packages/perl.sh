#!/bin/bash

# search for modules: apt-file search Dir/Module.pm

# exclude packages from updates (to remove exclusion use 'echo package install | dpkg --set-selections')
(   echo bind9 hold
    echo mysql-common hold
    echo postfix hold
) | dpkg --set-selections

# install perl
apt-get -y --ignore-missing --no-install-recommends install perl

# download and extract perl modules
cd ~
apt-get download  \
    libconfig-auto-perl \
    libconfig-inifiles-perl \
    libdbd-mysql-perl \
    libdbi-perl \
    libfile-slurp-perl \
    libtime-format-perl
for FILE in $(ls -1 *.deb); do
    dpkg -x $FILE ~/packages/
done
cp -vfR ~/packages/usr/lib/perl5/* /usr/lib/perl5
cp -vfR ~/packages/usr/share/perl5/* /usr/share/perl5
rm -rf ~/packages
mv *.deb /var/cache/apt/archives

exit 0
