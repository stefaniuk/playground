#!/bin/bash
#
# usage: ./config_dev_env.sh 2>&1 | tee config_dev_env.out

###
### download
###
function download {

	if [ ! -f gnome-terminal.xml ]; then
		wget http://my-hatchery.googlecode.com/svn/trunk/linux/scripts/gnome-terminal.xml
	fi

}

###
### install
###
function install {

	# apt-get
	apt-get -y install \
	build-essential autoconf automake \
	cvs subversion git-core mercurial bzr \
	mysql-common mysql-client mysql-server \
	apache2 apache2-mpm-prefork \
	php5 php5-common php5-cli php-pear php5-mysql php5-xdebug php-apc php5-memcached libapache2-mod-php5 \
	openjdk-6-jre openjdk-6-jdk tomcat6 tomcat6-common ant maven2 \
	krusader emacs \
	gimp
	#libctemplate0 liblua5.1-0 libzip1 python-pysqlite2 mysql-workbench-gpl

	a2enmod rewrite
	
	# dropbox
	# vmware tools
	#tar -zxf VMwareTools-7.7.5-156745.tar.gz
	#cd vmware-tools-distrib
	#./vmware-install.pl
	#cd ..

}

###
### config
###
function config {

	# gnome-terminal
	gconftool --load gnome-terminal.xml

}

###
### main
###

echo Script started on $(date)

echo -e "\n"
du -h $INSTALL_DIR
echo -e "\n\n"

apt-get update && apt-get -y upgrade && download && install && config

echo -e "\n\n"
du -h $INSTALL_DIR
echo -e "\n"

echo Script ended on $(date)
