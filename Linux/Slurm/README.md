## SLURM: a job scheduler

A simple job submission to slurm:
```
#!/bin/bash
#SBATCH -t 0-00:10
#SBATCH -A user
#SBATCH --mem=4G
./serial_hello
sleep 10m
```
- Then you can run the bash script with:
```
$ sbatch job_serial.sh
```

- Using these commands users can view job queue, cancel any specific jobs, and see history:
```
// Show what's waiting in the queue
$ squeue -u user_name
// cancel a specific job
$ scancel job_id
// cancel all jobs by a specific user
$ scancel -u user_name 
//
$ sacct [-s start_time]
```

- Working with modules (adding popular modules to bashrc is also a good practice):
```
// See what modules are loaded
$ module list
// See available modules, in general for specific modules
$ module avail 
$ module avail gcc
// See available modules with more info.
$ module spider gcc
$ module spider gcc/8.3.0
// Load module
$ module load gcc/9.1.0
// Reset modules
$ module reset
// Module save the current list
$ module save list_name
// View module lists in the saved file
$ module list_name
// Restore the modules in a module list
$ module restore list_name

//I mostly use these modules (add to bashrc):
module load cuda/10.2.89
module load gcc/8.4.0
module load ibm-java
module load openmpi/4.0.3
```

- Run a parallel job for 1 hour, creat this file (job.sh):
```
#!/bin/bash
#SBATCH -A def-queensu
#SBATCH -t 0-01:00
#SBATCH -n 64
#SBATCH --mem-per-cpu=1G
srun ./mpi_application
```
- Run with this command:
```
$ sbatch job.sh
```

### Interactive jobs:

- Using `salloc` command instead of `sbatch`
In this way there is no need to creat a batch file. You can submit your job with the command line itself.
```
// Options are: 10 minutes, 1 cpu core, 
// 4 GB of total memory, and enabled GUI:
$ salloc -x11 --time=0-00:10 -n 1 -A user --mem=4G
// After previous command you can run your application
$ ./application

// For an MPI app, Options: 1 hour, 4 cpu cores,
// 4 GB of memory per core, and enabled GUI
$ salloc -x11 --time=0-01:00 -n 4 -A user --mem-per-cpu=4G
$ mpirun -n 4 ./application

// For an OpenMP app:
// 4 hardware threads, total 4 GB of memory
$ salloc -x11 --time=0-01:00 -c 4 -A user --mem=4G
$ ./openmp_app
$ export OMP_NUM_THREADS=3 

// For GPU allocation:
// 1 node and 1 GPU
// On Graham cluster of computecanada the default is P100
// For more infor see [here](https://docs.computecanada.ca/wiki/Graham) and [here](https://docs.computecanada.ca/wiki/Using_GPUs_with_Slurm)
$ salloc -x11 --time=0-01:00 -n 1 -A user --mem=4G --gres=gpu:1
$ salloc -x11 --time=0-01:00 -n 1 -A user --mem=4G --gres=gpu:v100:1
$ salloc -x11 --time=0-01:00 -n 1 -A user --mem=4G --gres=gpu:t4:1
```

