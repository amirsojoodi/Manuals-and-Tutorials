## Setup and debug with Arm-forge client (Arm DDT)

[Arm Forge](https://www.arm.com/products/development-tools/server-and-hpc/forge) is a set of tools for HPC development, debugging, and profiling. The server version is not free, but if you have access to a cluster that has Arm Forge as one of its module, then you can access it with its free client. 

0. Load Arm Forge module in the cluster node. If you want a specific version you need to specify it, like:
```
$ module load arm-forge/21.0.3
```

1. [Download](https://developer.arm.com/tools-and-software/server-and-hpc/downloads/arm-forge) and install the same version of Arm Forge client.

2. In the client, add the remote server configuration. The GUI asks to input any password. If you want to pre-load any modules to be able to use by the application, you can load them in your `~/.bashrc`. If you find another way, please share with me.

3. After the connection is established, you can run and debug the application by browsing the executable file, setting its arguments, passing MPI options, and selecting what you want to profile (CUDA, OpenMP, Memory, ...).
