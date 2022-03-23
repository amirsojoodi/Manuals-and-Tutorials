## Common commands/scripts

### Debugging multiple processes

```
xterm -e gdb \
  ./program args
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
