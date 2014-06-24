#!/bin/sh
#
# Setup script for boot2docker-vm
#

B2D_ROOT=/var/lib/boot2docker
B2D_BIN_DIR=$B2D_ROOT/bin
REPO_NSINIT=github.com/docker/libcontainer/nsinit
URL_DOCKER_ATTACH=https://raw.githubusercontent.com/mogproject/docker-attach/master/docker-attach
URL_BOOTLOCAL=https://raw.githubusercontent.com/mogproject/docker-attach/master/bootlocal.sh
GOPATH=$HOME/go

# logger
log() {
    raw_log() {
        echo "`date +"%Y-%m-%d %H:%M:%S"` ${*}"
    }

    severity=$1
    shift
    case $severity in
    info)
        raw_log "[INFO] ${*}";;
    warn)
        raw_log "[WARN] ${*}";;
    error)
        raw_log "[ERROR]${*}";;
    esac
}

# assume hostname
assume_hostname() {
    [ $(uname -n) == "$1" ] || {
        log error "this script should be run in the host '$1'.  Aborting."
        exit 1
    }
}

# assume current user
assume_current_user() {
    [ $(whoami) == "$1" ] || {
        log error "this script should be run as '$1'.  Aborting."
        exit 1
    }
}

# assume that all required commands exist
assume_cmd_exists() {
    while [ -n "$1" ]; do
        command -v $1 >/dev/null 2>&1 || {
            log error "command '$1' is required but not installed.  Aborting."
            exit 1
        }
        shift
    done
}

# main function
main() {
    # create directory to persist commands
    log info "Creating directory $B2D_BIN_DIR"
    sudo mkdir -p $B2D_BIN_DIR

    if [ -x $B2D_BIN_DIR/nsinit ]; then
        log info "nsinit is already installed."
    else
        # setup compilers
        log info "Installing compilers"
        tce-load -wil compiletc go || return 1

        # build nsinit
        log info "Building $B2D_BIN_DIR/nsinit"
        sudo GOPATH=$GOPATH go get $REPO_NSINIT || return 1
        sudo mv -f $GOPATH/bin/nsinit $B2D_BIN_DIR/ || return 1
    fi
 
    # download docker-attach
    log info "Downloading $B2D_BIN_DIR/docker-attach"
    sudo curl -s -o $B2D_BIN_DIR/docker-attach $URL_DOCKER_ATTACH || return 1
    sudo chmod +x $B2D_BIN_DIR/docker-attach || return 1

    # download bootlocal.sh
    log info "Downloading $B2D_ROOT/bootlocal.sh"
    sudo curl -s -o $B2D_ROOT/bootlocal.sh $URL_BOOTLOCAL || return 1
    sudo chmod +x $B2D_ROOT/bootlocal.sh || return 1

    # run bootlocal.sh to link commands
    log info "Linking commands in /usr/local/bin"
    sudo rm -f /usr/local/bin/nsinit || return 1
    sudo rm -f /usr/local/bin/docker-attach || return 1
    sudo $B2D_ROOT/bootlocal.sh || return 1
}

# check environment
assume_hostname boot2docker
assume_current_user docker
assume_cmd_exists tce-load curl

# main
log info "Script started."
main

# check result
if [ $? -ne 0 ]; then
    log error "Script ended with error."
    exit 1
fi
log info "Script ended successfully."
exit 0
