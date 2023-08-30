# What is Valgrind

It is a robust tool to check C/C++ programs dynamically for various bugs and errors.

## Installation and Usage on Ubuntu

```bash
sudo apt-get update
sudo apt-get install valgrind
```

As it is stated in its website, if a program runs like this:

```bash
program arg1 arg2
```

It can be checked like this:

```bash
valgrind --leak-check=yes program arg1 arg2
```

A more complete way to use valgrind is:

```bash
export G_SLICE=always-malloc
export G_DEBUG=gc-friendly
valgrind --leak-check=full --tool=memcheck --show-leak-kinds=all --track-origins=yes \
  --num-callers=40 --log-file=valgrind.log $(which <program>) <arguments>
```

The valgrind website: [here](http://valgrind.org/)
A complete manual can be found [here](http://valgrind.org/docs/manual/valgrind_manual.pdf)

## Visualize the call graph with kcachegrind

Install kcachegrind on Ubuntu or Windows WSL:

```bash
sudo apt update
sudo apt install kcachegrind
```

First, collect data with valgrind; then kacachegrind can open the output profile results:

```bash
$ valgrind --tool=callgrind --trace-children=yes -v ./application
$ kcachegrind &
# Open <callgrind.out.xxx> from the GUI
# To open graphical apps with GUI on WSL you need a running X server.
```

Kcachegrind can be used in other ways as well. Check [here](https://kcachegrind.github.io/html/Usage.html).

## Build and installation on Windows

- Remember that Valgrind is OS-specific and cannot be installed and run on Windows. However, with Linux subsystem there can be something done.

- First you need to install `Windows Subsystem for Linux`
- After completing the previous installation and configuration, follow these steps:
  
1. Download Valgrind source from [here](https://www.valgrind.org/downloads/current.html)
2. Install building tools and requirements by:

```bash
sudo apt-get install automake
sudo apt-get install build-essential
```

3. Go to Valgrind directory and run these commands (if *make* fails, run it with sudo):
   - Be patient! They will take a while.

```bash
./configure
make
make install
```

4. (Optional) To clean temporary files:

```bash
make clean
make distclean
```

Valgrind should be ready to use!
