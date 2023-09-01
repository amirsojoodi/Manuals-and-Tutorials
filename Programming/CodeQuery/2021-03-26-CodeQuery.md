---
title: 'Code Query'
date: 2021-03-26
permalink: /posts/CodeQuery/
tags:
  - Programming
  - CodeQuery
  - C/C++
---

Find the complete manuals here:

1. [How-to for Linux](https://ruben2020.github.io/codequery/doc/HOWTO-LINUX.html)
2. [How-to for Windows](https://ruben2020.github.io/codequery/windows-install/wincommon/HOWTO-WINDOWS.txt)

## HOW TO USE CODEQUERY WITH C/C++ CODE?

Change directory to the base folder of your source code like this:

```bash
cd ~/projects/myproject/src
```

Create a cscope.files file with all the C/C++ source files listed in it. Files with inline assembly code should be excluded from this list.

```bash
find . -iname "*.c"    > ./cscope.files
find . -iname "*.cpp" >> ./cscope.files
find . -iname "*.cxx" >> ./cscope.files
find . -iname "*.cc " >> ./cscope.files
find . -iname "*.h"   >> ./cscope.files
find . -iname "*.hpp" >> ./cscope.files
find . -iname "*.hxx" >> ./cscope.files
find . -iname "*.hh " >> ./cscope.files
```

Create a cscope database like this (add k, if you don't want standard include paths like for stdio.h):

```bash
cscope -cb
```

Create a ctags database like this.

```bash
ctags --fields=+i -n -L ./cscope.files
```

Run cqmakedb to create a CodeQuery database out of the cscope and ctags databases, like this:

```bash
cqmakedb -s ./myproject.db -c ./cscope.out -t ./tags -p
```

Open myproject.db using the CodeQuery GUI tool by running the following. Wild card search (\* and ?) supported if Exact Match is switched off. Or use cqsearch, the CLI-version of CodeQuery (type cqsearch -h for more info).

```bash
codequery
```

Use `cqmakedb -h` to get help on cqmakedb command line arguments.

## Resources

- [Website](https://ruben2020.github.io/codequery/)
- [Github page](https://github.com/ruben2020/codequery)
- [VS Code extension](https://marketplace.visualstudio.com/items?itemName=ruben2020.codequery4vscode)
