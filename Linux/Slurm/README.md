# SLURM: job scheduler

A simple job submission to slurm:

```bash
#!/bin/bash
#SBATCH -t 0-00:10
#SBATCH -A user
#SBATCH --mem=4G
./serial_hello
sleep 10m
```

- Then you can run the bash script with:

```bash
sbatch job_serial.sh
```

- Using these commands users can view job queue, cancel any specific jobs, and see history:

```bash
# Show what's waiting in the queue
squeue -u user_name
# show expected start time of jobs
squeue --start

# cancel a specific job
scancel job_id
# cancel all jobs by a specific user
scancel -u user_name 
# Cancel all the pending jobs for the user
scancel -t PENDING -u <username>
# Cancel one or more jobs by name
scancel -name <jobname>

# This one provides more details about a specified job.
scontrol show job <jobid>
# Hold a job, prevent it from starting
scontrol hold <jobid>
# Release a job hold, allowing the job to continue
scontrol resume <jobid>
# Requeue a running, suspended or finished job
scontrol requeue <jobid>
```

The `sacct` command is a flexible way to explore the properties of jobs that are queued, running or complete (in any state). The following call to `sacct` provides formatted information about the jobs for the specified user that were in any state during a specified interval.

```bash
sacct -aX -u guest171 -S2020-06-14T18:50 -o jobid,jobname%36,submit,start,state
```

For a list of output format variables available to be returned by sacct call it with the --helpformat flag as follows:

```bash
sacct --helpformat
# Output:
Account          AdminComment     AllocCPUS        AllocGRES       
AllocNodes       AllocTRES        AssocID          AveCPU          
AveCPUFreq       AveDiskRead      AveDiskWrite     AvePages        
AveRSS            AveVMSize         BlockID           Cluster          
Comment           ConsumedEnergy    ConsumedEnergyRaw CPUTime          
CPUTimeRAW        DerivedExitCode   Elapsed           ElapsedRaw       
Eligible          End               ExitCode          GID              
Group             JobID             JobIDRaw          JobName          
Layout            MaxDiskRead       MaxDiskReadNode   MaxDiskReadTask  
MaxDiskWrite      MaxDiskWriteNode  MaxDiskWriteTask  MaxPages         
MaxPagesNode      MaxPagesTask      MaxRSS            MaxRSSNode       
MaxRSSTask        MaxVMSize         MaxVMSizeNode     MaxVMSizeTask    
McsLabel          MinCPU            MinCPUNode        MinCPUTask       
NCPUS             NNodes            NodeList          NTasks           
Priority          Partition         QOS               QOSRAW           
ReqCPUFreq        ReqCPUFreqMin     ReqCPUFreqMax     ReqCPUFreqGov    
ReqCPUS           ReqGRES           ReqMem            ReqNodes         
ReqTRES           Reservation       ReservationId     Reserved         
ResvCPU           ResvCPURAW        Start             State            
Submit            Suspended         SystemCPU         Timelimit        
TotalCPU          UID               User              UserCPU          
WCKey             WCKeyID           WorkDir          
```

- Working with modules (adding popular modules to bashrc is also a good practice):

```bash
# See what modules are loaded
module list
# See available modules, in general for specific modules
module avail 
module avail gcc
# See available modules with more info.
module spider gcc
module spider gcc/8.3.0
# Load module
module load gcc/9.1.0
# Reset modules
module reset
# Module save the current list
module save list_name
# View module lists in the saved file
module list_name
# Restore the modules in a module list
module restore list_name

# I mostly use these modules (add to bashrc):
module load cuda/10.2.89
module load gcc/8.4.0
module load ibm-java
module load openmpi/4.0.3
```

- To run a parallel job for 1 hour, creat this file (job.sh):

```bash
#!/bin/bash
#SBATCH -A <account>
#SBATCH -t 0-01:00
#SBATCH -n 64
#SBATCH --mem-per-cpu=1G
srun ./mpi_application
```

- Then run with this command:

```bash
sbatch job.sh
```

