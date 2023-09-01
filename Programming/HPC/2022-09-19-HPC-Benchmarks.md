---
title: 'HPC Applications and Benchmarks'
date: 2022-09-19
permalink: /posts/HPC-Applications-and-Benchmarks
tags:
  - Programming
  - HPC
  - Benchmark
---

## Benchmark Suites

1. Transaction Processing Performance Council (TPC) - (https://www.tpc.org/default5.asp)

2. OSU Micro Benchmarks (OMB) - (https://github.com/forresti/osu-micro-benchmarks):

3. Intel MPI Benchmarks (IMB) - (https://github.com/intel/mpi-benchmarks):

4. DOE Mini applications (https://portal.nersc.gov/project/CAL/doe-miniapps.htm)

5. Coral Benchmark Suite (https://asc.llnl.gov/coral-2-benchmarks)

6. ECP Suite (https://proxyapps.exascaleproject.org/ecp-proxy-apps-suite/)

7. Spec (http://www.spec.org/benchmarks.html)

8. LLNL Proxy Apps - Lawrence Livermore National Lab. (https://computing.llnl.gov/projects/asc-proxy-apps)

9. Graph500 (ttps://graph500.org/)

10. Deep500 (https://www.deep500.org/)

11. Splash (https://github.com/SakalisC/Splash-3)

12. NCCL/RCCL Tests

13. Linux-rdma Perftest (https://github.com/linux-rdma/perftest)

## Generic HPC Benchmarks

1. HPL - High Performance Linpack (https://netlib.org/benchmark/hpl/):
   - Factoring and solving large dense system of linear equations
   - Dominant calculation is matrix-matrix multiplication (mostly done by GPU today)

2. HPCG - High Performance Conjugate Gradient (https://hpcg-benchmark.org/)
   - Complement HPL and target a broader set of HPC applications governed by differential
   equations, which tend to have much stronger needs for high bandwidth and low latency
   - Tend to access data using irregular patterns
   - Iterative and heavily use neighborhood collectives

3. HPCC (https://hpcchallenge.org/hpcc/)
   - Consist of 7 test (HPL is one of them)
   - Each test focuses on a different aspect, e.g. floating point, memory access, communication, etc.

## Some of HPC Application-Level Benchmarks

1. WRF - Weather Research and Forecasting (https://www.mmm.ucar.edu/weather-research-and-forecasting-model)
   - Numerical weather prediction system

2. GROMACS (https://www.gromacs.org)
   - Molecular dynamics
   - Primarily designed for biochemical molecules like proteins, lipids and nucleic acids
   - Differential equations, linear algebra, 3D stencil, 3D FFT
   - Uses OpenMP

3. LAMMPS - Large-scale Atomic/Molecular Massively Parallel Simulator (https://www.lammps.org)
   - Molecular dynamics
   - Focus on materials modeling, solid state and soft matter
   - Conjugate gradient, DFT
   - Multiple benchmarks (Lenard-Jones, polymer chain, eam, etc.)

4. OpenFOAM (https://www.openfoam.com/)
   - Computational Fluid Dynamic
   - Includes chemical reactions, turbulence/heat transfer, acoustics, solid mechanics/electromagnetics, aerodynamics

5. NAMD (http://www.ks.uiuc.edu/Research/namd/)
   - Molecular dynamic - large bio-molecular systems
   - Based on Charm++

6. LS-Dyna (https://www.lstc.com/products/ls-dyna)
   - Structural analysis
   - Car crash, explosions, deformation, jet engine blade containment, bird strike
   - Stencils, system of PDEs

7. Fluent (https://www.ansys.com/products/fluids/ansys-fluent)
   - Fluids, acoustic, optics, avionics, etc.

## ML Benchmarks

1. Deep Bench from Baidu (https://github.com/baidu-research/DeepBench)
   - Uses the neural network libraries to benchmark the performance of basic operations
   - Dense matrix multiplication, convolutions and communication

2. PARAM from Meta (https://github.com/facebookresearch/param)
   - Repository of communication and compute micro-benchmarks as well as full workloads
   - stand-alone compute and communication benchmarks using cuDNN, MKL, NCCL, MPI libraries
   - Application benchmarks - DLRM at this point
   - ML Framework - pytorch

## Other Micro Benchmarks and Proxy Apps

1. Adios (https://github.com/ornladios/ADIOS/releases): ADIOS is developed as part of the United States Department of Energy's Exascale Computing Project. It is a framework for scientific data I/O to publish and subscribe to data when and where required.

2. ExaMiniMD (https://github.com/ECP-copa/ExaMiniMD/releases/tag/1.0): ExaMiniMD is a proxy application and research vehicle for particle codes, in particular Molecular Dynamics (MD). Compared to previous MD proxy apps (MiniMD, COMD), its design is significantly more modular in order to allow independent investigation of different aspects.

3. MACSio (https://github.com/LLNL/MACSio): MACSio is being developed to fill a long existing void in co-design proxy applications that allow for I/O performance testing and evaluation of tradeoffs in data models, I/O library interfaces and parallel I/O paradigms for multi-physics, HPC applications.

4. mcb (https://computing.llnl.gov/projects/co-design/mcb): The Monte Carlo Benchmark (MCB) is intended for use in exploring the computational performance of Monte Carlo algorithms on parallel architectures.

5. OpenMD (https://github.com/OpenMD/OpenMD): OpenMD is an open source molecular dynamics engine which is capable of efficiently simulating liquids, proteins, nanoparticles, interfaces, and other complex systems using atom types with orientational degrees of freedom (e.g. "sticky" atoms, point dipoles, and coarse-grained assemblies).

6. SAMRAI (https://github.com/LLNL/SAMRAI): SAMRAI (Structured Adaptive Mesh Refinement Application Infrastructure) is an object-oriented C++ software library that enables exploration of numerical, algorithmic, parallel computing, and software issues associated with applying structured adaptive mesh refinement (SAMR) technology in large-scale parallel application development. SAMRAI provides software tools for developing SAMR applications that involve coupled physics models, sophisticated numerical solution methods, and which  require high-performance parallel computing hardware. SAMRAI enables integration of SAMR technology into existing codes and simplifies the exploration of SAMR methods in new application domains.

7. Siesta (https://gitlab.com/siesta-project/siesta/-/releases): SIESTA is both a method and its computer program implementation, to perform efficient electronic structure calculations and ab initio molecular dynamics simulations of molecules and solids. SIESTA's efficiency stems from the use of strictly localized basis sets and from the implementation of linear-scaling algorithms which can be applied to suitable systems.

8. SimpleMOC (https://github.com/ANL-CESAR/SimpleMOC/tree/v4): The purpose of this mini-app is to demonstrate the performance characterterics and viability of the Method of Characteristics (MOC) for 3D neutron transport calculations in the context of full scale light water reactor simulation.

9. souffle (https://github.com/souffle-lang/souffle/releases): Souffle is a logic programming language inspired by Datalog. It overcomes some of the limitations in classical Datalog. For example, programmers are not restricted to finite domains, and the usage of functors (intrinsic, user-defined, records/constructors, etc.) is permitted. Souffl´e has a component model so that large logic projects can be expressed.

10. sphynx (https://astro.physik.unibas.ch/en/people/ruben-cabezon/sphynx/): SPHYNX is an SPH hydrocode with its focus on Astrophysical applications. SPHYNX includes state-of-the-art methods that allow it to address subsonic hydrodynamical instabilities and strong shocks, which are ubiquitous in astrophysical scenarios. SPHYNX, is of Newtonian type and grounded on the Euler-Lagrange formulation of the smoothed-particle hydrodynamics technique.

11. splatt (https://github.com/ShadenSmith/splatt): SPLATT is a library and C API for sparse tensor factorization. SPLATT supports shared-memory parallelism with OpenMP and distributed-memory parallelism with MPI.

12. sw4lite-RAJA (https://github.com/geodynamics/sw4lite/tree/RAJA-v1.0): sw4lite is a bare bone version of SW4 (https://github.com/geodynamics/sw4) intended for testing performance optimizations in a few important numerical kernels of SW4.

13. thornado mini (https://github.com/ECP-Astro/thornado mini): Thornado mini solves the equation of radiative transfer in the multi-group two-moment approximation. The Discontinuous Galekin (DG) method is used for spatial discretization, and an implicit-explicit (IMEX) method is used to integrate the moment equations in time. The hyperbolic (streaming) part is treated explicitly, while the collision term is treated implicitly.

14. Trillinos (https://github.com/trilinos/Trilinos): The Trilinos Project is an effort to develop algorithms and enabling technologies within an object-oriented software framework for the solution of large-scale, complex multi-physics engineering and scientific problems. A unique design feature of Trilinos is its focus on packages.

15. tycho2 (https://github.com/lanl/tycho2): A mini-app for neutral-particle, discreteordinates (SN), transport on parallel-decomposed meshes of tetrahedra.

16. vlasiator (https://github.com/fmihpc/vlasiator/releases/tag/v5.1): In Vlasiator, ions are represented as velocity distribution functions, while electrons are magnetohydrodynamic fluid, enabling a self-consistent global plasma simulation that can describe multi-temperature plasmas to resolve non-MHD processes that currently cannot be self-consistently described by the existing global space weather simulations. The novelty is that by modelling ions as velocity distribution functions the outcome will be numerically noiseless.

17. vmd (https://www.ks.uiuc.edu/Research/vmd/): VMD is a molecular visualization program for displaying, animating, and analyzing large biomolecular systems using 3-D graphics and built-in scripting.

18. WRF (https://github.com/wrf-model/WRF/releases/tag/v4.2.1): WRF is a stateof-the-art atmospheric modeling system designed for both meteorological research and numerical weather prediction. It offers a host of options for atmospheric processes and can run on a variety of computing platforms.

19. yambo (https://github.com/yambo-code/yambo): YAMBO implements ManyBody Perturbation Theory (MBPT) methods (such as GW and BSE) and TimeDependent Density Functional Theory (TDDFT), which allows for accurate prediction of fundamental properties as band gaps of semiconductors, band alignments, defect quasi-particle energies, optics and out-of-equilibrium properties of materials.

20. arbor-0.3 (https://github.com/arbor-sim/arbor): Arbor is a high-performance library for computational neuroscience simulations with multi-compartment, morphologicallydetailed cells, from single cell models to very large networks. Arbor is written from the ground up with many-cpu and gpu architectures in mind, to help neuroscientists effectively use contemporary and future HPC systems to meet their simulation needs.

21. Caffe-MPI (https://github.com/Caffe-MPI/Caffe-MPI.github.io): The Caffe-MPI is designed for high density GPU clusters; The new version supports InfiniBand (IB) high speed network connection and shared storage system that can be equipped by distributed file system, like NFS and GlusterFS. The training dataset is read in parallel for each MPI process. The hierarchical communication mechanisms were developed to minimize the bandwidth requirements between computing nodes.

22. CFDEMcoupling (https://github.com/CFDEMproject/CFDEMcoupling-PUBLIC): CFDEM® coupling provides an open source parallel coupled CFD-DEM framework combining the strengths of LIGGGHTS® DEM code and the Open Source CFD package OpenFOAM®(*). The CFDEM®coupling toolbox allows to expand standard CFD solvers of OpenFOAM®(*) to include a coupling to the DEM code LIGGGHTS®.

23. Elemental (https://github.com/elemental/Elemental/releases/tag/v0.87.7): Elemental is a modern C++ library for distributed-memory dense and sparse-direct linear algebra, conic optimization, and lattice reduction. The library was initially released in Elemental: A new framework for distributed memory dense linear algebra and absorbed, then greatly expanded upon, the functionality from the sparse-direct solver Clique, which was originally released during a project on Parallel Sweeping Preconditioners.

24. Gadget (https://wwwmpa.mpa-garching.mpg.de/gadget/): GADGET-4 is a massively parallel code for N-body/hydrodynamical cosmological simulations. It is a flexible code that can be applied to a variety of different types of simulations, offering a number of sophisticated simulation algorithms.

25. hemelb (https://github.com/hemelb-codes/hemelb): HemeLB uses the lattice Boltzmann method to simulate fluid flow in complex geometries, such as a blood vessel network.

26. horovod (https://github.com/horovod/horovod/releases): Horovod is a distributed deep learning training framework for TensorFlow, Keras, PyTorch, and Apache MXNet. The goal of Horovod is to make distributed deep learning fast and easy to use.

27. meshkit (https://bitbucket.org/fathomteam/meshkit.git/src): MeshKit is an opensource library of mesh generation functionality. MeshKit has general mesh manipulation and generation functions such as Copy, Move, Rotate and Extrude mesh. In addition, new quad mesh and embedded boundary Cartesian mesh algorithm (EBMesh) are developed to be used. Interfaces to several public-domain tetrahedral meshing algorithms (Gmsh, netgen) are also offered.

28. metag partitioning (https://github.com/ParBLiSS/metag partitioning): Parallel metagenomic assembler designed to handle very large datasets. Program identifies the disconnected subgraphs in the de Bruijn graph, partitions the input dataset and runs a popular assember Velvet independently on the partitions. This software is a high performance version of the khmer library for assembly.

29. MITgcm (https://github.com/MITgcm/MITgcm): it can be used to study both atmospheric and oceanic phenomena; one hydrodynamical kernel is used to drive forward both atmospheric and oceanic models it has a non-hydrostatic capability and so can be used to study both small-scale and large scale processes.

30. MLSL-IntelMLSL (https://github.com/intel/MLSL): Intel(R) Machine Learning Scaling Library (Intel(R) MLSL) is a library providing an efficient implementation of communication patterns used in deep learning.

31. mxx (https://github.com/patflick/mxx): mxx is a C++/C++11 template library for MPI. The main goal of this library is to provide two things: First, simplified, efficient, and type-safe C++11 bindings to common MPI operations. Second, a collection of scalable, high-performance standard algorithms for parallel distributed memory architectures, such as sorting.

32. Nek5000 (https://github.com/Nek5000/nekRS/releases/tag/v21.1): High-order methods have the potential to overcome the current limitations of standard CFD solvers.It features state-of-the-art, scalable algorithms that are fast and efficient on platforms ranging from laptops to the world's fastest computers. Applications span a wide range of fields, including fluid flow, thermal convection, combustion and magnetohydrodynamics.

33. phyml (https://github.com/stephaneguindon/phyml): PhyML is a software package that uses modern statistical approaches to analyse alignments of nucleotide or amino acid sequences in a phylogenetic framework. The main tool in this package builds phylogenies under the maximum likelihood criterion. It implements a large number of substitution models coupled to efficient options to search the space of phylogenetic tree topologies.

34. PrincetonCBEMDMPI (https://github.com/PrincetonUniversity/PrincetonCBEMDMPI): CBEMD: Parallel Molecular Dynamics Under Various Thermodynamic Ensembles.

35. Lulesh (https://github.com/LLNL/LULESH): LULESH is a highly simplified application, hard-coded to only solve a simple Sedov blast problem with analytic answers
    - but represents the numerical algorithms, data motion, and programming style typical in scientific C or C++ based applications.

36. miniVite (https://github.com/Exa-Graph/miniVite): miniVite is a proxy app that implements a single phase of Louvain.

37. ntchemini (https://github.com/fiber-miniapp/ntchem-mini): NTChem is a high-performance software package for the molecular electronic structure calculation for general purpose on the K computer.

## Mantevo

1. miniAMR (https://github.com/Mantevo/miniAMR): miniAMR applies a stencil calculation on a unit cube computational domain, which is divided into blocks. The blocks all have the same number of cells in each direction and communicate ghost values with neighboring blocks.

2. miniMD (https://github.com/Mantevo/miniMD): miniMD is a parallel molecular dynamics (MD) simulation package written in C++ and intended for use on parallel supercomputers and new architechtures for testing purposes. The software package is meant to be simple, lightweight, and easily adaptable to new hardware.

3. miniFE (https://github.com/Mantevo/miniFE/releases): MiniFE is an proxy application for unstructured implicit finite element codes. It is a similar to HPCCG and pHPCCG but provides a much more complete vertical covering of the steps in this class of applications.

4. miniSMAC (https://github.com/Mantevo/miniSMAC/releases): Solves the finite-differenced 2D incompressible Navier-Stokes equations with Spalart-Allmaras oneequation turbulence model on a structured body conforming grid. The grid is partitioned into subgrids load balanced for the number of MPI ranks requested by the user

5. miniTri (https://github.com/Mantevo/miniTri): miniTri is a proxy for a class of triangle based data analytics (Mantevo). This simple code is a self-contained piece of C++ software that uses triangle enumeration with a calculation of specific vertex and edge properties.

6. miniAero (https://github.com/Mantevo/miniAero/releases): MiniAero is a mini-application for the evaulation of programming models and hardware for next generation platforms. MiniAero is an explicit (using RK4) unstructured finite volume code that solves the compressible Navier-Stokes equations.

7. miniXyce (https://github.com/Mantevo/miniXyce): At this time, miniXyce is a simple linear circuit simulator with a basic parser that performs transient analysis on any circuit with resistors (R), inductors (L), capacitors (C), and voltage/current sources. The parser incorporated into this version of miniXyce is a single pass parser, where the netlist is expected to be flat (no hierarchy via subcircuits is allowed). Simulating the system of DAEs generates a nonsymmetric linear problem, which is solved using un-preconditioned GMRES. The time integration method used in miniXyce is backward Euler with a constant time-step. The simulator outputs all the solution variables at each time step in a 'prn' file.

References:

1. Broadcom presentation in MUG'22
2. https://hpc.dmi.unibas.ch/wp-content/uploads/sites/87/2022/08/msc_project_nderim_shatri.pdf
