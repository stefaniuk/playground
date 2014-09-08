#!/bin/bash

##
## variables
##

GEOIP_VERSION="1.4.8"
GEOIP_MOD_GEOIP_VERSION="1.2.5"
GEOIP_HTTPD_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--geoip)	shift
					GEOIP_HTTPD_NAME=$1
					;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/$GEOIP_HTTPD_NAME/bin/httpd ]; then
	echo "Error: GeoIP requires Apache HTTPD Server!"
	exit 1
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f geoip.tar.gz ]; then
	wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP-$GEOIP_VERSION.tar.gz -O geoip.tar.gz
fi
if [ ! -f geoip.tar.gz ]; then
	echo "Error: Unable to download geoip.tar.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f GeoIPLiteCity.dat.gz ]; then
	wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O GeoIPLiteCity.dat.gz
fi
if [ ! -f GeoIPLiteCity.dat.gz ]; then
	echo "Error: Unable to download GeoIPLiteCity.dat.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f mod_geoip.tar.gz ]; then
	wget http://geolite.maxmind.com/download/geoip/api/mod_geoip2/mod_geoip2_$GEOIP_MOD_GEOIP_VERSION.tar.gz -O mod_geoip.tar.gz
fi
if [ ! -f mod_geoip.tar.gz ]; then
	echo "Error: Unable to download mod_geoip.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing GeoIP:"
[ -d $INSTALL_DIR/geoip ] && rm -rf $INSTALL_DIR/geoip
tar -zxf geoip.tar.gz
cd GeoIP-$GEOIP_VERSION
./configure \
	--prefix=$INSTALL_DIR/geoip \
&& make && make install && echo "GeoIP installed successfully!"

# check
if [ ! -f $INSTALL_DIR/geoip/bin/geoiplookup ]; then
	echo "Error: GeoIP has NOT been installed successfully!"
	exit 1
fi

# directories' structure
rm -rf $INSTALL_DIR/geoip/share/man
cd ..

echo "Installing GeoIP database:"
cp -v GeoIPLiteCity.dat.gz $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat.gz
gunzip -d $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat.gz

# check
if [ ! -f $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat ]; then
	echo "Error: GeoIP database has NOT been installed successfully!"
	exit 1
fi

echo "Installing mod_geoip:"
tar -zxf mod_geoip.tar.gz
cd mod_geoip2_$GEOIP_MOD_GEOIP_VERSION
$INSTALL_DIR/$GEOIP_HTTPD_NAME/bin/apxs \
	-i -a -L$INSTALL_DIR/geoip/lib -I$INSTALL_DIR/geoip/include -lGeoIP -c mod_geoip.c \
&& echo "mod_geoip installed successfully!"
cd ..

# check
if [ ! -f $INSTALL_DIR/$GEOIP_HTTPD_NAME/modules/mod_geoip.so ]; then
	echo "Error: mod_geoip has NOT been installed successfully!"
	exit 1
fi

##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/geoip/bin
strip_debug_symbols $INSTALL_DIR/geoip/lib
strip_debug_symbols_file $INSTALL_DIR/$GEOIP_HTTPD_NAME/modules/mod_geoip.so

echo "Shared library dependencies for $INSTALL_DIR/geoip/bin/geoiplookup:"
ldd $INSTALL_DIR/geoip/bin/geoiplookup

echo "Shared library dependencies for $INSTALL_DIR/$GEOIP_HTTPD_NAME/modules/mod_geoip.so:"
ldd $INSTALL_DIR/$GEOIP_HTTPD_NAME/modules/mod_geoip.so

# httpd.conf
replace_in_file 'LoadModule geoip_module       modules\/mod_geoip.so' 'LoadModule geoip_module modules\/mod_geoip.so' $INSTALL_DIR/$GEOIP_HTTPD_NAME/conf/httpd.conf
(	echo -e "\n<IfModule mod_geoip.c>" && \
	echo -e "\tGeoIPEnable On" && \
	echo -e "\tGeoIPEnableUTF8 On" && \
	echo -e "\tGeoIPDBFile $INSTALL_DIR/geoip/share/GeoIP/GeoIPLiteCity.dat" && \
	echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE CN BlockCountry" && \
	echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE RU BlockCountry" && \
	echo -e "\t<Location \"/\">" && \
	echo -e "\t\tDeny from env=BlockCountry" && \
	echo -e "\t</Location>" && \
	echo -e "</IfModule>" \
) >> $INSTALL_DIR/$GEOIP_HTTPD_NAME/conf/httpd.conf

# geoip.php
cat <<EOF > $INSTALL_DIR/$GEOIP_HTTPD_NAME/htdocs/geoip.php
Continent Code: <?php echo apache_note('GEOIP_CONTINENT_CODE'); ?><br />
Country Code: <?php echo apache_note('GEOIP_COUNTRY_CODE'); ?><br />
Country: <?php echo apache_note('GEOIP_COUNTRY_NAME'); ?><br />
Region: <?php echo apache_note('GEOIP_REGION_NAME'); ?><br />
City: <?php echo apache_note('GEOIP_CITY'); ?><br />
Latitude: <?php echo apache_note('GEOIP_LATITUDE'); ?><br />
Longitude: <?php echo apache_note('GEOIP_LONGITUDE'); ?><br />
EOF

# set files permission
chown -R root:root $INSTALL_DIR/geoip
chmod 555 $INSTALL_DIR/geoip/bin
chmod 555 $INSTALL_DIR/geoip/bin/*
chown -R root:root $INSTALL_DIR/$GEOIP_HTTPD_NAME/modules/mod_geoip.so
chmod 500 $INSTALL_DIR/$GEOIP_HTTPD_NAME/modules/mod_geoip.so

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f geoip.tar.gz ] && rm geoip.tar.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f GeoIPLiteCity.dat.gz ] && rm GeoIPLiteCity.dat.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f mod_geoip.tar.gz ] && rm mod_geoip.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d GeoIP-$GEOIP_VERSION ] && rm -rf GeoIP-$GEOIP_VERSION
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d mod_geoip2_$GEOIP_MOD_GEOIP_VERSION ] && rm -rf mod_geoip2_$GEOIP_MOD_GEOIP_VERSION
