docker-attach
====

Enter to the running docker container easily.


## Dependencies

- [Docker](http://www.docker.com/) >= 1.0.0
- [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html)

## Installation

Just download the latest docker-attach shell script.

```
curl -o /usr/local/bin/docker-attach https://raw.githubusercontent.com/mogproject/docker-attach/master/docker-attach
chmod +x /usr/local/bin/docker-attach
```

If you want to uninstall, just remove ```/usr/local/bin/docker-attach```.

## Usage

- without arguments

    The result of ```docker ps``` command with numbers shows up.  
    It requires human action. Specify the number which you want to enter into.


    ```
  $ docker-attach
   NO.  CONTAINER ID        IMAGE               COMMAND             CREATED                 STATUS              PORTS               NAMES
   [1]  77c4f673e22d        centos:latest       /bin/sleep 1000     6 seconds ago       Up 5 seconds                            insane_poincar
   [2]  bf55f24e0231        centos:latest       /bin/sleep 1000     7 seconds ago       Up 6 seconds                            goofy_darwin
   [3]  ae214f93be56        centos:latest       /bin/sleep 1000     8 seconds ago       Up 8 seconds                            furious_laland
   [4]  2af5192ee5a6        centos:latest       /bin/sleep 1000     10 seconds ago      Up 9 seconds                            mad_einstein
   [5]  ff2b4987e717        centos:latest       /bin/sleep 1000     11 seconds ago      Up 11 seconds                           agitated_meitn
   [6]  0b2168db31db        centos:latest       /bin/sleep 1000     13 seconds ago      Up 12 seconds                           focused_bell
   [7]  89bce218d973        centos:latest       /bin/sleep 1000     14 seconds ago      Up 14 seconds                           stoic_fermi
   [8]  d9767d3d8551        centos:latest       /bin/sleep 1000     16 seconds ago      Up 15 seconds                           insane_tesla
   [9]  ddd3b0e67a1c        centos:latest       /bin/sleep 1000     17 seconds ago      Up 17 seconds                           furious_meitne
   [10] d4eea7f883d6        centos:latest       /bin/sleep 1000     19 seconds ago      Up 18 seconds                           condescending_
    
  Enter number (1-10): 5
  -sh-4.1# hostname
  ff2b4987e717
  -sh-4.1# exit
  logout
    ```

- with a (beggining of) container id

    ```
    $ docker-attach 77c4
    -sh-4.1# hostname
    77c4f673e22d
    -sh-4.1# exit
    logout
    ```

- with a container id and command

    ```
$ docker-attach bf55 cat /etc/redhat-release
CentOS release 6.5 (Final)
    ```

- print help

    ```
$ docker-attach --help
Usage: /usr/local/bin/docker-attach [CONTAINER [COMMAND [CMD_ARGS...]]]
    ```


## Easy setup for Mac OS X

1. Download and install the latest release of the [Docker OSX Installer](https://github.com/boot2docker/osx-installer/releases)

2. Initialize and run boot2docker VM

   ```
boot2docker init
boot2docker up
   ```

3. Run the setup shell script  
(This will install util-linux(incl. nsenter) and docker-attach command in the boot2docker VM)

   ```
boot2docker ssh '/bin/sh -c "curl https://raw.githubusercontent.com/mogproject/docker-attach/master/setup/boot2docker/setup_boot2docker.sh | /bin/sh"'
   ```

4. Install ```docker-attach``` on Mac OS X.

    ```
curl -o /usr/local/bin/docker-attach https://raw.githubusercontent.com/mogproject/docker-attach/master/docker-attach
chmod +x /usr/local/bin/docker-attach
    ```

   Now, you can use ```docker-attach``` command on Mac!  
   (not necessary to run ```boot2docker ssh```)



##### References (in Japanese)

- [mog project: Docker: How to Dive Into a Container on the boot2docker VM, Improved](http://mogproject.blogspot.jp/2014/07/docker-how-to-dive-into-containers-on.html)
- [mog project: Docker: docker-attach - Helper Script for Entering a Running Container](http://mogproject.blogspot.jp/2014/07/docker-docker-attach-helper-script-for.html)
