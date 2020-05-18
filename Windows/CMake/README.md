## Using cmake on windows:

Using pip, it's pretty straightforward:
```
$ pip install cmake
```

In a sample project create the CMakeLists.txt, something like this:
```
cmake_minimum_required(VERSION 3.5.1)

set(CMAKE_CXX_STANDARD 14)

project(HelloCmake)

add_executable(HelloCmake src/main.cpp src/vect_add_one.cpp src/increment_and_sum.cpp)
```
Then move the build directory and run:
```
$ cmake ..
```
If you are using Git bash in Windows with MinGW toolchain, run this:
```
$ cmake -G "MSYS Makefiles" ..
```
Followed by `make`.

### Another straightforward option to make life easier! 

Set this alias in ~/.bashrc :
```
alias cmake='cmake --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Debug "-DCMAKE_C_COMPILER:FILEPATH=C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin\gcc.exe" "-DCMAKE_CXX_COMPILER:FILEPATH=C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin\g++.exe" -G "Unix Makefiles"'
```
Remember to replace the paths with the correct ones.

