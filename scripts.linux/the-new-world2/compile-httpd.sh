#!/bin/bash

##
## variables
##

HTTPD_VERSION="2.3.13-beta"
HTTPD_MOD_FCGID_VERSION="2.3.6"
HTTPD_NAME=
HTTPD_PORT=
HTTPD_PORT_SSL=
HTTPD_USER=
HTTPD_GROUP=
HTTPD_CONFIGURE_OPTIONS="--with-included-apr"

##
## parse arguments
##

while [ "$1" != "" ]; do
	case $1 in
		--httpd)	shift
					HTTPD_NAME=$1
					shift
					HTTPD_PORT=$1
					shift
					HTTPD_PORT_SSL=$1
					shift
					HTTPD_USER=$1
					shift
					HTTPD_GROUP=$1
					;;
	esac
	shift
done

##
## check dependencies
##

if [ ! -f $INSTALL_DIR/zlib/lib/libz.so ]; then
	echo "Error: Apache HTTPD Server requires zlib!"
	exit 1
fi
if [ ! -f $INSTALL_DIR/openssl/bin/openssl ]; then
	echo "Error: Apache HTTPD Server requires OpenSSL!"
	exit 1
fi
# optional
if [ -f $INSTALL_DIR/apr/bin/apr-1-config ]; then
	HTTPD_CONFIGURE_OPTIONS="--with-apr=$INSTALL_DIR/apr"
fi
if [ -f $INSTALL_DIR/apr/bin/apu-1-config ]; then
	HTTPD_CONFIGURE_OPTIONS="$HTTPD_CONFIGURE_OPTIONS --with-apr-util=$INSTALL_DIR/apr"
fi

##
## download
##

if [ "$DOWNLOAD" = "Y" ] && [ ! -f httpd.tar.gz ]; then
	wget http://httpd.apache.org/dev/dist/httpd-$HTTPD_VERSION.tar.gz -O httpd.tar.gz
fi
if [ ! -f httpd.tar.gz ]; then
	echo "Error: Unable to download httpd.tar.gz file!"
	exit 1
fi
if [ "$DOWNLOAD" = "Y" ] && [ ! -f mod_fcgid.tar.gz ]; then
	wget http://ftp.tpnet.pl/vol/d1/apache//httpd/mod_fcgid/mod_fcgid-$HTTPD_MOD_FCGID_VERSION.tar.gz -O mod_fcgid.tar.gz
fi
if [ ! -f mod_fcgid.tar.gz ]; then
	echo "Error: Unable to download mod_fcgid.tar.gz file!"
	exit 1
fi

##
## install
##

echo "Installing Apache HTTPD Server:"
pkill httpd
[ -d $INSTALL_DIR/$HTTPD_NAME ] && rm -rf $INSTALL_DIR/$HTTPD_NAME
tar -zxf httpd.tar.gz
cd httpd-$HTTPD_VERSION
replace_in_file '#define AP_SERVER_BASEPRODUCT "Apache"' '#define AP_SERVER_BASEPRODUCT "Host4ge WWW Server"' ./include/ap_release.h
./configure \
	--prefix=$INSTALL_DIR/$HTTPD_NAME \
	--with-mpm=worker \
	--enable-mpms-shared='prefork worker' \
	--enable-mods-shared=all \
	--disable-cgi \
	--disable-cgid \
	--enable-fcgid \
	--enable-proxy \
	--enable-suexec \
	--with-suexec-bin=$INSTALL_DIR/$HTTPD_NAME/bin/suexec \
	--with-suexec-caller=$HTTPD_USER \
	--with-suexec-uidmin=10001 \
	--with-suexec-gidmin=10001 \
	--with-suexec-docroot="$INSTALL_DIR/accounts" \
	--with-suexec-userdir="public" \
	--with-suexec-logfile=$INSTALL_DIR/$HTTPD_NAME/log/suexec.log \
	--with-suexec-safepath="/usr/local/bin:/usr/bin:/bin" \
	--enable-so \
	--enable-ssl \
	--with-ssl=$INSTALL_DIR/openssl \
	--with-z=$INSTALL_DIR/zlib \
	$HTTPD_CONFIGURE_OPTIONS \
