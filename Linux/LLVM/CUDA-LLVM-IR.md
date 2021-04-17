## Create LLVM IR from CUDA soruces and orchestrate the build process manually

The LLVM IR from each branch of the compilation process must remain separate until directly linkable objects are available. As a result, there are many intermediate steps which you will need to perform manually. LLVM IR code for the GPU must be compiled firstly to PTX code, and then assembled to a binary payload which can be linked against host object files.
There is a CUDA source in this directory, named `axpy.cu`. Let's work on that!

**The important hint:**
The `fatbin` file should be passed to the host-side compilation command with `-Xclang -fcuda-include-gpubinary -Xclang axpy.fatbin` to replicate the whole compilation behavior.

```lang-mk
BIN_FILE=axpy
SRC_FILE=$(BIN_FILE).cu

main: $(BIN_FILE)

# Host Side
$(BIN_FILE).ll: $(SRC_FILE) $(BIN_FILE).fatbin
    clang++ -stdlib=libc++ -Wall -Werror $(BIN_FILE).cu -march=ppc64le --cuda-host-only -relocatable-pch \
        -Xclang -fcuda-include-gpubinary -Xclang $(BIN_FILE).fatbin -S -g -c -emit-llvm

$(BIN_FILE).o: $(BIN_FILE).ll
    llc -march=ppc64le $(BIN_FILE).ll -o $(BIN_FILE).s
    clang++ -c -Wall $(BIN_FILE).s -o $(BIN_FILE).o

# GPU Side
# This instruction emits two an IR file which should be compiled to PTX later:
$(BIN_FILE)-cuda-nvptx64-nvidia-cuda-sm_70.ll: $(SRC_FILE)
    clang++ -x cuda -stdlib=libc++ -Wall -Werror $(BIN_FILE).cu --cuda-device-only \
        --cuda-gpu-arch=sm_70 -S -g -emit-llvm

$(BIN_FILE).ptx: $(BIN_FILE)-cuda-nvptx64-nvidia-cuda-sm_70.ll
    llc -march=nvptx64 -mcpu=sm_70 -mattr=+ptx64 $(BIN_FILE)-cuda-nvptx64-nvidia-cuda-sm_70.ll -o $(BIN_FILE).ptx

$(BIN_FILE).ptx.o: $(BIN_FILE).ptx
    ptxas -m64 --gpu-name=sm_70 $(BIN_FILE).ptx -o $(BIN_FILE).ptx.o

$(BIN_FILE).fatbin: $(BIN_FILE).ptx.o
    fatbinary --64 --create $(BIN_FILE).fatbin --image=profile=sm_70,file=$(BIN_FILE).ptx.o \
        --image=profile=compute_70,file=$(BIN_FILE).ptx -link

$(BIN_FILE)_dlink.o: $(BIN_FILE).fatbin
    nvcc $(BIN_FILE).fatbin -gencode arch=compute_70,code=sm_70 \
        -dlink -o $(BIN_FILE)_dlink.o -lcudart -lcudart_static -lcudadevrt

# Link both object files together (either nvcc or clang works here):
$(BIN_FILE): $(BIN_FILE).o $(BIN_FILE)_dlink.o
    nvcc $(BIN_FILE).o $(BIN_FILE)_dlink.o -o $(BIN_FILE) -arch=sm_70 -lc++
```
After running the executable file, the output should be like this:
```
$ ./axpy 
y[0] = 2
y[1] = 4
y[2] = 6
y[3] = 8
```

Figure 1 in this [link](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#cuda-compilation-trajectory) includes the creation steps of the fatbinary file.

There was a weird bug that only resolved when I placed files `crtbegin.o` and `crtend.o` in the working directory. The linker was not able to find the files with -L option.
