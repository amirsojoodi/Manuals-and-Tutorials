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

### Profile with Nsight Systems CLI

The basic command that provides most of the things you need:
```
nsys profile --stats true -o output your-application [arguments]
```
To profile mpi applications there are two options that produce different outputs:
```
nsys profile --trace=mpi,cuda,nvtx --stats true -o profile-output-file mpirun -np 2 ./application argument
# or
mpirun -np 2 nsys profile --trace=mpi,cuda,nvtx --stats true -o profile-output-file ./application argument
```
If you are using OpenMPI/4.0.3 you should add these options: `--mca pml ucx --mca btl ^smcuda` to mpirun in case you have errors.
```
# Complete command:
nsys profile --trace=mpi,cuda,nvtx --stats true -o profile-output-file mpirun -np 2 --mca pml ucx --mca btl ^smcuda ./application argument
```

For more info, take a look at [here](https://docs.nvidia.com/nsight-systems/UserGuide/index.html)

### Profile with Nsight Compute CLI

To profile almost everything, here is what you need:
```
ncu --export output --force-overwrite --target-processes application-only \
  --replay-mode kernel --kernel-regex-base function --launch-skip-before-match 0 
  --section ComputeWorkloadAnalysis
  --section InstructionStats
  --section LaunchStats
  --section MemoryWorkloadAnalysis
  --section MemoryWorkloadAnalysis_Chart
  --section MemoryWorkloadAnalysis_Tables
  --section Nvlink
  --section Nvlink_Tables
  --section Nvlink_Topology
  --section Occupancy
  --section SchedulerStats
  --section SourceCounters
  --section SpeedOfLight
  --section SpeedOfLight_RooflineChart
  --section WarpStateStats
  --sampling-interval auto
  --sampling-max-passes 5
  --sampling-buffer-size 33554432
  --profile-from-start 1 --cache-control all --clock-control base 
  --apply-rules yes --import-source no --check-exit-code yes 
  your-appication [arguments]
```

For more info, see [here](https://docs.nvidia.com/nsight-compute/NsightCompute/index.html).