&& make && make install && echo "Apache HTTPD Server installed successfully!" \
&& rm -rf $INSTALL_DIR/$HTTPD_NAME/{conf/extra,logs,man,manual} \
&& mkdir $INSTALL_DIR/$HTTPD_NAME/{conf/vhosts,log} \
&& mkdir $INSTALL_DIR/accounts
cd ..

# TODO: http://bash.cyberciti.biz/

# check
if [ ! -f $INSTALL_DIR/$HTTPD_NAME/bin/httpd ]; then
	echo "Error: Apache HTTPD Server has NOT been installed successfully!"
	exit 1
fi

echo "Installing Apache HTTPD mod_fcgid:"
tar -zxf mod_fcgid.tar.gz
cd mod_fcgid-$HTTPD_MOD_FCGID_VERSION
APXS=$INSTALL_DIR/$HTTPD_NAME/bin/apxs ./configure.apxs \
&& make && make install && echo "Apache HTTPD mod_fcgid installed successfully!" \
&& rm $INSTALL_DIR/$HTTPD_NAME/conf/httpd.conf.bak
cd ..

# check
if [ ! -f $INSTALL_DIR/$HTTPD_NAME/modules/mod_fcgid.so ]; then
	echo "Error: Apache HTTPD mod_fcgid has NOT been installed successfully!"
	exit 1
fi


##
## configure
##

echo "Strip symbols:"
strip_debug_symbols $INSTALL_DIR/$HTTPD_NAME/bin
strip_debug_symbols $INSTALL_DIR/$HTTPD_NAME/modules

echo "Shared library dependencies for $INSTALL_DIR/$HTTPD_NAME/bin/httpd:"
ldd $INSTALL_DIR/$HTTPD_NAME/bin/httpd

# create links to the log files
ln -sfv /var/log/httpd.log $INSTALL_DIR/$HTTPD_NAME/log/httpd.log
ln -sfv /var/log/httpd.err $INSTALL_DIR/$HTTPD_NAME/log/httpd.err

# copy script that will pipe logs to the syslog
cp -v $INSTALL_DIR/conf/log-apache.pl $INSTALL_DIR/$HTTPD_NAME/bin

# create user and group
groupadd -g 520 $HTTPD_GROUP
useradd -u 520 -d /dev/null -s /usr/sbin/nologin -g $HTTPD_GROUP $HTTPD_USER

# httpd.conf
mv -v $INSTALL_DIR/$HTTPD_NAME/conf/httpd.conf $INSTALL_DIR/$HTTPD_NAME/conf/httpd.conf.old
cat <<EOF > $INSTALL_DIR/$HTTPD_NAME/conf/httpd.conf
ServerRoot $INSTALL_DIR/$HTTPD_NAME

