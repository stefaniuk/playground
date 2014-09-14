#!/bin/bash

##
## variables
##

MOD_GEOIP_HTTPD_NAME=

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --mod-geoip)    shift && MOD_GEOIP_HTTPD_NAME=$1
                        ;;
    esac
    shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/geoip/bin/geoiplookup ]; then
    echo "Error: mod_geoip requires GeoIP!"
    exit 1
fi

if [ ! -f $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/bin/httpd ]; then
    echo "Error: mod_geoip requires Apache HTTPD Server!"
    exit 1
fi

##
## download
##

PKG_NAME="mod_geoip-$MOD_GEOIP_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://geolite.maxmind.com/download/geoip/api/mod_geoip2/mod_geoip2_$MOD_GEOIP_VERSION.tar.gz"
    FILE=mod_geoip2_$MOD_GEOIP_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 10000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

if [ "$PKG_RESULT" != "success" ]; then
    echo "Compile mod_geoip:"
    tar -zxf mod_geoip2_$MOD_GEOIP_VERSION.tar.gz
    cd mod_geoip2_$MOD_GEOIP_VERSION
    # This is a patch due to the Apache HTTPD API changes, see http://httpd.apache.org/docs/2.3/developer/new_api_2_4.html
    replace_in_file 'r->connection->remote_ip' 'r->connection->client_ip' ./mod_geoip.c
    $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/bin/apxs \
        -i -a -L$INSTALL_DIR/geoip/lib -I$INSTALL_DIR/geoip/include -lGeoIP -c mod_geoip.c \
    && echo "mod_geoip installed successfully!"
    cd ..
    echo "Strip symbols:"
    strip_debug_symbols_file $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules/mod_geoip.so
    echo "Create package:"
    package_create_files $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules $PKG_NAME mod_geoip.so
else
    echo "Install mod_geoip from package:"
    package_restore_files $PKG_NAME $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules
fi

# check
if [ ! -f $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules/mod_geoip.so ]; then
    echo "Error: mod_geoip has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules/mod_geoip.so:"
ldd $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules/mod_geoip.so

# httpd.conf
if [ "$PKG_RESULT" == "success" ]; then
    replace_in_file '# end of modules' 'LoadModule geoip_module modules\/mod_geoip.so\n# end of modules' $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/conf/httpd.conf
else
    replace_in_file 'LoadModule geoip_module[ \t]*modules\/mod_geoip.so' 'LoadModule geoip_module modules\/mod_geoip.so' $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/conf/httpd.conf
fi
(   echo -e "\n<IfModule mod_geoip.c>" && \
    echo -e "\tGeoIPEnable On" && \
    echo -e "\tGeoIPEnableUTF8 On" && \
    echo -e "\tGeoIPDBFile $INSTALL_DIR/geoip/share/GeoIP/GeoIPCity.dat" && \
    echo -e "\t# ISO 3166 Country Codes - http://www.maxmind.com/app/iso3166" && \
    echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE CN BlockCountry" && \
    echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE IL BlockCountry" && \
    echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE RU BlockCountry" && \
    echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE SY BlockCountry" && \
    echo -e "\tSetEnvIf GEOIP_COUNTRY_CODE TR BlockCountry" && \
    echo -e "\t<Location \"/\">" && \
    echo -e "\t\tDeny from env=BlockCountry" && \
    echo -e "\t</Location>" && \
    echo -e "</IfModule>" \
) >> $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/conf/httpd.conf

# geoip.php
cat <<EOF > $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/htdocs/geoip.php
Continent Code: <?php echo apache_note('GEOIP_CONTINENT_CODE'); ?><br />
Country Code: <?php echo apache_note('GEOIP_COUNTRY_CODE'); ?><br />
Country: <?php echo apache_note('GEOIP_COUNTRY_NAME'); ?><br />
Region: <?php echo apache_note('GEOIP_REGION_NAME'); ?><br />
City: <?php echo apache_note('GEOIP_CITY'); ?><br />
Latitude: <?php echo apache_note('GEOIP_LATITUDE'); ?><br />
Longitude: <?php echo apache_note('GEOIP_LONGITUDE'); ?><br />
EOF

# set files permission
chown -R root:root $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules/mod_geoip.so
chmod 755 $INSTALL_DIR/$MOD_GEOIP_HTTPD_NAME/modules/mod_geoip.so

##
## post install
##

[ -f mod_geoip2_$MOD_GEOIP_VERSION.tar.gz ] && rm mod_geoip2_$MOD_GEOIP_VERSION.tar.gz
[ -d mod_geoip2_$MOD_GEOIP_VERSION ] && rm -rf mod_geoip2_$MOD_GEOIP_VERSION

# log event
logger -p local0.notice -t host4ge "mod-geoip $MOD_GEOIP_VERSION installed successfully"

# save package version
package_add_version "mod-geoip" "$MOD_GEOIP_VERSION"

exit 0
