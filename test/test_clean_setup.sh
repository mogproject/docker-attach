#!/bin/sh
#
# Testing script for clean setup on Mac
#
#     The existing VM will be deleted.
#

PROJECT_DIR=$(cd $(dirname $0)/.. && pwd -P)
BRANCH=${BRANCH:-"master"}

echo "First, enter your password if required."
sudo id

boot2docker halt
boot2docker delete
boot2docker init
boot2docker up
boot2docker ssh '/bin/sh -c "curl https://raw.githubusercontent.com/mogproject/docker-attach/'$BRANCH'/setup/boot2docker/setup_boot2docker.sh | BRANCH='$BRANCH' /bin/sh -x"' || exit 1

docker run -d -t centos /bin/sleep 1000
cid1=$(docker ps -lq --no-trunc=true)

docker run -d -t centos /bin/sleep 1000
cid2=$(docker ps -lq --no-trunc=true)

docker ps

sudo rm -f /usr/local/bin/docker-attach
sudo ln -s $PROJECT_DIR/docker-attach /usr/local/bin/docker-attach
$PROJECT_DIR/test/upload_script.sh

# attach to the first container
docker-attach $cid1 cat /etc/redhat-release

docker-attach $cid2 cat /etc/redhat-release


