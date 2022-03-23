## Forward compatibility on CUDA 11.x 
Tested on Power systems with RHEL8

Problem with different toolchain and unsupported driver can be resolved through here: https://docs.nvidia.com/deploy/cuda-compatibility/index.html
With this feature, users can access some of new GPU features on their current systems without having the admins update the GPU drivers.

- Download and extract the compatibility files from the current version of NVIDIA Driver for V100
(Get the link from NVIDIA Driver Download [page](https://www.nvidia.com/Download/))
```bash
cd ~

wget https://us.download.nvidia.com/tesla/470.82.01/nvidia-driver-local-repo-rhel8-470.82.01-1.0-1.ppc64le.rpm
mkdir nvidia-driver
mv nvidia-driver-local-repo-rhel8-470.82.01-1.0-1.ppc64le.rpm nvidia-driver
cd nvidia-driver

# Extract rpm file
rpm2cpio nvidia-driver-local-repo-rhel8-470.82.01-1.0-1.ppc64le.rpm | cpio -idv
mkdir compat
mv var/nvidia-driver-local-repo-rhel8-470.82.01/cuda-compat-11-4-470.82.01-1.ppc64le.rpm compat
cd compat
rpm2cpio cuda-compat-11-4-470.82.01-1.ppc64le.rpm | cpio -idv

# Now the compatibility files should be in this path:
ls ~/nvidia-driver/compat/usr/local/cuda-11.4/compat
```
`libcuda.so  libcuda.so.1  libcuda.so.470.82.01  libnvidia-ptxjitcompiler.so.1  libnvidia-ptxjitcompiler.so.470.82.01`

Set the `LD_LIBRARY_PATH` to point to this folder before build. Now it should be fine.
```
export LD_LIBRARY_PATH=~/nvidia-driver/compat/usr/local/cuda-11.4/compat/
```

## Use NVPROF to profile CUDA codes:

```bash
nvprof --print-gpu-summary program [args]
```

## See CUDA object dump:

If a program such as _reduction.cu_ is compiled into an executable, named _reduction_, we can dump it using this command:
```
cuobjdump -sass reduction > dump.asm
```

## Run NVIDIA Visual Profiler (nvvp)

- Study this [document](https://docs.nvidia.com/cuda/pdf/CUDA_Profiler_Users_Guide.pdf) to learn more about profiling. 
- To run nvvp on Windows you need to open it form the command line and pass the jvm address:
`nvvp -vm "C:\Program Files\Java\jdk1.8.0_261\bin\java.exe"`
In the time of writing this document (2020-10) nvvp doesn't work with latest versions of Oracle jdk. Try installing previous versions.

## Profile with Nsight Systems CLI

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
nsys profile --gpu-metrics-device=0 --trace=mpi,cuda,ucx,nvtx --stats true -o profile-output-file mpirun -np 2 --mca pml ucx --mca btl ^smcuda ./application argument
```

For more info, take a look at [here](https://docs.nvidia.com/nsight-systems/UserGuide/index.html)

## Profile with Nsight Compute CLI

To profile almost everything, here is what you need:
```
ncu --export output --force-overwrite --target-processes application-only \
  --replay-mode kernel --kernel-regex-base function --launch-skip-before-match 0 \
  --section ComputeWorkloadAnalysis \
  --section InstructionStats \
  --section LaunchStats \
  --section MemoryWorkloadAnalysis \
  --section MemoryWorkloadAnalysis_Chart \
  --section MemoryWorkloadAnalysis_Tables \
  --section Nvlink \
  --section Nvlink_Tables \
  --section Nvlink_Topology \
  --section Occupancy \
  --section SchedulerStats \
  --section SourceCounters \
  --section SpeedOfLight \
  --section SpeedOfLight_RooflineChart \
  --section WarpStateStats \
  --sampling-interval auto \
  --sampling-max-passes 5 \
  --sampling-buffer-size 33554432 \
  --profile-from-start 1 --cache-control all --clock-control base \
  --apply-rules yes --import-source no --check-exit-code yes \
  your-appication [arguments]
```

For more info, see [here](https://docs.nvidia.com/nsight-compute/NsightCompute/index.html).

## Enabling MPS

Run these commands to enable MPS.

```
nvidia-smi -c EXCLUSIVE_PROCESS
nvidia-cuda-mps-control -d
```
For more info, see [here](https://docs.nvidia.com/deploy/mps/)
