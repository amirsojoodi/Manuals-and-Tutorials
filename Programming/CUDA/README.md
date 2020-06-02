### Use NVPROF to profile CUDA codes:

```
$ nvprof --print-gpu-summary program [args]
```

### See CUDA object dump:

If a program such as _reduction.cu_ is compiled into an executable, named _reduction_, we can dump it using this command:
```
$ cuobjdump -sass reduction > dump.asm
```
