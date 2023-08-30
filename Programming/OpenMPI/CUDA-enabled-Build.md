# Building OpenMPI 5.0 with UCX and CUDA 11.2

Lessons learned:

- [Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) are tricky but understanding how it works helps you customize packages, plugins, etc. I will add an entry on Autotools.
- Never work on master branch just like a newbie and waste a week away. Always checkout to a (release) tag or a working branch.
- When you are working in a cluster node, it is best not to load any module in your `.bashrc`. This approach will mess things up. Add them to your scripts and load them purposefully.
- Make sure you have done all your searches and reads before going down the rabbit hole. You can safely assume that someone else has already done what you want to do. Don't be embarass to ask stupid questions.

## Loading necessary modules

```bash
#! /bin/bash
module --force purge
module load MistEnv/2021a
module load autotools/2021b
module load cuda/11.2.2
module load gcc/10.3.0
module load gdb/10.2
module load valgrind/3.17.0

module list

export NVCC=$(which nvcc)
export ROOT_DIR=$(pwd)
export VALGRIND_HOME="Valgrind home!"
export BUILD_DIR=$ROOT_DIR/build

export LD_LIBRARY_PATH=$CUDA_HOME/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$BUILD_DIR/lib:$LD_LIBRARY_PATH

export LIBRARY_PATH=$CUDA_HOME/lib64/:$LIBRARY_PATH
export LIBRARY_PATH=$BUILD_DIR/lib:$LIBRARY_PATH

export CPATH=$CUDA_HOME/include:$CPATH
export CPATH=$BUILD_DIR/include:$CPATH

export LD_RUN_PATH=$BUILD_DIR/lib:$LD_RUN_PATH

export PATH=$BUILD_DIR/bin/:$PATH
```

## Building script

These scripts are used to build OpenMPI with internal libraries (OpenPMIX, Libevent, and HWLOC), tested on Mist (PowerPC, ppc64le).

`Ompi` needs `flex` in order to build `pmix`, but mist's flex had issues and I needed to install a couple of things first to prepare the environment.

So I have commented those commands required for resolving the problems in my machine, but if you have any problem, feel free to read, uncomment, and use.

