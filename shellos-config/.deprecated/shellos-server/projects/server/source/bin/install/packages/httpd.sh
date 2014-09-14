#!/bin/bash

##
## variables
##

HTTPD_NAME=
HTTPD_PORT=
HTTPD_PORT_SSL=
HTTPD_USER=
HTTPD_GROUP=
HTTPD_CONFIGURE_OPTIONS="--with-included-apr"

##
## functions
##

# parameters:
#    $1 instance_name
#    $2 url
function run_apache_performance_test {

    pkill httpd
    sleep 1
    $INSTALL_DIR/$1/bin/apachectl -k start
    sleep 3
    echo -e "\n\n *** Apache Benchmark ***\n"
    $INSTALL_DIR/$1/bin/ab -n 10000 -c 10 -k -r $2
    echo -e "\n\n"
    sleep 5
    $INSTALL_DIR/$1/bin/apachectl -k stop
}

##
## parse arguments
##

while [ "$1" != "" ]; do
    case $1 in
        --httpd)    shift && HTTPD_NAME=$1
                    shift && HTTPD_PORT=$1
                    shift && HTTPD_PORT_SSL=$1
                    shift && HTTPD_USER=$1
                    shift && HTTPD_GROUP=$1
                    ;;
    esac
    shift
done

##
## check dependencies
##

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

PKG_NAME="httpd-$HTTPD_VERSION"
[ "$PACKAGES_FORCE_COMPILATION" == "N" ] && PKG_RESULT=$(package_download $PKG_NAME)
if [ "$PKG_RESULT" != "success" ]; then
    URL="http://archive.apache.org/dist/httpd/httpd-$HTTPD_VERSION.tar.gz"
    FILE=httpd-$HTTPD_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 5000000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
    URL="http://www.apache.org/dist/httpd/mod_fcgid/mod_fcgid-$MOD_FCGID_VERSION.tar.gz"
    FILE=mod_fcgid-$MOD_FCGID_VERSION.tar.gz
    RESULT=$(file_download --url $URL --cache-dir-name downloads --file $FILE --check-file-size 50000)
    if [ "$RESULT" == "error" ]; then
        echo "Error: Unable to download $FILE file!"
        exit 1
    fi
fi

##
## install
##

pkill httpd

# create user and group
user_create "$HTTPD_USER" 520 "$HTTPD_GROUP" 520

