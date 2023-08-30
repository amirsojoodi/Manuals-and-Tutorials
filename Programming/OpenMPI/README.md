# OpenMPI for Dummies

OpenMPI has a huge documentation base, but I thought a simple and summarized document may be helpful. To read more, visit:

- https://github.com/open-mpi/ompi
- http://open-mpi.org/

## OpenMPI abstraction layer architecture

OpenMPI has three abstraction layer.

1. **Open, Portable Access Layer (OPAL)**: OPAL is the bottom layer of Open MPI's abstractions. Its abstractions are focused on individual processes (versus parallel jobs). It provides utility and glue code such as generic linked lists, string manipulation, debugging controls, and other mundane—yet necessary—functionality. OPAL also provides Open MPI's core portability between different operating systems, such as discovering IP interfaces, sharing memory between processes on the same server, processor and memory affinity, high-precision timers, etc.
2. **Open MPI Run-Time Environment (ORTE)** (pronounced "or-tay"): An MPI implementation must provide not only the required message passing API, but also an accompanying run-time system to launch, monitor, and kill parallel jobs. In Open MPI's case, a parallel job is comprised of one or more processes that may span multiple operating system instances, and are bound together to act as a single, cohesive unit. It will be replaced by PRRTE in OpenMPI 5.0.
3. **Open MPI (OMPI)**: The MPI layer is the highest abstraction layer and is the only one exposed to applications. The MPI API is implemented in this layer, as are all the message passing semantics defined by the MPI standard.

