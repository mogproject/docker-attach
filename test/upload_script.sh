#!/bin/sh
#
# upload docker-attach script to the boot2docker VM
#

PROJECT_DIR=$(cd $(dirname $0)/.. && pwd -P)
TMP_B2D_CONF=/tmp/docker-attach.conf.tmp

# read boot2docker config
boot2docker config 2>/dev/null | grep SSH | sed -e 's/ = /=/' > $TMP_B2D_CONF
source $TMP_B2D_CONF
rm -f $TMP_B2D_CONF

# settings for boot2docker-cli
SSH_USER=docker
SSH_HOST=localhost
SSH_OPTS=""
SSH_OPTS="$SSH_OPTS -o StrictHostKeyChecking=no"
SSH_OPTS="$SSH_OPTS -o UserKnownHostsFile=/dev/null"
SSH_OPTS="$SSH_OPTS -o LogLevel=quiet"
SSH_OPTS="$SSH_OPTS -o PreferredAuthentications=publickey"
SSH_CMD="$SSH -p $SSHPort -i $SSHKey -l $SSH_USER $SSH_OPTS $SSH_HOST"

scp $SSH_OPTS -P $SSHPort -i $SSHKey $PROJECT_DIR/docker-attach $SSH_USER@$SSH_HOST:
$SSH_CMD sudo mv -f docker-attach /var/lib/boot2docker/bin/