# LoadModule foo_module modules/mod_foo.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authn_dbm_module modules/mod_authn_dbm.so
LoadModule authn_anon_module modules/mod_authn_anon.so
LoadModule authn_dbd_module modules/mod_authn_dbd.so
LoadModule authn_socache_module modules/mod_authn_socache.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule authz_dbm_module modules/mod_authz_dbm.so
LoadModule authz_owner_module modules/mod_authz_owner.so
LoadModule authz_dbd_module modules/mod_authz_dbd.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule access_compat_module modules/mod_access_compat.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule auth_form_module modules/mod_auth_form.so
LoadModule auth_digest_module modules/mod_auth_digest.so
LoadModule allowmethods_module modules/mod_allowmethods.so
LoadModule file_cache_module modules/mod_file_cache.so
LoadModule cache_module modules/mod_cache.so
LoadModule cache_disk_module modules/mod_cache_disk.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
LoadModule socache_dbm_module modules/mod_socache_dbm.so
LoadModule socache_memcache_module modules/mod_socache_memcache.so
LoadModule watchdog_module modules/mod_watchdog.so
LoadModule dbd_module modules/mod_dbd.so
LoadModule dumpio_module modules/mod_dumpio.so
LoadModule buffer_module modules/mod_buffer.so
LoadModule data_module modules/mod_data.so
LoadModule ratelimit_module modules/mod_ratelimit.so
LoadModule reqtimeout_module modules/mod_reqtimeout.so
LoadModule ext_filter_module modules/mod_ext_filter.so
LoadModule request_module modules/mod_request.so
LoadModule include_module modules/mod_include.so
LoadModule filter_module modules/mod_filter.so
LoadModule reflector_module modules/mod_reflector.so
LoadModule substitute_module modules/mod_substitute.so
LoadModule sed_module modules/mod_sed.so
LoadModule deflate_module modules/mod_deflate.so
LoadModule mime_module modules/mod_mime.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule log_forensic_module modules/mod_log_forensic.so
LoadModule logio_module modules/mod_logio.so
LoadModule env_module modules/mod_env.so
LoadModule mime_magic_module modules/mod_mime_magic.so
LoadModule cern_meta_module modules/mod_cern_meta.so
LoadModule expires_module modules/mod_expires.so
LoadModule headers_module modules/mod_headers.so
LoadModule ident_module modules/mod_ident.so
LoadModule usertrack_module modules/mod_usertrack.so
LoadModule unique_id_module modules/mod_unique_id.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule version_module modules/mod_version.so
LoadModule remoteip_module modules/mod_remoteip.so
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_connect_module modules/mod_proxy_connect.so
LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
LoadModule proxy_scgi_module modules/mod_proxy_scgi.so
LoadModule proxy_fdpass_module modules/mod_proxy_fdpass.so
LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule proxy_express_module modules/mod_proxy_express.so
LoadModule session_module modules/mod_session.so
LoadModule session_cookie_module modules/mod_session_cookie.so
LoadModule session_dbd_module modules/mod_session_dbd.so
LoadModule slotmem_shm_module modules/mod_slotmem_shm.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so
LoadModule lbmethod_heartbeat_module modules/mod_lbmethod_heartbeat.so
LoadModule mpm_worker_module modules/mod_mpm_worker.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule heartbeat_module modules/mod_heartbeat.so
LoadModule heartmonitor_module modules/mod_heartmonitor.so
LoadModule dav_module modules/mod_dav.so
LoadModule status_module modules/mod_status.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule asis_module modules/mod_asis.so
LoadModule info_module modules/mod_info.so
LoadModule suexec_module modules/mod_suexec.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule vhost_alias_module modules/mod_vhost_alias.so
LoadModule negotiation_module modules/mod_negotiation.so
LoadModule dir_module modules/mod_dir.so
LoadModule imagemap_module modules/mod_imagemap.so
LoadModule actions_module modules/mod_actions.so
LoadModule speling_module modules/mod_speling.so
LoadModule userdir_module modules/mod_userdir.so
LoadModule alias_module modules/mod_alias.so
LoadModule rewrite_module modules/mod_rewrite.so
#LoadModule fcgid_module modules/mod_fcgid.so

User $HTTPD_USER
Group $HTTPD_GROUP
PidFile "log/httpd.pid"
ServerTokens Prod
ServerSignature Off
ServerAdmin "support (at) host4ge (dot) com"
DocumentRoot "$INSTALL_DIR/$HTTPD_NAME/htdocs"

<Directory "/">
	Options FollowSymLinks
	AllowOverride None
	Order deny,allow
	Deny from all
</Directory>
<Directory "$INSTALL_DIR/$HTTPD_NAME/htdocs">
	Options Indexes FollowSymLinks
	AllowOverride None
	Order allow,deny
	Allow from all
</Directory>

<FilesMatch "^\\.ht">
	Order allow,deny
	Deny from all
	Satisfy All
</FilesMatch>

DirectoryIndex index.html
LogFormat "%h \\"%{GEOIP_COUNTRY_NAME}e\\" \\"%{GEOIP_CITY}e\\" \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-Agent}i\\"" custom_log_format"
CustomLog "|$INSTALL_DIR/$HTTPD_NAME/bin/log-apache.pl info" custom_log_format"
ErrorLog "|$INSTALL_DIR/$HTTPD_NAME/bin/log-apache.pl err"
TypesConfig conf/mime.types

