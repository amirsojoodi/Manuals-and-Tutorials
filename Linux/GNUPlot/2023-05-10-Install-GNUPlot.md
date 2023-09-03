---
title: 'Build and Install GNU Plot on RHEL'
date: 2023-05-10
permalink: /posts/Install-GNUPlot-on-RHEL
tags:
  - Linux
  - GNUPlot
---

1. Obtain the source and checkout to the latest stable branch

```bash
git clone -b branch-5-4-stable git://git.code.sf.net/p/gnuplot/gnuplot-main
```

{:start="2"}
2. Configure with GD Lib to have PNG output files

```bash
cd gnuplot-main
./configure --prefix="/path/to/install" --with-gd="/path/to/libgd"
```

{:start="3"}
3. Make and install

```bash
make -j16
make -j16 check
make -j16 install
```

In case you don't have Libgd installed, grab it from [here](https://github.com/libgd/libgd/releases)

```bash
tar xvzf libgd-2.3.3.tar.gz
cd libgd-2.3.3
./configure --prefix="/path/to/install"
make -j16
make -j16 install
```

## References

1. [GNU Plot](http://www.gnuplot.info/)
2. [LIBGD](https://libgd.github.io/)
