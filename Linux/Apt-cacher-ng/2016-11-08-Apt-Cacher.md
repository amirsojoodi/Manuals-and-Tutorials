---
title: 'Config Apt Cacher'
date: 2016-11-08
permalink: /posts/Config-Apt-Cacher/
tags:
  - Linux
  - Apt
---

## On client side

```bash
#!/bin/bash

serverIP="localhost"
port="3142"

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}


echo "Acquire::http::Proxy \"http://$serverIP:$port\";" | sudo tee /etc/apt/apt.conf

echo "Ready to use apt-cacher-ng!"

confirm "you want to run apt-get update now?(y/N)" && sudo apt-get update

```

## On server side

(The commands are not complete)

```bash
#!/bin/bash

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

sudo apt-get install apt-cacher-ng

echo "Confirm that these lines exist in the config file of apt-cacher-ng, (/etc/apt-cacher-ng/acng.conf):"
echo "CacheDir: /var/cache/apt-cacher-ng"
echo "LogDir: /var/log/apt-cacher-ng"
echo "Port:3142"
echo "BindAddress: 0.0.0.0"
echo "Remap-debrep: file:deb_mirror*.gz /debian ; file:backends_debian # Debian Archives"
echo "Remap-uburep: file:ubuntu_mirrors /ubuntu ; file:backends_ubuntu # Ubuntu Archives"
echo "Remap-debvol: file:debvol_mirror*.gz /debian-volatile ; file:backends_debvol # Debian Volatile Archives"
echo "ReportPage: acng-report.html"
echo "VerboseLog: 1"
echo "PidFile: /var/run/apt-cacher-ng/pid"
echo "ExTreshold: 4"

confirm "Do you want to edit config file now?(y/n recommended yes)" && sudo vim /etc/apt-cacher-ng/acng.conf

sudo /etc/init.d/apt-cacher-ng restart

echo "Acquire::http::Proxy \"http://localhost:3142\";" | sudo tee /etc/apt/apt.conf

echo "Installation on the server has finished, please run the client config files in each of your clients station."

confirm "Do you want to run apt-get update now?(y/N)" && sudo apt-get update
```
