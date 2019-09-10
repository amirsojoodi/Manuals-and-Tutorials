## What is Valgrind

It is a robust tool to check C/C++ programs dynamically for various bugs and errors.

## Installation and Usage on Ubuntu 

```
$ sudo apt-get update
$ sudo apt-get install valgrind
```
As it is stated in its website, if a program runs like this:
```
$ program arg1 arg2
```
It can be checked like this:
```
$ valgrind --leak-check=yes program arg1 arg2
```
A more complete way to use valgrind is:
```
$ export G_SLICE=always-malloc
$ export G_DEBUG=gc-friendly
$ valgrind -v --tool=memcheck --leak-check=full --num-callers=40 --log-file=valgrind.log $(which <program>) <arguments>
```

The valgrind website: [here](http://valgrind.org/)
A complete manual can be found [here](http://valgrind.org/docs/manual/valgrind_manual.pdf)
