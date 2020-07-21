## About Pandoc

Pandoc is a universal document converter. Read more [here](https://pandoc.org/index.html)

## Install Pandoc

You can obtain pandoc installer from [here](https://pandoc.org/installing.html)
Or you can install it with choco:
```
$ choco install pandoc
```

## Add Templates

If you want to add templates to pandoc, you should figure out its working directory. You can obtain its working directory by checking the output of `pandoc --version`, e.g:
```
pandoc.exe 2.10.1
Compiled with pandoc-types 1.21, texmath 0.12.0.2, skylighting 0.8.5
Default user data directory: C:\Users\USERNAME\AppData\Roaming\pandoc
Copyright (C) 2006-2020 John MacFarlane
Web:  https://pandoc.org
This is free software; see the source for copying conditions.
There is no warranty, not even for merchantability or fitness
for a particular purpose.
```
You can create a directory named `Templates` in the obtained directory and put your templates there.

