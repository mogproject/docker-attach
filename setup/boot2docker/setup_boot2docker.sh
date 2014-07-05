#!/bin/sh
#
# Setup script for boot2docker-vm
#

BRANCH=${BRANCH:-"master"}
B2D_ROOT=/var/lib/boot2docker
B2D_BIN_DIR=$B2D_ROOT/bin
B2D_BOOTLOCAL_DIR=$B2D_ROOT/bootlocal.d
URL_GH=https://raw.githubusercontent.com/mogproject/docker-attach/$BRANCH
URL_DOCKER_ATTACH=$URL_GH/docker-attach
URL_BOOTLOCAL=$URL_GH/setup/boot2docker/bootlocal.sh
URL_BOOTLOCAL_UTIL_LINUX=$URL_GH/setup/boot2docker/bootlocal.d/util-linux
URL_BOOTLOCAL_DOCKER_ATTACH=$URL_GH/setup/boot2docker/bootlocal.d/docker-attach
UTIL_LINUX=$B2D_ROOT/optional/util-linux.tcz

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

# download and set executable
download_executable() {
    local url=$1
    local dest=$2/${1##*/}
    log info "Downloading $url to $dest"
    sudo curl -s -o $dest $url || return 1
    sudo chmod +x $dest || return 1
}

# main function
main() {
    # create directory to persist commands
    log info "Creating directory $B2D_BIN_DIR"
    sudo mkdir -p $B2D_BIN_DIR

    # create directory for bootlocal.sh
    log info "Creating directory $B2D_BOOTLOCAL_DIR"
    sudo mkdir -p $B2D_BOOTLOCAL_DIR

    # download bootlocal.sh
    download_executable $URL_BOOTLOCAL $B2D_ROOT || return 1

    # download and persist util-linux
    log info "Downloading util-linux."
    tce-load -w util-linux || return 1
    sudo mv -f /tmp/tce/optional $B2D_ROOT/

    # add util-linux to bootlocal.d
    download_executable $URL_BOOTLOCAL_UTIL_LINUX $B2D_BOOTLOCAL_DIR || return 1

    # download docker-attach
    download_executable $URL_DOCKER_ATTACH $B2D_BIN_DIR || return 1

    # add docker-attach to bootlocal.d
    download_executable $URL_BOOTLOCAL_DOCKER_ATTACH $B2D_BOOTLOCAL_DIR || return 1

    # run bootlocal.sh
    log info "Running $B2D_ROOT/bootlocal.sh"
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
