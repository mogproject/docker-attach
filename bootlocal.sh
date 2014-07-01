#!/bin/sh

B2D_ROOT=/var/lib/boot2docker
B2D_BIN_DIR=$B2D_ROOT/bin

mkdir -p $B2D_BIN_DIR

# install util-linux
UTIL_LINUX=$B2D_ROOT/optional/util-linux.tcz
if [ ! -e $UTIL_LINUX ]; then
    su - docker -c "tce-load -w util-linux"
    mv -f /tmp/tce/optional $B2D_ROOT/
fi
su - docker -c "tce-load -i $UTIL_LINUX"

# install docker-attach
URL_DOCKER_ATTACH=https://raw.githubusercontent.com/mogproject/docker-attach/master/docker-attach
DOCKER_ATTACH=$B2D_BIN_DIR/docker-attach
if [ ! -x $DOCKER_ATTACH ]; then 
    curl -s -o $DOCKER_ATTACH $URL_DOCKER_ATTACH
    chmod +x $DOCKER_ATTACH
fi
ln -s $DOCKER_ATTACH /usr/local/bin/docker-attach