Other slurm script commands:
| Command | Description |
|---------|-------------|
| #SBATCH -ntask=1 <br> #SBATCH --na  | Requests for 1 processors on task, usually 1 cpu per task |
| #SBATCH --time=0-05:00 | Sets the maximum runtime of 5 hours for the job |
| #SBATCH --mail-user=<email> | Sets the email address for sending notifications about the job state |
| #SBATCH --mail-type=BEGIN<br> #SBATCH --mail-type=END<br> #SBATCH --mail-type=FAILE<br> #SBATCH --mail-type=ALL<br> | Sets the scheduling system to send email when the job enters the respective states |
| #SBATCH --job-name=<jobname> | Sets the job name |
| #SBATCH --ntasks=X | Requests for X tasks. When cpus-per-task=1, this requests X cores. |
| #SBATCH --nodes=X | Requests a minimum X nodes |
| #SBATCH --nodes=X-Y | Requests that a minimum of X  nodes and a maximum of Y nodes be allocated for this job |
| #SBATCH --cpus-per-task=X | Requests that a minimum of X CPUs per task be allocated to this job |
| #SBATCH --tasks-per-node=X | Requests minimum of X tasks be allocated per node |
| #SBATCH --mem=4000 | Requests 4000 MB of memory in total |
| #SBATCH --mem-per-cpu=4000 | Requests 4000 MB of memory per cpu |
| #SBATCH --gres=gpu:4 | Requests 4 gpu per node (might be different in another platform |
| #SBATCH --exclusive | Requests that the job run only on the nodes with noe other running jobs |
| #SBATCH --dependency=after:<job1_id> | Requests that the job start after job1 has **started** |
| #SBATCH --dependency=afterany:<job1_id>,<job2_id> | Requests that the job start after job1 or job 2 has **finished** |
| #SBATCH --dependency=afterok:<job1_id> | Requests that the job start after job1 has **finished successfully** |
| #SBATCH --account=<account> | To submit a job to a specific accounting group or role |
| #SBATCH --temp=200G | Asks for 200GB of temporary disk space |
| #SBATCH -o <my-output-file.out> | Saves the job output to a specific file |
  
Slurm job environment variables:
  
![image](https://user-images.githubusercontent.com/10928452/137381001-3434f072-211a-4353-b387-59924458734f.png)

Get account information:

![image](https://user-images.githubusercontent.com/10928452/137381306-1d2ef542-b5be-4f88-871d-557b06ee6235.png)

Get system information:
  
![image](https://user-images.githubusercontent.com/10928452/137381360-62cea602-438b-4b71-b90a-4cdfebb577c1.png)

## Interactive jobs

- Using `salloc` command instead of `sbatch`
In this way there is no need to creat a batch file. You can submit your job with the command line itself.

```bash
# Options are: 10 minutes, 1 cpu core, 
# 4 GB of total memory, and enabled GUI:
salloc -x11 --time=0-00:10 -n 1 -A user --mem=4G
# After previous command you can run your application
./application

# For an MPI app, Options: 1 hour, 4 cpu cores,
# 4 GB of memory per core, and enabled GUI
salloc -x11 --time=0-01:00 -n 4 -A user --mem-per-cpu=4G
mpirun -n 4 ./application

# For an OpenMP app:
# 4 hardware threads, total 4 GB of memory
salloc -x11 --time=0-01:00 -c 4 -A user --mem=4G
./openmp_app
export OMP_NUM_THREADS=3 

# For GPU allocation:
# 1 node and 1 GPU
# On Graham cluster of computecanada the default is P100
# For more infor see [here](https://docs.computecanada.ca/wiki/Graham) and [here](https://docs.computecanada.ca/wiki/Using_GPUs_with_Slurm)
salloc -x11 --time=0-01:00 -n 1 -A user --mem=4G --gres=gpu:1
salloc -x11 --time=0-01:00 -n 1 -A user --mem=4G --gres=gpu:v100:1
salloc -x11 --time=0-01:00 -n 1 -A user --mem=4G --gres=gpu:t4:1
```

## How to check the used GPU-hours of a specific account

```bash
sreport cluster accountutilizationbyuser cluster=mist account=accountName  start=2020-04-01 end=2020-06-18 -t Hour --tres=GRES/gpu
```