![image](https://user-images.githubusercontent.com/10928452/144649248-c796fe0b-a4ee-459b-bb70-b778610f064d.png)

## OpenMPI Plugin architecture

The component concept is utilized throughout all three layers of Open MPI, and in each layer, there are many different types of components. Each type of component is enclosed in a framework. A component belongs to exactly one framework, and a framework supports exactly one kind of component.

![image](https://user-images.githubusercontent.com/10928452/144649443-4ae0c0c6-4b9c-410c-8c82-06ae438266bd.png)

Open MPI's set of layers, frameworks, and components is referred to as the **Modular Component Architecture (MCA)**.

### MPI layer frameworks

Here is a list of all the component frameworks in the MPI layer of
Open MPI:

- `bml`: BTL management layer
- `coll`: MPI collective algorithms
- `fbtl`: file byte transfer layer: abstraction for individual blocking and non-blocking read and write operations
- `fcoll`: Collective read and write operations for MPI I/O.
- `fs`: File system functions for MPI I/O.
- `hook`: Make calls at various points of MPI process life-cycle.
- `io`: MPI I/O
- `mtl`: Matching transport layer, used for MPI point-to-point messages on some types of networks
- `op`: Back end computations for intrinsic MPI_Op operators
- `osc`: MPI one-sided communications
- `pml`: MPI point-to-point management layer
- `part`: MPI Partitioned communication.
- `sharedfp`: shared file pointer operations for MPI I/O
- `topo`: MPI topology routines
- `vprotocol`: Protocols for the "v" PML

### Miscellaneous frameworks

- `allocator`: Memory allocator
- `backtrace`: Debugging call stack backtrace support
- `btl`: Point-to-point Byte Transfer Layer
- `dl`: Dynamic loading library interface
- `hwloc`: Hardware locality (hwloc) versioning support
- `if`: OS IP interface support
- `installdirs`: Installation directory relocation services
- `memchecker`: Run-time memory checking
- `memcpy`: Memory copy support
- `memory`: Memory management hooks
- `mpool`: Memory pooling
- `patcher`: Symbol patcher hooks
- `pmix`: Process management interface (exascale)
- `rcache`: Memory registration cache
- `reachable`: Reachability matrix between endpoints of a given pair of hosts
- `shmem`: Shared memory support (NOT related to OpenSHMEM)
- `smsc`: Shared Memory Single Copy
- `threads`: Thread management and support.
- `timer`: High-resolution timers

### Framework notes

Each framework typically has one or more components that are used at run-time.  For example, the `btl` framework is used by the MPI layer to send bytes across different types underlying networks.  The `tcp` `btl`, for example, sends messages across TCP-based networks; the `ucx` `pml` sends messages across InfiniBand-based networks.

Each component typically has some tunable parameters that can be changed at run-time.  Use the `ompi_info` command to check a component to see what its tunable parameters are.  For example:

```bash
shell$ ompi_info --param btl tcp
```

shows some of the parameters (and default values) for the `tcp` `btl` component (use `--level` to show *all* the parameters; see below).

Note that `ompi_info` only shows a small number a component's MCA parameters by default.  Each MCA parameter has a "level" value from 1 to 9, corresponding to the MPI-3 MPI_T tool interface levels.  In Open MPI, we have interpreted these nine levels as three groups of three:

1. End user / basic
2. End user / detailed
3. End user / all
4. Application tuner / basic
5. Application tuner / detailed
6. Application tuner / all
7. MPI/OpenSHMEM developer / basic
8. MPI/OpenSHMEM developer / detailed
9. MPI/OpenSHMEM developer / all

Here's how the three sub-groups are defined:

1. End user: Generally, these are parameters that are required for correctness, meaning that someone may need to set these just to get their MPI/OpenSHMEM application to run correctly.
2. Application tuner: Generally, these are parameters that can be used to tweak MPI application performance.
3. MPI/OpenSHMEM developer: Parameters that either don't fit in the other two, or are specifically intended for debugging/development of Open MPI itself.

Each sub-group is broken down into three classifications:

1. Basic: For parameters that everyone in this category will want to see.
2. Detailed: Parameters that are useful, but you probably won't need to change them often.
3. All: All other parameters -- probably including some fairly esoteric parameters.

To see *all* available parameters for a given component, specify that
ompi_info should use level 9:

```bash
shell$ ompi_info --param btl tcp --level 9
```

These values can be overridden at run-time in several ways. At run-time, the following locations are examined (in order) for new values of parameters:

1. `PREFIX/etc/openmpi-mca-params.conf`:
   This file is intended to set any system-wide default MCA parameter values -- it will apply, by default, to all users who use this Open
   MPI installation.  The default file that is installed contains many comments explaining its format.

2. `$HOME/.openmpi/mca-params.conf`:
   If this file exists, it should be in the same format as `PREFIX/etc/openmpi-mca-params.conf`.  It is intended to provide per-user default parameter values.

3. environment variables of the form `OMPI_MCA_<name>` set equal to a `VALUE`:
   Where `<name>` is the name of the parameter.  For example, set the variable named `OMPI_MCA_btl_tcp_frag_size` to the value 65536 (Bourne-style shells):

   ```bash
   OMPI_MCA_btl_tcp_frag_size=65536
   export OMPI_MCA_btl_tcp_frag_size
   ```

4. the `mpirun`/`oshrun` command line: `--mca NAME VALUE`

   Where `<name>` is the name of the parameter.  For example:

   ```bash
   mpirun --mca btl_tcp_frag_size 65536 -np 2 hello_world_mpi
   ```

These locations are checked in order.  For example, a parameter value passed on the `mpirun` command line will override an environment variable; an environment variable will override the system-wide defaults.

Each component typically activates itself when relevant.  For example, the usNIC component will detect that usNIC devices are present and will automatically be used for MPI communications.  The SLURM component will automatically detect when running inside a SLURM job and activate itself.  And so on. Components can be manually activated or deactivated if necessary, of course.  The most common components that are manually activated, deactivated, or tuned are the `btl` components -- components that are used for MPI point-to-point communications on many types common networks.

For example, to *only* activate the `tcp` and `self` (process loopback) components are used for MPI communications, specify them in a comma-delimited list to the `btl` MCA parameter:

```bash
mpirun --mca btl tcp,self hello_world_mpi
```

To add shared memory support, add `sm` into the command-delimited list (list order does not matter):

```bash
mpirun --mca btl tcp,sm,self hello_world_mpi
```

(there used to be a `vader` BTL for shared memory support; it was renamed to `sm` in Open MPI v5.0.0, but the alias `vader` still works as well)

To specifically deactivate a specific component, the comma-delimited list can be prepended with a `^` to negate it:

```bash
mpirun --mca btl ^tcp hello_mpi_world
```

The above command will use any other `btl` component other than the `tcp` component.
