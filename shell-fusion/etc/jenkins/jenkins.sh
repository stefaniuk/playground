#!/bin/bash

data_dir=$pkgs_dir/jenkins/data

#
# install
#

sudo rm -rf $install_dir/log
rm -rf $install_dir/*
mkdir -p $install_dir/{bin,conf,libexec,log}
cp $cache_dir/$PKG_FILE $install_dir/libexec/jenkins.war
create_daemon --name "jenkins" \
    --user "jenkins" \
    --group "jenkins" \
    --log-dir $install_dir/log \
    --daemon-script $install_dir/bin/daemon \
    --config-script $install_dir/conf/jenkins-daemon.conf
ln -sf $install_dir/bin/daemon $install_dir/bin/jenkins

[ ! -f $install_dir/libexec/jenkins.war ] && exit 2

#
# resources
#

if [ $opt_scope == "global" ]; then

    print_h3 "Link binaries:"
    sudo dev_link_binaries $install_dir/bin/jenkins

fi

#
# configuration
#

if [ $opt_configure == "y" ]; then

    print_h3 "Configure"

    user_exists "jenkins" && user_delete "jenkins"
    user_create "jenkins" "jenkins" --home $data_dir
    sudo chown -R jenkins:jenkins $install_dir/log
    mkdir -p $data_dir
    sudo chown -R jenkins:jenkins $data_dir

    cat << EOF > $install_dir/conf/jenkins-daemon.conf
#!/bin/sh

export JENKINS_HOME=$data_dir

HTTP_ADDRESS=127.0.0.1
HTTP_PORT=8080
HTTP_CONTEXT="jenkins"

NAME="jenkins"
RUN_AS_USER="jenkins"
START_COMMAND="java -jar $install_dir/libexec/jenkins.war \\
    --httpListenAddress=\$HTTP_ADDRESS \\
    --httpPort=\$HTTP_PORT \\
    --prefix=/\$HTTP_CONTEXT \\
    --logfile=$install_dir/log/jenkins.log"
PID_FILE=$install_dir/log/jenkins.pid
EOF

fi

exit 0
