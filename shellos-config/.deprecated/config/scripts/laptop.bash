#!/bin/bash

name="laptop"
cd /srv; [ -f shellos-$name.tar.gz ] && (
    rm -rf /srv/shellos
    mkdir /srv/shellos
    tar zxf shellos-$name.tar.gz -C /srv/shellos
    cd shellos/sbin
    chmod u+x ./install
    ./install \
        --owner "daniel" \
        --openjdk \
        --ant \
        --maven \
        --eclipse \
        --shellos \
        --do-not-reboot \
        2>&1 | tee /srv/shellos/log/install.log
)

exit 0
