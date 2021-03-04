### Use NVPROF to profile CUDA codes:

```
$ nvprof --print-gpu-summary program [args]
```

### See CUDA object dump:

If a program such as _reduction.cu_ is compiled into an executable, named _reduction_, we can dump it using this command:
```
$ cuobjdump -sass reduction > dump.asm
```

### Run NVIDIA Visual Profiler (nvvp)

- Study this [document](https://docs.nvidia.com/cuda/pdf/CUDA_Profiler_Users_Guide.pdf) to learn more about profiling. 
- To run nvvp on Windows you need to open it form the command line and pass the jvm address:
`nvvp -vm "C:\Program Files\Java\jdk1.8.0_261\bin\java.exe"`
In the time of writing this document (2020-10) nvvp doesn't work with latest versions of Oracle jdk. Try installing previous versions.
