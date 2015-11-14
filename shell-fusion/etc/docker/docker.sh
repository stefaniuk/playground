#!/bin/bash

if [ $DIST == "macosx" ]; then

    brew update
    if ! which boot2docker > /dev/null 2>&1; then
        brew install -v \
            boot2docker docker
    else
        boot2docker upgrade
    fi

elif [ $DIST == "ubuntu" ]; then

    sudo apt-get --yes update
    if ! which docker > /dev/null 2>&1; then
        wget -qO- https://get.docker.com/ | sudo sh
    else
        sudo apt-get --yes --force-yes --ignore-missing --no-install-recommends --only-upgrade install \
            lxc-docker
    fi
    sudo groupadd docker
    sudo usermod -aG docker $USER

fi

which docker > /dev/null 2>&1 || exit 2

sudo bash -c "curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose"

exit 0