```bash
#! /bin/bash -l
source ./modules.sh
set -eux

# export INSTALL_GETTEXT=0
# export INSTALL_FLEX=0
export INSTALL_UCX=1
# export INSTALL_HWLOC=0
# export INSTALL_LIBEVENT=0
# export INSTALL_PMIX=0
export INSTALL_OMPI=1
# export INSTALL_OMB=0

if [ "$INSTALL_GETTEXT" == 1 ]; then
  if [ ! -d flex ]; then
    VERSION=0.21
    wget https://ftp.gnu.org/pub/gnu/gettext/gettext-$VERSION.tar.gz
    tar -xfz gettext-$VERSION.tar.gz
    rm gettext-$VERSION.tar.gz
    mv gettext-$VERSION gettext
  fi
  cd gettext
  ./autogen.sh
  ./configure --prefix=$BUILD_DIR
  make -j32
  make install
  cd ..
fi

if [ "$INSTALL_FLEX" == 1 ]; then
  if [ ! -d flex ]; then
    VERSION=2.6.4
    wget https://github.com/westes/flex/releases/download/v$VERSION/flex-$VERSION.tar.gz
    tar -xf flex-$VERSION.tar.gz
    rm flex-$VERSION.tar.gz
    mv flex-$VERSION flex
    # Flex dev library should also be installed. If you see errors, try these:
    # wget https://rpmfind.net/linux/centos/8.5.2111/PowerTools/ppc64le/os/Packages/flex-devel-2.6.1-9.el8.ppc64le.rpm
    # rpm2cpio flex-devel-2.6.1-9.el8.ppc64le.rpm | cpio -idv
    # cp usr/lib64/* $BUILD_DIR/lib
  fi
  cd flex
  ./autogen.sh
  ./configure --prefix=$BUILD_DIR
  make -j32 all
  make install
  cd ..
fi

if [ "$INSTALL_UCX" == 1 ]; then
  if [ ! -d ucx ]; then
    # wget https://github.com/openucx/ucx/releases/download/v1.11.2/ucx-1.11.2.tar.gz
    git clone --recursive --branch v1.11.0 https://github.com/openucx/ucx.git
  fi
  cd ucx
  ./autogen.sh
  ./configure --prefix=$BUILD_DIR \
    --enable-mt \
    --with-cuda=$CUDA_HOME \
    --enable-devel-headers \
    --enable-debug \
    --enable-stats \
    --enable-profiling \
    --enable-examples \
    --with-valgrind=$VALGRIND_HOME
  make -j32 all
  make install
  cd ..
fi

if [ "$INSTALL_HWLOC" == 1 ]; then
  if [ ! -d hwloc ]; then
    VERSION=2.4.1
    wget https://download.open-mpi.org/release/hwloc/v2.4/hwloc-$VERSION.tar.gz
    tar -xf hwloc-$VERSION.tar.gz
    rm hwloc-$VERSION.tar.gz
    mv hwloc-$VERSION hwloc
  fi
  cd hwloc
  ./configure --prefix=$BUILD_DIR \
    --enable-debug
  #  --with-cuda=$CUDA_HOME \
  
  make -j32 all
  make install
  cd ..
fi

if [ "$INSTALL_LIBEVENT" == 1 ]; then
  if [ ! -d libevent ]; then
    VERSION=2.1.12-stable
    wget https://github.com/libevent/libevent/releases/download/release-$VERSION/libevent-$VERSION.tar.gz
    tar -xf libevent-$VERSION.tar.gz
    rm libevent-$VERSION.tar.gz
    mv libevent-$VERSION libevent
  fi

  cd libevent
  ./configure --prefix=$BUILD_DIR
  make -j 32 all
  make install
  cd ..
fi

if [ "$INSTALL_PMIX" == 1 ]; then
  if [ ! -d openpmix ]; then
    VERSION=4.1.1rc4
    wget https://github.com/openpmix/openpmix/releases/download/v$VERSION/pmix-$VERSION.tar.gz
    tar -xf pmix-$VERSION.tar.gz
    rm pmix-$VERSION.tar.gz
    mv pmix-$VERSION openpmix
  fi

  cd openpmix
  # If you've obtained PMIX from its source, you will need this:
  # perl ./autogen.pl
  ./configure --prefix=$BUILD_DIR \
    --with-hwloc=$BUILD_DIR \
    --with-libevent=$BUILD_DIR \
    --enable-debug
  make -j 32 all
  make install
  cd ..
fi

if [ "$INSTALL_OMPI" == 1 ]; then
  if [ ! -d ompi ]; then
    git clone --recursive git@github.com:open-mpi/ompi.git
    cd ompi
    # These two lines can save you a week at least.
    git checkout v5.0.0rc2
    git submodule update
    cd ..
  fi

  cd ompi
  perl autogen.pl --no-oshmem -j 16
  ./configure --help >../ompi.config.opts
  ./configure --prefix=$BUILD_DIR \
    --with-cuda=$CUDA_HOME \
    --with-ucx=$BUILD_DIR \
    --with-valgrind=$VALGRIND_HOME \
    --with-hwloc=internal \
    --with-libevent=internal \
    --with-pmix=internal \
    --disable-io-romio \
    --disable-man-pages \
    --disable-mpi-fortran \
    --enable-debug \
    --enable-builtin-atomics-for-ppc

  # Some other options:
  # --with-hwloc=$BUILD_DIR \
  # --with-libevent=$BUILD_DIR \
  # --with-pmix=$BUILD_DIR \
  # --enable-mca-dso=coll-cuda,btl-smcuda \
  # --enable-mca-no-build=btl-portals4,coll-hcoll,mtl,sharedfp,ucc

  make -j 32 all
  make install
  cd ..
fi

# OSU Microbenchmark 
if [ "$INSTALL_OMB" == 1 ]; then
  # OMB
  if [ ! -d omb ]; then
    VERSION=5.8
    wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-$VERSION.tgz
    tar -xf osu-micro-benchmarks-$VERSION.tgz
    rm osu-micro-benchmarks-$VERSION.tgz
    mv osu-micro-benchmarks-$VERSION omb
  fi

  cd omb/
  ./configure CC=$BUILD_DIR/bin/mpicc \
    CXX=$BUILD_DIR/bin/mpicxx \
    --prefix=$BUILD_DIR \
    --enable-cuda \
    --with-cuda=$CUDA_HOME \
    --with-cuda-include=$CUDA_HOME/include \
    --with-cuda-libpath=$CUDA_COMPAT_PATH

  make -j 16
  make install
  cd ..
fi
```