Include conf/httpd-mpm.conf
Include conf/httpd-ssl.conf
Include conf/httpd-vhosts.conf
EOF

# SEE: http://forum.linode.com/viewtopic.php?p=41452

# httpd-mpm.conf
cat <<EOF > $INSTALL_DIR/$HTTPD_NAME/conf/httpd-mpm.conf
# prefork MPM
# StartServers: number of server processes to start
# MinSpareServers: minimum number of server processes which are kept spare
# MaxSpareServers: maximum number of server processes which are kept spare
# MaxClients: maximum number of server processes allowed to start
# MaxConnectionsPerChild: maximum number of connections a server process serves
#                         before terminating
<IfModule mpm_prefork_module>
    StartServers              2
    MinSpareServers           3
    MaxSpareServers           5
    MaxClients               10
    MaxConnectionsPerChild 5000
</IfModule>

# worker MPM
# StartServers: initial number of server processes to start
# MaxClients: maximum number of simultaneous client connections
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxConnectionsPerChild: maximum number of connections a server process serves
#                         before terminating
<IfModule mpm_worker_module>
    StartServers              1
    MaxClients               20
    MinSpareThreads           5
    MaxSpareThreads          10
    ThreadsPerChild           5
    MaxConnectionsPerChild 5000
</IfModule>
EOF

# httpd-ssl.conf
(	echo -e "Listen $HTTPD_PORT_SSL" && \
	echo -e "SSLRandomSeed startup builtin" && \
	echo -e "SSLRandomSeed connect builtin" && \
	echo -e "SSLPassPhraseDialog builtin" && \
	echo -e "SSLSessionCache \"shmcb:$INSTALL_DIR/$HTTPD_NAME/log/ssl_scache(512000)\"" && \
	echo -e "SSLSessionCacheTimeout 300" && \
	echo -e "AddType application/x-x509-ca-cert .crt" && \
	echo -e "AddType application/x-pkcs7-crl .crl" \
) > $INSTALL_DIR/$HTTPD_NAME/conf/httpd-ssl.conf

# httpd-vhosts.conf
(	echo -e "Listen $HTTPD_PORT" && \
	echo -e "<VirtualHost _default_:$HTTPD_PORT>" && \
	echo -e "\tDocumentRoot \"$INSTALL_DIR/$HTTPD_NAME/htdocs\"" && \
	echo -e "</VirtualHost>\n" && \
	echo -e "IncludeOptional $INSTALL_DIR/$HTTPD_NAME/conf/vhosts/*.conf" \
) > $INSTALL_DIR/$HTTPD_NAME/conf/httpd-vhosts.conf

# set files permission
chown -R root:root $INSTALL_DIR/$HTTPD_NAME
chown -R $HTTPD_USER:$HTTPD_GROUP $INSTALL_DIR/$HTTPD_NAME/log
chmod 500 $INSTALL_DIR/$HTTPD_NAME/{bin,modules}
chmod 500 $INSTALL_DIR/$HTTPD_NAME/{bin,modules}/*
chmod 700 $INSTALL_DIR/$HTTPD_NAME/log
chmod 4550 $INSTALL_DIR/$HTTPD_NAME/bin/suexec

# test
echo -e "\n\n *** Apache Modules ***\n"
$INSTALL_DIR/$HTTPD_NAME/bin/httpd -M
echo -e "\n\n *** Apache Suexec Settings ***\n"
$INSTALL_DIR/$HTTPD_NAME/bin/suexec -V
run_apache_performance_test $HTTPD_NAME "http://localhost:$HTTPD_PORT/index.html"

##
## clean up
##

[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f httpd.tar.gz ] && rm httpd.tar.gz
[ "$REMOVE_SOURCE_FILES" = "Y" ] && [ -f mod_fcgid.tar.gz ] && rm mod_fcgid.tar.gz
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d httpd-$HTTPD_VERSION ] && rm -rf httpd-$HTTPD_VERSION
[ "$REMOVE_SOURCE_DIRECTORIES" = "Y" ] && [ -d mod_fcgid-$HTTPD_MOD_FCGID_VERSION ] && rm -rf mod_fcgid-$HTTPD_MOD_FCGID_VERSION
