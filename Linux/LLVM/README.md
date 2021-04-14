## Installation or setting up LLVM from source

Follow the instructions on their websites:
1. https://llvm.org/docs/GettingStarted.html
2. https://clang.llvm.org/get_started.html
3. https://github.com/llvm/llvm-project
4. https://llvm.org/docs/CompileCudaWithLLVM.html
5. https://libcxx.llvm.org/docs/UsingLibcxx.html
6. https://llvm.org/docs/WritingAnLLVMPass.html


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

## Compilation simple sources with clang on PowerPC
```
clang++ hello.cpp -fuse-ld=lld -o hello -L/path/to/gcc/libraries/

# In my case: -L/scinet/mist/software/2020a/opt/cuda-10.2.89/gcc/8.4.0/lib/gcc/powerpc64le-unknown-linux-gnu/8.4.0 

./hello
```
If you want to write the LLVM IR from the source, add option `-S -emit-llvm` to clang.

## Compilation CUDA sources with clang on PowerPC

Find more details, see [here](https://libcxx.llvm.org/docs/UsingLibcxx.html), and [here](https://releases.llvm.org/11.0.0/docs/CompileCudaWithLLVM.html).
```
clang++ -stdlib=libc++ -Wall vectorOp.cu -o vectorOp --cuda-gpu-arch=sm_70 \
	-L/scinet/mist/software/2020a/opt/cuda-10.2.89/gcc/8.4.0/lib/gcc/powerpc64le-unknown-linux-gnu/8.4.0 \
	-lcudart_static -ldl -lrt -pthread
```

## Compile and create LLVM IR from CUDA soruces

The LLVM IR from each branch of the compilation process must remain separate until directly linkable objects are available. As a result, there are many intermediate steps which you will need to perform manually.

LLVM IR code for the GPU must be compiled firstly to PTX code, and then assembled to a binary payload which can be linked against host object files.

There is a CUDA source in this directory, named `axpy.cu`. Let's work on that!
```
# First:
clang++ -stdlib=libc++ -Wall axpy.cu --cuda-gpu-arch=sm_70 -S -c -emit-llvm
# Or
clang++ -std=c++17 -Wall axpy.cu --cuda-gpu-arch=sm_70 -S -c -emit-llvm
```

This instruction emits two separate IR files. The GPU code needs to be compiled to PTX.
```
llc -mcpu=sm_70 axpy-cuda-nvptx64-nvidia-cuda-sm_70.ll -o axpy.ptx
```

Now the PTX code can be assembled into an ELF file and then an object file with nvcc:
```
ptxas --gpu-name=sm_70 axpy.ptx -o axpy.ptx.o
fatbinary --64 --create axpy.fatbin --image=profile=sm_70,file=axpy.ptx.o

nvcc axpy.fatbin -arch=sm_70 -dlink
```

For the host code:
```
# Option -mcpu=ppc64 is for PowerPC 64 bit
llc -mcpu=ppc64 axpy.ll -o axpy.s
clang++ -c axpy.s -o axpy.o
```

Link both object files together with a linker. In my case this worked:
```
clang++ -stdlib=libc++ axpy.o a_dlink.o -o axpy -lcudart \
  -L/scinet/mist/software/2020a/opt/cuda-10.2.89/gcc/8.4.0/lib/gcc/powerpc64le-unknown-linux-gnu/8.4.0

./axpy
```
There was a weird bug that only resolved when I placed files `crtbegin.o` and `crtend.o` in the working directory. The linker was not able to find the files with -L option.


## Playing around with LLVM IR

For more info, see the llvm lecture from [Mike Shah](http://www.mshah.io/#Teaching).

Consider `hello.cpp`:

```
#include <stdio.h>

int main(){
    printf("Bonjour!\n");
	return 0;
}
```

You can compile this code with clang easily:
```
clang++ hello.cpp -o hello
```

To print out the LLVM IR of the code:
```
clang++ -S -emit-llvm hello.cpp
```

To run the IR with the LLVM JIT (lli):
```
lli hello.ll
```

To convert IR to Bitcode (BC); you can still run the BC with `lli`:
```
llvm-as hello.ll
lli hello.bc
```

To convert BC to Assembly using `llc`: the static compiler:
```
llc hello.bc
```

To see the available targets:
```
llc hello.bc --version

# The output in my case

LLVM (http://llvm.org/):
  LLVM version 11.1.0
  Optimized build.
  Default target: powerpc64le-unknown-linux-gnu
  Host CPU: pwr9

  Registered Targets:
    nvptx   - NVIDIA PTX 32-bit
    nvptx64 - NVIDIA PTX 64-bit
    ppc32   - PowerPC 32
    ppc64   - PowerPC 64
    ppc64le - PowerPC 64 LE
```

## Playing with Optimizer (opt) to create pass(es):

Using the previous `hello.cpp`, running opt with `--time-pass` to show timing of the passes:

```
# Adding the -debug-pass-manager flag to the opt commands shows what's going on.
opt hello.ll -debug-pass-manager --time-pass
```
Refer to [this](https://llvm.org/docs/WritingAnLLVMPass.html) section to write passes.

Types of passes:
1. Analysis Pass
2. Transform Pass

Levels of passes:
1. Module Pass
2. Call Graph Pass
3. Function Pass
4. Basic Block Pass
5. Immutable Pass
6. Region Pass
7. Machine Function Pass

### Simple pass example using LLVM *Hello* example

Go to the directory `$LLVM_BUILD/build/lib/Transforms/Hello` and run `make`.
Then you should be able to see `LLVMHello.so` file in `$LLVM_BUILD/build/lib` directory.

Then by running this command you should be able to see the results:
```
opt -enable-new-pm=0 -load $LLVM_BUILD/build/lib/LLVMHello.so -hello < hello.bc
```

### How to apply a *transforming* pass

Take the previous example, `LLVMHello.so` lib:
```
# File instrumentation.ll contains a function we want to add to our program.
# File LLVMHello.so contains the code to transform our original code to include our new piece of code.

opt -load $LLVM_BUILD/build/lib/LLVMHello.so -hello4 -S < hello.ll > readyToBeHooked.ll
llvm-link readyToBeHooked.ll instrumentation.ll -S -o instrumentDemo.ll

```

