---
title: 'CUDA CMake Project'
date: 2023-11-27
permalink: /posts/CUDA-CMake/
tags:
  - Programming
  - CMake
  - CUDA
  - Make
---

Modern CMake is straightforward to use, but it was not easy to find a good example of a project that builds CUDA. This post is a simple example of a CMake project that uses CUDA.

If you want more information about CMake, read [this](https://cliutils.gitlab.io/modern-cmake/).

## CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
include(CheckLanguage)

project(
  "CMakeCUDA"
  VERSION "0.1.0"
  LANGUAGES CXX CUDA)

add_custom_target("${PROJECT_NAME}")

# Check for CUDA
check_language(CUDA)

# Check if CUDA is found
if(CMAKE_CUDA_COMPILER)
  enable_language(CUDA)
  message(STATUS "Found CUDA: ${CMAKE_CUDA_COMPILER}")
  message(STATUS "CUDA Version: ${CMAKE_CUDA_COMPILER_VERSION}")
  message(STATUS "CUDA Include dirs: ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}")
  message(STATUS "CUDA Library dirs: ${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES}")

  include_directories("${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}")
  link_directories("${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES}")

  set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -Xcompiler -Wall")
  set(CMAKE_CUDA_HOST_COMPILER "${CMAKE_CUDA_COMPILER}")
  set(CMAKE_CUDA_STANDARD 17)
  set(CMAKE_CUDA_STANDARD_REQUIRED ON)
  set(CMAKE_CUDA_ARCHITECTURES "70;75;80;86")
else()
  message(FATAL_ERROR "CUDA not found.")
endif()

# Set the source directory
set(SOURCE_DIR "${PROJECT_SOURCE_DIR}/src")

# If you want build the targets seperately:

function(add_target TARGET_NAME)
  # Add the target
  add_dependencies("${PROJECT_NAME}" "${TARGET_NAME}")
  add_executable("${TARGET_NAME}" "${SOURCE_DIR}/${TARGET_NAME}.cu")
  target_link_libraries(${TARGET_NAME} PRIVATE cuda cudart)
  message(STATUS "Added target: ${TARGET_NAME}")
endfunction()

add_target("main")
```

Then you can build the project with:

```bash

# Create a build directory
mkdir build
cd build

# Configure
cmake ..

# Build
make -j8
```

And the main source can be as simple as this:

```c
// main.cu
#include <iostream>

__global__ void hello() {
  printf("Hello World from GPU!\n");
}

int main() {
  std::cout << "Hello World from CPU!" << std::endl;

  hello<<<1, 1>>>();
  cudaDeviceSynchronize();

  return 0;
}
```
