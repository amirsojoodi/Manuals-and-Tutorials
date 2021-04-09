## Installation or setting up LLVM from source

Follow the instructions on their websites:
1. https://llvm.org/docs/GettingStarted.html
2. https://clang.llvm.org/get_started.html
3. https://github.com/llvm/llvm-project
4. https://llvm.org/docs/CompileCudaWithLLVM.html
5. https://libcxx.llvm.org/docs/UsingLibcxx.html


To get the source code and setting up the environment variables:

You can grab the source directly from their repo or you can obtain it from [releases](https://github.com/llvm/llvm-project/releases).

```
mkdir ~/llvm
cd ~/llvm
git clone https://github.com/llvm/llvm-project.git

mkdir llvm-build
mkdir llvm-install

export LLVM_SRC="~/llvm/llvm-project"
export LLVM_BUILD="~/llvm/llvm-build"
export LLVM_PATH="~/llvm/llvm-install"

export PATH="$LLVM_PATH/bin":$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$LLVM_PATH/libexec"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$LLVM_PATH/lib"
export LIBRARY_PATH=$LIBRARY_PATH:"$LLVM_PATH/libexec"
export LIBRARY_PATH=$LIBRARY_PATH:"$LLVM_PATH/lib"
export C_INCLUDE_PATH=$C_INCLUDE_PATH:"$LLVM_PATH/include"
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:"$LLVM_PATH/include"
```
The requirements to build from source are: 
1. Cmake
2. Python3 
3. Gcc
4. zlib
5. GNU make

See the versions [here](https://releases.llvm.org/11.0.0/docs/GettingStarted.html).

### LLVM on Ubuntu 16.04 x64:

Almost all cmake configurations are available [here](https://llvm.org/docs/CMake.html).

```
cd $LLVM_BUILD

cmake -B build -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="host" \ 
	-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;compiler-rt' \
	-DCMAKE_INSTALL_PREFIX=$LLVM_PATH -DCMAKE_BUILD_TYPE=Release \
	-DLLVM_BUILD_EXAMPLES=ON -DCLANG_BUILD_EXAMPLES=ON \
	-DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_70 \
	-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=70 $LLVM_SRC/llvm

cd build
make -j8
make -j8 install
```

### LLVM on Redhat Enterprise with PowerPC architecture (GPU-enabled):
```
cmake -B build -G "Unix Makefiles" -DLLVM_ENABLE_RTTI=ON \
	-DLLVM_TARGETS_TO_BUILD="NVPTX;PowerPC" \
	-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;compiler-rt;libcxx;libcxxabi' \
	-DCMAKE_INSTALL_PREFIX=$LLVM_PATH -DCMAKE_BUILD_TYPE=Release \
	-DLLVM_BUILD_EXAMPLES=ON -DCLANG_BUILD_EXAMPLES=ON \
	-DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_70 \
	-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=70 $LLVM_SRC/llvm

cd build
make -j8
make -j8 install
```

### Compilation simple sources with clang on PowerPC
```
clang++ hello.cpp -fuse-ld=lld -o hello -L/path/to/gcc/libraries/

# In my case: -L/scinet/mist/software/2020a/opt/cuda-10.2.89/gcc/8.4.0/lib/gcc/powerpc64le-unknown-linux-gnu/8.4.0 

./hello
```
If you want to write the LLVM IR from the source, add option `-S -emit-llvm` to clang.

### Compilation CUDA sources with clang on PowerPC

Find more details, see [here](https://libcxx.llvm.org/docs/UsingLibcxx.html), and [here](https://releases.llvm.org/11.0.0/docs/CompileCudaWithLLVM.html).
```
clang++ -stdlib=libc++ -Wall vectorOp.cu -o vectorOp --cuda-gpu-arch=sm_70 -L/scinet/mist/software/2020a/opt/cuda-10.2.89/gcc/8.4.0/lib/gcc/powerpc64le-unknown-linux-gnu/8.4.0 -lcudart_static -ldl -lrt -pthread
```

