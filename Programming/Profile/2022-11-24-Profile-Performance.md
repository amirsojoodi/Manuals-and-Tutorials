---
title: 'Profile Code performance'
date: 2022-11-24
permalink: /posts/Profile-Code-Performance
tags:
  - Programming
  - Profile
  - C/C++
  - Performance
---

Profile and performance tuning of CPU codes

## Separate debug code from compiled executable

1. Compile with debug information

```bash
gcc -O3 -g3 -o program.out program.c
```

GCC debug options: `-g{1, 2, 3}` or `--gdb{1, 2, 3}`

{:start="2"}
2. Extract the debug information from the executable

```bash
objcopy --only-keep-debug ./program.out ./program.out.debuginfo
```

{:start="3"}
3. Strip the debug information from the executable

```bash
strip --strip-debug --strip-unneeded ./program.out
```

{:start="4"}
4. Set executable's debug information location to be the debug information file:

```bash
objcopy --add-gnu-debuglink=./program.out.debuginfo ./program.out
```

The whole process works even with optimization flags.

## Profile memory usage

```bash
memusage ./program.out
```

Creating a bit map:

```bash
memusage --data=mem.dat ./program.out
memusagestat mem.dat mem.png
# or
memusagestat -t mem.dat mem.png
```

## Measure using time command

```bash
/usr/bin/time -v ./program.out
```

## Get performance stats

Get information including cache miss, page faults, branch prediction, etc.

```bash
perf stat ./program.out
# Adding -d option gives more information
perf stat -d -d -d ./program.out
# Add repeat (e.g. 3)
perf stat -d -d -d -r 3 ./program.out
```
