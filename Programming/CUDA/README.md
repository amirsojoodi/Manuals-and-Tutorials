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
```bash
export LD_LIBRARY_PATH=~/nvidia-driver/compat/usr/local/cuda-11.4/compat/
```

## Use NVPROF to profile CUDA codes:

```bash
nvprof --print-gpu-summary program [args]
```

## See CUDA object dump:

If a program such as _reduction.cu_ is compiled into an executable, named _reduction_, we can dump it using this command:
```bash
cuobjdump -sass reduction > dump.asm
```

## Run NVIDIA Visual Profiler (nvvp)

- Study this [document](https://docs.nvidia.com/cuda/pdf/CUDA_Profiler_Users_Guide.pdf) to learn more about profiling. 
- To run nvvp on Windows you need to open it form the command line and pass the jvm address:
`nvvp -vm "C:\Program Files\Java\jdk1.8.0_261\bin\java.exe"`
In the time of writing this document (2020-10) nvvp doesn't work with latest versions of Oracle jdk. Try installing previous versions.

## Profile with Nsight Systems CLI

The basic command that provides most of the things you need:
```bash
nsys profile --stats true -o output your-application [arguments]
```
To profile mpi applications there are two options that produce different outputs:
```bash
nsys profile --trace=mpi,cuda,nvtx --stats true -o profile-output-file mpirun -np 2 ./application argument
# or
mpirun -np 2 nsys profile --trace=mpi,cuda,nvtx --stats true -o profile-output-file ./application argument
```
If you are using OpenMPI/4.0.3 you should add these options: `--mca pml ucx --mca btl ^smcuda` to mpirun in case you have errors.
```bash
# Complete command:
nsys profile --gpu-metrics-device=0 --trace=mpi,cuda,ucx,nvtx --stats true -o profile-output-file mpirun -np 2 --mca pml ucx --mca btl ^smcuda ./application argument
```

For more info, take a look at [here](https://docs.nvidia.com/nsight-systems/UserGuide/index.html)

## Profile with Nsight Compute CLI

To profile almost everything, here is what you need:
```bash
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

```bash
nvidia-smi -c EXCLUSIVE_PROCESS
nvidia-cuda-mps-control -d
```
For more info, see [here](https://docs.nvidia.com/deploy/mps/)

## CUDA-GDB with MPI applications

Compiling with host `–g` and device debug symbols `–G` is slow. Also, the launcher command would be very complex. The workaround is attaching the debugger later:

```c
#include <unistd.h>
if (rank == 0) {
    char name[255]; 
    gethostname(name, sizeof(name));
    bool attached;
    printf("rank %d: pid %d on %s ready to attach\n", rank, getpid(), name);
    while (!attached) { sleep(5); }
}
```

Launch process, sleep on particular rank:

```bash
$ srun –n 4 ./jacobi -niter 10
rank 0: pid 28920 on jwb0001.juwels ready to attac
```

Then attach from another terminal (may need more flags)

```bash
$ srun -n 1 --jobid ${JOBID} --pty bash –i
$ cuda-gdb --attach 28920
```

Wake up the sleeping process and continue debugging normally

```bash
(cuda-gdb) set var attached=true
```

Automatically wait for attach on exception without code changes, use option `CUDA_DEVICE_WAITS_ON_EXCEPTION`:
```bash
$ CUDA_DEVICE_WAITS_ON_EXCEPTION=1 srun ./jacobi -niter 10
Single GPU jacobi relaxation: 10 iterations on 16384 x 16384 mesh with norm check every 1 iterations
jwb0129.juwels: The application encountered a device error and CUDA_DEVICE_WAITS_ON_EXCEPTION is set. You 
can now attach a debugger to the application (PID 31562) for inspection.
```
Then, attach the debugger as before:
```bash
$ cuda-gdb --pid 31562
CUDA Exception: Warp Illegal Address
The exception was triggered at PC 0x508ca70 (jacobi_kernels.cu:88)
Thread 1 "jacobi" received signal CUDA_EXCEPTION_14, Warp Illegal Address.
[Switching focus to CUDA kernel 0, grid 4, block (0,0,0), thread (0,20,0), device 0, sm 0, warp 21, lane 0]
0x000000000508ca80 in jacobi_kernel<32, 32><<<(512,512,1),(32,32,1)>>> (/*...*/) at jacobi_kernels.cu:88
88 real foo = *((real*)nullptr);
```
For more info, see [here](https://reg.rainfocus.com/flow/nvidia/gtcspring2022/aplive/page/ap/session/16328439533020010XeY) and [there](https://docs.nvidia.com/cuda/cuda-gdb/index.html)
