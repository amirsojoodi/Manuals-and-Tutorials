## Common commands/scripts

### Building MPI applications 

It is a good idea to run commands like `mpicc --showme:compile` in a dynamic fashion to find out what is required for building and linking. For instance, GNU Make allows running commands and assigning their results to variables:

```Makefile
CC=mpicc
MPI_COMPILE_FLAGS = $(shell mpicc --showme:compile)
MPI_LINK_FLAGS = $(shell mpicc --showme:link)

my_app: my_app.c
        $(CC) $(MPI_COMPILE_FLAGS) app.c $(MPI_LINK_FLAGS) -o app
```

### Debugging multiple processes

- If you want to start the application using GDB:
```bash
$ xterm -e gdb \
  ./program args

# and using mpirun
$ mpirun -n 4 xterm -e gdb my_mpi_application
```
If you want to debug multi-node applications, you should specify `$DISPLAY` variable prior to running the app. See [here](https://docs.open-mpi.org/en/v5.0.x/app-debug/serial-debug.html)

- If you want to attach to the process using GDB, you can add the following code snippet to the source and attach GDB to the process(es) you would like:

```c
// At the beginning of the code, or anywhere before the section you want to debug.
{ 
    volatile int i = 0;
    char hostname[256];
    gethostname(hostname, sizeof(hostname));
    printf("PID %d on %s ready for attach\n", getpid(), hostname);
    fflush(stdout);
    while (0 == i)
        sleep(5);
}
```

And after running the app, use `gdb --pid [pid]` to attach to the process.

Once, attached, set variable `i` to something else, so it can break the while.
```
(gdb) set var i = 7
```

### Profile with Nsight Systems

If MPI build is CUDA-enabled, profiling with nsys is available:

```
nsys profile --gpu-metrics-device=0 --trace=mpi,ucx,cuda -o reportName.%q{SLURM_PROCID} \
  ./program args
```

### Find and use the topology of the system

```
nvidia-smi topo -m
```

Use this Case to bind processes to cores correctly, e.g.:
```
case ${SLURM_LOCALID} in
0)
    export CUDA_VISIBLE_DEVICES=0
    export UCX_NET_DEVICES=mlx5_1:1
    CPU_BIND=18-23
    ;;
1)
    export CUDA_VISIBLE_DEVICES=1
    export UCX_NET_DEVICES=mlx5_0:1
    CPU_BIND=6-11
    ;;
2)
    export CUDA_VISIBLE_DEVICES=2
    export UCX_NET_DEVICES=mlx5_3:1
    CPU_BIND=42-47
    ;;
3)
    export CUDA_VISIBLE_DEVICES=3
    export UCX_NET_DEVICES=mlx5_2:1
    CPU_BIND=30-35
    ;;
esac

# Run with numactl to bind processes to cores
numactl --physcpubind=${CPU_BIND} $*
```

Another way to bind application and memory to the NUMA node:
```
numactl --cpunodebind=0 --membind=0 ./app
```

### Use compute-sanitizer

Options `--log-file` and `--save` do the same thing.

```
mpirun -np 4 compute-sanitizer \
  --log-file report.%q{SLURM_PROCID}.log \
  --save report.%q{SLURM_PROCID}.compute-sanitizer \
  ./program arguments
```

Compile with `–lineinfo` to get generate line correlation for device code

Read the log file using
```
compute-sanitizer --read <save file>
```

## Useful runtime options

```bash
# Open MPI options
# --mca btl_openib_want_cuda_gdr 1 \
# --mca btl ^vader,tcp,openib,uct -x UCX_NET_DEVICES=mlx5_0:1 \
# --mca btl_openib_want_cuda_gdr 1 --mca btl_openib_if_include mlx5_1 \
# --mca btl_smcuda_cuda_ipc_verbose 100
# --mca mpi_common_cuda_verbose 100 \
# --mca btl_smcuda_cuda_ipc_verbose 100 \
# --mca btl_base_verbose 100 \
# --mca pml_base_verbose 100 \
# --mca mtl_base_verbose 10 \
# --mca pml_ucx_verbose 10 \
# --mca opal_cuda_verbose 100 \
# --mca coll_base_verbose 100 \
# --mca mpi_common_cuda_verbose 100 \
# export OMPI_MCA_coll_cuda_priority=80 \
# --mca opal_common_ucx_tls all \
# --mca opal_common_ucx_devices all \
# --mca pml_ucx_tls any \
# --mca pml_ucx_devices any \

# UCX options
# -x UCX_TLS=rc,sm,cuda_copy,gdr_copy,cuda_ipc \
# -x UCX_LOG_LEVEL=trace -x UCX_LOG_FILE=ucx.%p.log \
# -x UCX_RNDV_THRESH=0 -x UCX_ZCOPY_THRESH=0 --validation
# -x UCX_LOG_LEVEL=info -x UCX_PROTO_ENABLE=y -x UCX_PROTO_INFO=y \
# --mca pml_monitoring_enable x (0,1,2)
```
