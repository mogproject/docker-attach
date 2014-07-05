docker-attach
====

Enter to the docker container easily.


## Dependencies

- [Docker](http://www.docker.com/) >= 1.0.0
- [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html)

## Installation

Just download the latest docker-attach shell script.

```
curl -o /usr/local/bin/docker-attach https://raw.githubusercontent.com/mogproject/docker-attach/master/docker-attach
chmod +x /usr/local/bin/docker-attach
```

## Usage

TBD



## Easy setup for Mac OS X

1. Download and install the latest release of the [Docker OSX Installer](https://github.com/boot2docker/osx-installer/releases)

2. Run the setup shell script  
(This will install util-linux(incl. nsenter) and docker-attach command)

```
boot2docker ssh '/bin/sh -c "curl https://raw.githubusercontent.com/mogproject/docker-attach/master/setup/boot2docker/setup_boot2docker.sh | /bin/sh"'
```

##### References (in Japanese)

http://mogproject.blogspot.jp/2014/07/docker-how-to-dive-into-containers-on.html

