---
title: 'Update GCC in Ubuntu'
date: 2021-04-08
permalink: /posts/Update-GCC-in-Ubuntu
tags:
  - Linux
  - GCC
---

## Update gcc to gcc-9 on Ubuntu

```bash
sudo apt update -y && 
sudo apt upgrade -y && 
sudo apt dist-upgrade -y && 
sudo apt install build-essential software-properties-common -y && 
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y && 
sudo apt update -y && 
sudo apt install gcc-9 g++-9 -y && 
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && 
sudo update-alternatives --config gcc
```

Select gcc-9
