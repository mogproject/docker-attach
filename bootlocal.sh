#!/bin/sh

B2D_ROOT=/var/lib/boot2docker

# util-linux
su - docker -c "tce-load -i $B2D_ROOT/optional/util-linux.tcz"

# docker-attach
rm -f /usr/local/bin/docker-attach
ln -s $B2D_ROOT/bin/docker-attach /usr/local/bin/docker-attach