if [ "$PKG_RESULT" != "success" ]; then

    echo "Compile Apache HTTPD Server:"
    [ -d $INSTALL_DIR/$HTTPD_NAME ] && rm -rf $INSTALL_DIR/$HTTPD_NAME
    tar -zxf httpd-$HTTPD_VERSION.tar.gz
    cd httpd-$HTTPD_VERSION
    replace_in_file '#define AP_SERVER_BASEPRODUCT "Apache"' '#define AP_SERVER_BASEPRODUCT "WWW Server"' ./include/ap_release.h
    ./configure \
        --prefix=$INSTALL_DIR/$HTTPD_NAME \
        --with-mpm=prefork \
        --enable-mpms-shared='prefork worker event' \
        --enable-mods-shared=all \
        --enable-cgi \
        --enable-cgid \
        --enable-fcgid \
        --enable-proxy \
        --enable-suexec \
        --with-suexec-bin=$INSTALL_DIR/$HTTPD_NAME/bin/suexec \
        --with-suexec-caller=$HTTPD_USER \
        --with-suexec-uidmin=10001 \
        --with-suexec-gidmin=10001 \
        --with-suexec-docroot="$HOSTING_DIR" \
        --with-suexec-userdir="public" \
        --with-suexec-logfile=$INSTALL_DIR/$HTTPD_NAME/log/httpd-suexec.log \
        --with-suexec-safepath="/usr/local/bin:/usr/bin:/bin" \
        --enable-so \
        --enable-ssl \
        --with-ssl=/usr \
        --with-z=/usr \
        $HTTPD_CONFIGURE_OPTIONS \
    && make && make install && echo "Apache HTTPD Server installed successfully!" \
    && rm -rf $INSTALL_DIR/$HTTPD_NAME/{conf/extra,logs,man,manual} \
    && rm -rf $INSTALL_DIR/$HTTPD_NAME/htdocs/* \
    && mkdir -p $INSTALL_DIR/$HTTPD_NAME/{conf,log}/{accounts,applications}
    cd ..

    echo "Compile Apache HTTPD mod_fcgid:"
    tar -zxf mod_fcgid-$MOD_FCGID_VERSION.tar.gz
    cd mod_fcgid-$MOD_FCGID_VERSION
    APXS=$INSTALL_DIR/$HTTPD_NAME/bin/apxs ./configure.apxs \
    && make && make install && echo "Apache HTTPD mod_fcgid installed successfully!" \
    && rm -rf $INSTALL_DIR/$HTTPD_NAME/manual \
    && rm $INSTALL_DIR/$HTTPD_NAME/conf/httpd.conf.bak
    cd ..

    echo "Strip symbols:"
    strip_debug_symbols $INSTALL_DIR/$HTTPD_NAME/bin
    strip_debug_symbols $INSTALL_DIR/$HTTPD_NAME/modules
    echo "Create package:"
    package_create $INSTALL_DIR/$HTTPD_NAME $PKG_NAME

else
    echo "Install Apache HTTPD from package:"
    package_restore $PKG_NAME
fi

# TODO: enable mod_fcgid
# see: http://forum.linode.com/viewtopic.php?p=42643
#      http://www.tumelum.de/blog/index.php?/plugin/tag/opensolaris
#      http://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html
#      http://www.howtoforge.com/how-to-set-up-apache2-with-mod_fcgid-and-php5-on-ubuntu-10.04
#      https://blogs.oracle.com/opal/entry/php_fpm_fastcgi_process_manager

# TODO: http://bash.cyberciti.biz/

# check
if [ ! -f $INSTALL_DIR/$HTTPD_NAME/bin/httpd ] || [ ! -f $INSTALL_DIR/$HTTPD_NAME/modules/mod_fcgid.so ]; then
    echo "Error: Apache HTTPD Server has NOT been installed successfully!"
    exit 1
fi

##
## configure
##

echo "Shared library dependencies for $INSTALL_DIR/$HTTPD_NAME/bin/httpd:"
ldd $INSTALL_DIR/$HTTPD_NAME/bin/httpd

# create links to the log files
ln -sfv /var/log/httpd.log $INSTALL_DIR/$HTTPD_NAME/log/httpd.log
ln -sfv /var/log/httpd.err $INSTALL_DIR/$HTTPD_NAME/log/httpd.err
#ln -sfv /var/log/httpd-suexec.log $INSTALL_DIR/$HTTPD_NAME/log/httpd-suexec.log

# generate server certificate
generate_certificate "$(hostname).$DOMAIN"

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
#LoadModule watchdog_module modules/mod_watchdog.so
LoadModule dbd_module modules/mod_dbd.so
LoadModule dumpio_module modules/mod_dumpio.so
LoadModule echo_module modules/mod_echo.so
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
LoadModule charset_lite_module modules/mod_charset_lite.so
LoadModule deflate_module modules/mod_deflate.so
LoadModule xml2enc_module modules/mod_xml2enc.so
#LoadModule proxy_html_module modules/mod_proxy_html.so
LoadModule mime_module modules/mod_mime.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule log_debug_module modules/mod_log_debug.so
LoadModule log_forensic_module modules/mod_log_forensic.so
LoadModule logio_module modules/mod_logio.so
LoadModule env_module modules/mod_env.so
LoadModule mime_magic_module modules/mod_mime_magic.so
LoadModule expires_module modules/mod_expires.so
LoadModule headers_module modules/mod_headers.so
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
LoadModule slotmem_plain_module modules/mod_slotmem_plain.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule dialup_module modules/mod_dialup.so
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so
#LoadModule lbmethod_heartbeat_module modules/mod_lbmethod_heartbeat.so
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
#LoadModule mpm_worker_module modules/mod_mpm_worker.so
#LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule unixd_module modules/mod_unixd.so
#LoadModule heartbeat_module modules/mod_heartbeat.so
#LoadModule heartmonitor_module modules/mod_heartmonitor.so
LoadModule dav_module modules/mod_dav.so
LoadModule status_module modules/mod_status.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule asis_module modules/mod_asis.so
LoadModule info_module modules/mod_info.so
LoadModule suexec_module modules/mod_suexec.so
#LoadModule cgid_module modules/mod_cgid.so
#LoadModule cgi_module modules/mod_cgi.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule dav_lock_module modules/mod_dav_lock.so
LoadModule vhost_alias_module modules/mod_vhost_alias.so
LoadModule negotiation_module modules/mod_negotiation.so
LoadModule dir_module modules/mod_dir.so
LoadModule actions_module modules/mod_actions.so
LoadModule speling_module modules/mod_speling.so
LoadModule userdir_module modules/mod_userdir.so
LoadModule alias_module modules/mod_alias.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule fcgid_module modules/mod_fcgid.so
# end of modules

User $HTTPD_USER
Group $HTTPD_GROUP
PidFile "$INSTALL_DIR/$HTTPD_NAME/log/httpd.pid"
ServerTokens Prod
ServerSignature Off
ServerAdmin "admin@$(hostname).$DOMAIN"
ServerName "$(hostname).$DOMAIN"
DocumentRoot "$INSTALL_DIR/$HTTPD_NAME/htdocs"

<Directory "/">
    Options FollowSymLinks
    AllowOverride None
    Order deny,allow
    Deny from all
</Directory>
<Directory "$INSTALL_DIR/$HTTPD_NAME/htdocs">
    Options FollowSymLinks
    AllowOverride None
    Order deny,allow
    Deny from all
</Directory>

<FilesMatch "^\\.ht">
    Order allow,deny
    Deny from all
    Satisfy All
</FilesMatch>

DirectoryIndex index.html
LogFormat "%v %h \\"%{GEOIP_COUNTRY_NAME}e\\" \\"%{GEOIP_CITY}e\\" \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-Agent}i\\"" log_format
CustomLog "|$HOST4GE_DIR/bin/additional-scripts/support/log-httpd.pl info" log_format
ErrorLog "|$HOST4GE_DIR/bin/additional-scripts/support/log-httpd.pl err"
TypesConfig conf/mime.types
AddDefaultCharset utf-8

<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
    AddOutputFilterByType DEFLATE application/json
</IfModule>

<IfModule mod_fcgid.c>
    FcgidIPCDir "$INSTALL_DIR/$HTTPD_NAME/log/fcgidsock"
    FcgidProcessTableFile "$INSTALL_DIR/$HTTPD_NAME/log/fcgid.shm"
</IfModule>

Include conf/httpd-mpm.conf
Include conf/httpd-ssl.conf
Include conf/httpd-vhosts.conf
EOF

# SEE: http://forum.linode.com/viewtopic.php?p=41452
# SEE: http://www.devside.net/articles/apache-performance-tuning
# ps aux --sort -vsize | head

# http://httpd.apache.org/docs/2.4/misc/perf-tuning.html
# http://www.linuxquestions.org/linux/articles/Technical/Understanding_memory_usage_on_Linux

MEMORY=$(echo `free -m` | awk '{ print $8 }')
N=$(expr $MEMORY / 512 + 1)

SERVER_LIMIT=$(expr $N \* 3)
THREAD_LIMIT=$(expr $N \* 30)
START_SERVERS=$(expr $N \* 2)
MIN_SPARE_THREADS=$(expr $N \* 10)
MAX_SPARE_THREADS=$(expr $N \* 30)
THREADS_PER_CHILD=$(expr $N \* 10)
MAX_REQUEST_WORKERS=$(expr $SERVER_LIMIT \* $THREADS_PER_CHILD)
MAX_CONNECTIONS_PER_CHILD=$(expr $N \* 1000)

# TODO: this has to be tested with more memory than 512MB available

# httpd-mpm.conf
cat <<EOF > $INSTALL_DIR/$HTTPD_NAME/conf/httpd-mpm.conf
# prefork MPM
# StartServers: number of server processes to start
# MinSpareServers: minimum number of server processes which are kept spare
# MaxSpareServers: maximum number of server processes which are kept spare
# MaxRequestWorkers: maximum number of server processes allowed to start
# MaxConnectionsPerChild: maximum number of connections a server process serves
#                         before terminating
#<IfModule mpm_prefork_module>
#    StartServers              5
#    MinSpareServers           5
#    MaxSpareServers          10
#    MaxRequestWorkers       150
#    MaxConnectionsPerChild    0
#</IfModule>
<IfModule mpm_prefork_module>
#    ServerLimit                $( expr $N \*     5 )
#    # standard options
#    StartServers               $( expr $N \*     5 )
#    MinSpareServers            $( expr $N \*     5 )
#    MaxSpareServers            $( expr $N \*    10 )
#    MaxRequestWorkers          $( expr $N \*   100 )
#    MaxConnectionsPerChild     $( expr $N \* 10000 )

    ServerLimit                150
    StartServers               4
    MinSpareServers            2
    MaxSpareServers            5
    MaxRequestWorkers          100
    MaxConnectionsPerChild     10000

    keepalive on
    keepalivetimeout 1

</IfModule>

# worker MPM
# StartServers: initial number of server processes to start
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxRequestWorkers: maximum number of worker threads
# MaxConnectionsPerChild: maximum number of connections a server process serves
#                         before terminating
#<IfModule mpm_worker_module>
#    StartServers              2
#    MinSpareThreads          25
#    MaxSpareThreads          75
#    ThreadsPerChild          25
#    MaxRequestWorkers       150
#    MaxConnectionsPerChild    0
#</IfModule>
<IfModule mpm_worker_module>
    ServerLimit                $SERVER_LIMIT
    ThreadLimit                $THREAD_LIMIT
    # standard options
    StartServers               $START_SERVERS
    MinSpareThreads            $MIN_SPARE_THREADS
    MaxSpareThreads            $MAX_SPARE_THREADS
    ThreadsPerChild            $THREADS_PER_CHILD
    MaxRequestWorkers          $MAX_REQUEST_WORKERS
    MaxConnectionsPerChild     $MAX_CONNECTIONS_PER_CHILD
</IfModule>

# event MPM
# StartServers: initial number of server processes to start
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxRequestWorkers: maximum number of worker threads
# MaxConnectionsPerChild: maximum number of connections a server process serves
#                         before terminating
#<IfModule mpm_event_module>
#    StartServers              2
#    MinSpareThreads          25
#    MaxSpareThreads          75
#    ThreadsPerChild          25
#    MaxRequestWorkers       150
#    MaxConnectionsPerChild    0
#</IfModule>
<IfModule mpm_event_module>
    ServerLimit                $( expr $N \*     5 )
    ThreadLimit                $( expr $N \*    25 )
    # standard options
    StartServers               $( expr $N \*     4 )
    MinSpareThreads            $( expr $N \*    25 )
    MaxSpareThreads            $( expr $N \*    75 )
    ThreadsPerChild            $( expr $N \*    25 )
    MaxRequestWorkers          $( expr $N \*   100 )
    MaxConnectionsPerChild     $( expr $N \* 10000 )
</IfModule>
EOF

# httpd-ssl.conf
(    echo -e "Listen $HTTPD_PORT_SSL" && \
    echo -e "SSLRandomSeed startup builtin" && \
    echo -e "SSLRandomSeed connect builtin" && \
    echo -e "SSLPassPhraseDialog builtin" && \
    echo -e "SSLSessionCache \"shmcb:$INSTALL_DIR/$HTTPD_NAME/log/ssl_scache(512000)\"" && \
    echo -e "SSLSessionCacheTimeout 300" && \
    echo -e "AddType application/x-x509-ca-cert .crt" && \
    echo -e "AddType application/x-pkcs7-crl .crl" \
) > $INSTALL_DIR/$HTTPD_NAME/conf/httpd-ssl.conf

# httpd-vhosts.conf
cat <<EOF > $INSTALL_DIR/$HTTPD_NAME/conf/httpd-vhosts.conf
Listen $HTTPD_PORT

# $(hostname).$DOMAIN:80 >>>
<VirtualHost $IP_ADDRESS:80>
    ServerName $(hostname).$DOMAIN
    DocumentRoot $INSTALL_DIR/$HTTPD_NAME/htdocs
    <Directory $INSTALL_DIR/$HTTPD_NAME/htdocs>
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
# <<< $(hostname).$DOMAIN:80

# $(hostname).$DOMAIN:443 >>>
<VirtualHost $IP_ADDRESS:443>
    ServerName $(hostname).$DOMAIN:443
    DocumentRoot $INSTALL_DIR/$HTTPD_NAME/htdocs
    <Directory $INSTALL_DIR/$HTTPD_NAME/htdocs>
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
    SSLEngine on
    SSLCertificateFile $CERTIFICATES_DIR/$(hostname).$DOMAIN.pem
    SSLCertificateKeyFile $CERTIFICATES_DIR/$(hostname).$DOMAIN.key
</VirtualHost>
# <<< $(hostname).$DOMAIN:443

IncludeOptional $INSTALL_DIR/$HTTPD_NAME/conf/accounts/*.conf
IncludeOptional $INSTALL_DIR/$HTTPD_NAME/conf/applications/*.conf
EOF

# vhost log queue
mkfifo -m644 $INSTALL_DIR/$HTTPD_NAME/log/vhost-log.fifo

#
# server home page
#

if [ "$CHROOT" == "N" ]; then

    # .htaccess
    cat <<EOF > $INSTALL_DIR/$HTTPD_NAME/htdocs/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} -s [OR]
RewriteCond %{REQUEST_FILENAME} -l [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^.*$ - [NC,L]
RewriteRule ^.*$ index.html [NC,L]
EOF
    # index.html
    cat <<EOF > $INSTALL_DIR/$HTTPD_NAME/htdocs/index.html
<!doctype html>
<html>
    <head>
    <title>$(hostname).$DOMAIN is under construction</title>
    <link rel="shortcut icon" href="/under_construction_favicon.ico" />
    <style type="text/css">
        body {
            background-color: black;
        }
        #under-construction {
            width: 500px;
            height: 300px;
            background-image:url(/under_construction.png);
        }
    </style>
    </head>
    <body>
        <div id="under-construction"></div>
    </body>
</html>
EOF
    # resources
    cp $HOST4GE_DIR/bin/install/packages/httpd/under_construction.png $INSTALL_DIR/$HTTPD_NAME/htdocs
    cp $HOST4GE_DIR/bin/install/packages/httpd/under_construction_favicon.ico $INSTALL_DIR/$HTTPD_NAME/htdocs

fi

# set files permission
chown -R root:root $INSTALL_DIR/$HTTPD_NAME
chown -R $HTTPD_USER:$HTTPD_GROUP $INSTALL_DIR/$HTTPD_NAME/log
chmod 700 $INSTALL_DIR/$HTTPD_NAME/{bin,modules}
chmod 500 $INSTALL_DIR/$HTTPD_NAME/bin/*
chmod 700 $INSTALL_DIR/$HTTPD_NAME/log
chmod 4550 $INSTALL_DIR/$HTTPD_NAME/bin/suexec

##
## post install
##

[ -f httpd-$HTTPD_VERSION.tar.gz ] && rm httpd-$HTTPD_VERSION.tar.gz
[ -f mod_fcgid-$MOD_FCGID_VERSION.tar.gz ] && rm mod_fcgid-$MOD_FCGID_VERSION.tar.gz
[ -d httpd-$HTTPD_VERSION ] && rm -rf httpd-$HTTPD_VERSION
[ -d mod_fcgid-$MOD_FCGID_VERSION ] && rm -rf mod_fcgid-$MOD_FCGID_VERSION

# log event
logger -p local0.notice -t host4ge "httpd $HTTPD_VERSION installed successfully"

# save package version
package_add_version "httpd" "$HTTPD_VERSION"

# add directories to create hashes
hashes_add_dir $INSTALL_DIR/$HTTPD_NAME/bin
hashes_add_dir $INSTALL_DIR/$HTTPD_NAME/cgi-bin
hashes_add_dir $INSTALL_DIR/$HTTPD_NAME/modules

# test
if [ "$CHROOT" == "N" ]; then
    echo -e "\n\n *** Apache HTTPD configuration ***\n"
    $INSTALL_DIR/$HTTPD_NAME/bin/httpd -V
    echo -e "\n\n *** Apache HTTPD modules ***\n"
    $INSTALL_DIR/$HTTPD_NAME/bin/httpd -M
    echo -e "\n\n *** Apache HTTPD directives ***\n"
    $INSTALL_DIR/$HTTPD_NAME/bin/httpd -L
    echo -e "\n\n *** Apache HTTPD suexec settings ***\n"
    $INSTALL_DIR/$HTTPD_NAME/bin/suexec -V
    run_apache_performance_test $HTTPD_NAME "http://$(hostname).$DOMAIN:$HTTPD_PORT/index.html"
fi

exit 0
