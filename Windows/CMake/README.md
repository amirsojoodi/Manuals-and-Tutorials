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
