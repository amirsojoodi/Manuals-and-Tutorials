---
title: 'Wasm + WebGPU example on DCP'
date: 2024-06-20
permalink: /posts/DCP-Wasm-WebGPU-Example/
tags:
  - Programming
  - WebGPU
  - WASM
  - DCP
  - Emscripten
---

This example is a follow-up to my [previous post](https://amirsojoodi.github.io/posts/Cross-Platform-WebGPU) on how to write a cross-platform WebGPU example. In this one, I'll demonstrate how to deploy a matmult example written in C/C++ and WebGPU in a DCP worker using WASM. Note that for verification purposes, I provide `dawn`-based native test, too, but this example doesn't need to build/install dawn in order to work.

## What is DCP?

DCP is a secure, and powerful parallel computing platform built on the web technology. For more information, take a look at [here](https://docs.dcp.dev/).

## This example

We will experiment with a matrix multiplication in C/C++ using WebGPU. The matrices are stored in a 1D array, with their dimensions as their first and second elements, and their data stored afterwards. For this example to work, we have three options:

1. Build to run natively using `dawn`
2. Build to run as a web worker using `emscripten`
3. Build to run as a DCP workload using `emscripten` <-- we are interested in this one!

### Code structure

By the end of the build process, the directory structure should look like this:

```bash
.
├── clean-and-build.sh
├── deployJob.js
├── node_modules
│   └── ...
├── package
│   ├── build-web
│   │   ├── wasm-webgpu-matmult.js
│   │   └── ...
│   ├── CMakeLists.txt
│   ├── package.dcp
│   └── src
│       ├── closebravo.js
│       ├── index.html
│       ├── openbravo.js
│       └── wasm-webgpu-matmult.cpp
├── package.json
├── package-lock.json
├── README.md
└── updateVersion.js
```

The source `./package/src/wasm-webgpu-matmult.cpp` is similar to the source from the previous post:

```cpp
#include <cstring>
#include <iostream>
#include <iterator>
#include <vector>
#include <webgpu/webgpu_cpp.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

wgpu::Instance instance;
wgpu::Adapter adapter;
wgpu::Device device;

wgpu::Buffer gpuReadBuffer;
size_t resultMatrixSize;
bool work_done = false;

// GetAdapter gets a callback function that it's get called
// after the RequestAdapter resolves.
void GetAdapter(void (*callback)()) {
  instance.RequestAdapter(
      nullptr,
      [](WGPURequestAdapterStatus status, WGPUAdapter cAdapter,
         const char *message, void *userdata) {
        if (message) {
          std::cout << "RequestAdapter message: " << message << std::endl;
        }
        if (status != WGPURequestAdapterStatus_Success) {
          std::cout << "AdapterRequest was not successfull" << std::endl;
          exit(0);
        }
        adapter = wgpu::Adapter::Acquire(cAdapter);
        // (2) Cast userdata back to the callback and then call it
        reinterpret_cast<void (*)()>(userdata)();
      },
      // (1) Cast the call back to void pointer and pass it in
      reinterpret_cast<void *>(callback));
}

// Similar to GetAdapter, the callback is called when RequestDevice resolves
void GetDevice(void (*callback)()) {
  adapter.RequestDevice(
      nullptr,
      [](WGPURequestDeviceStatus status, WGPUDevice cDevice,
         const char *message, void *userdata) {
        if (message) {
          std::cout << "RequestDevice message: " << message << std::endl;
        }
        if (status != WGPURequestDeviceStatus_Success) {
          std::cout << "AdapterRequest was not successfull" << std::endl;
          exit(0);
        }
        device = wgpu::Device::Acquire(cDevice);
        device.SetUncapturedErrorCallback(
            [](WGPUErrorType type, const char *message, void *userdata) {
              std::cout << "Error: " << type << " - message: " << message;
            },
            nullptr);
        // (2) Cast userdata back to the callback and then call it
        reinterpret_cast<void (*)()>(userdata)();
      },
      // (1) Cast the call back to void pointer and pass it in
      reinterpret_cast<void *>(callback));
}

const char shaderCode[] = R"(
    struct Matrix {
        size : vec2<f32>,
        numbers: array<f32>,
    };

    @group(0) @binding(0) var<storage, read> firstMatrix : Matrix;
    @group(0) @binding(1) var<storage, read> secondMatrix : Matrix;
    @group(0) @binding(2) var<storage, read_write> resultMatrix : Matrix;

    @compute @workgroup_size(8, 8)
    fn main(@builtin(global_invocation_id) global_id : vec3<u32>) {
        // Guard against out-of-bounds work group sizes
        if (global_id.x >= u32(firstMatrix.size.x) || global_id.y >= u32(secondMatrix.size.y)) {
            return;
        }

        resultMatrix.size = vec2(firstMatrix.size.x, secondMatrix.size.y);

        let resultCell = vec2(global_id.x, global_id.y);
        var result = 0.0;
        for (var i = 0u; i < u32(firstMatrix.size.y); i = i + 1u) {
            let a = i + resultCell.x * u32(firstMatrix.size.y);
            let b = resultCell.y + i * u32(secondMatrix.size.y);
            result = result + firstMatrix.numbers[a] * secondMatrix.numbers[b];
        }

        let index = resultCell.y + resultCell.x * u32(secondMatrix.size.y);
        resultMatrix.numbers[index] = result;
    }
)";

// This callback is called when the last mapAsync is resolved
void BufferMapCallbackFunction(WGPUBufferMapAsyncStatus status,
                               void *userdata) {

  std::cout << "In Buffer async call back, status: " << status << std::endl;

  if (status == WGPUBufferMapAsyncStatus_Success) {
    const float *resultData = static_cast<const float *>(
        gpuReadBuffer.GetConstMappedRange(0, resultMatrixSize));

    std::cout << "Result Matrix: " << std::endl;
    for (int i = 0; i < resultMatrixSize / sizeof(float); i++) {
      std::cout << resultData[i] << " ";
    }
    std::cout << std::endl;

    gpuReadBuffer.Unmap();
  } else {
    std::cout << "Failed to map result buffer" << std::endl;
  }
  *reinterpret_cast<bool *>(userdata) = true;
}

void RunMatMult() {
  // First Matrix
  const std::vector<float> firstMatrix = {2, 4, 1, 2, 3, 4, 5, 6, 7, 8};
  size_t firstMatrixSize = firstMatrix.size() * sizeof(float);

  wgpu::Buffer gpuBufferFirstMatrix =
      device.CreateBuffer(new wgpu::BufferDescriptor{
          .usage = wgpu::BufferUsage::Storage,
          .size = firstMatrixSize,
          .mappedAtCreation = true,
      });
  std::memcpy(gpuBufferFirstMatrix.GetMappedRange(), firstMatrix.data(),
              firstMatrixSize);
  gpuBufferFirstMatrix.Unmap();

  std::cout << "First Matrix: " << std::endl;
  std::copy(firstMatrix.begin(), firstMatrix.end(),
            std::ostream_iterator<float>(std::cout, " "));
  std::cout << std::endl;

  // Second Matrix
  const std::vector<float> secondMatrix = {4, 2, 1, 2, 3, 4, 5, 6, 7, 8};
  size_t secondMatrixSize = secondMatrix.size() * sizeof(float);

  wgpu::Buffer gpuBufferSecondMatrix =
      device.CreateBuffer(new wgpu::BufferDescriptor{
          .usage = wgpu::BufferUsage::Storage,
          .size = secondMatrixSize,
          .mappedAtCreation = true,
      });
  std::memcpy(gpuBufferSecondMatrix.GetMappedRange(), secondMatrix.data(),
              secondMatrixSize);
  gpuBufferSecondMatrix.Unmap();

  std::cout << "Second Matrix: " << std::endl;
  std::copy(secondMatrix.begin(), secondMatrix.end(),
            std::ostream_iterator<float>(std::cout, " "));
  std::cout << std::endl;

  // Result Matrix
  resultMatrixSize =
      sizeof(float) * (2 + static_cast<size_t>(firstMatrix[0]) *
                               static_cast<size_t>(secondMatrix[1]));

  wgpu::Buffer resultMatrixBuffer =
      device.CreateBuffer(new wgpu::BufferDescriptor{
          .usage = wgpu::BufferUsage::Storage | wgpu::BufferUsage::CopySrc,
          .size = resultMatrixSize,
      });

  // Compute shader code
  wgpu::ShaderModuleWGSLDescriptor shaderModuleDesc = {};
  shaderModuleDesc.code = shaderCode;
  wgpu::ShaderModuleDescriptor shaderModuleDescriptor{.nextInChain =
                                                          &shaderModuleDesc};
  wgpu::ShaderModule shaderModule =
      device.CreateShaderModule(&shaderModuleDescriptor);
  // Pipeline setup
  wgpu::ComputePipelineDescriptor pipelineDesc = {};
  pipelineDesc.compute.module = shaderModule;
  pipelineDesc.compute.entryPoint = "main";

  wgpu::ComputePipeline computePipeline =
      device.CreateComputePipeline(&pipelineDesc);

  // Bind group
  wgpu::BindGroupDescriptor bindGroupDesc = {};
  wgpu::BindGroupEntry entries[3] = {};
  entries[0].binding = 0;
  entries[0].buffer = gpuBufferFirstMatrix;
  entries[1].binding = 1;
  entries[1].buffer = gpuBufferSecondMatrix;
  entries[2].binding = 2;
  entries[2].buffer = resultMatrixBuffer;
  bindGroupDesc.entryCount = 3;
  bindGroupDesc.entries = entries;
  bindGroupDesc.layout = computePipeline.GetBindGroupLayout(0);

  wgpu::BindGroup bindGroup = device.CreateBindGroup(&bindGroupDesc);

  // Commands submission
  wgpu::CommandEncoder commandEncoder = device.CreateCommandEncoder();

  wgpu::ComputePassEncoder passEncoder = commandEncoder.BeginComputePass();
  passEncoder.SetPipeline(computePipeline);
  passEncoder.SetBindGroup(0, bindGroup);
  uint32_t workgroupCountX =
      static_cast<uint32_t>(std::ceil(firstMatrix[0] / 8.0f));
  uint32_t workgroupCountY =
      static_cast<uint32_t>(std::ceil(secondMatrix[1] / 8.0f));
  passEncoder.DispatchWorkgroups(workgroupCountX, workgroupCountY);
  passEncoder.End();

  // Get a GPU buffer for reading in an unmapped state
  gpuReadBuffer = device.CreateBuffer(new wgpu::BufferDescriptor{
      .usage = wgpu::BufferUsage::CopyDst | wgpu::BufferUsage::MapRead,
      .size = resultMatrixSize,
  });

  // Encode commands for copying buffer to buffer
  commandEncoder.CopyBufferToBuffer(resultMatrixBuffer, 0, gpuReadBuffer, 0,
                                    resultMatrixSize);

  // Submit GPU commands
  wgpu::CommandBuffer commands = commandEncoder.Finish();
  device.GetQueue().Submit(1, &commands);

  std::cout << "Commands submitted to the GPU Queue" << std::endl;

  gpuReadBuffer.MapAsync(wgpu::MapMode::Read, (size_t)0, resultMatrixSize,
                         BufferMapCallbackFunction,
                         reinterpret_cast<void *>(&work_done));
}

// The content of this function could be in the main()
// I wrote it like this to show how the function export works in emscripten 
// Also, we can pass necessary arguements easier from JS side. 
extern "C" {
void RunMatMultWrapper() {
  instance = wgpu::CreateInstance();

  GetAdapter([]() {
    std::cout << "GPU Adapter acquired." << std::endl;
    GetDevice([]() {
      std::cout << "GPU Device acquired." << std::endl;
      RunMatMult();
    });
  });

  // https://eliemichel.github.io/LearnWebGPU/getting-started/the-command-queue.html#device-polling
#ifdef __EMSCRIPTEN__
  while (!work_done) {
    emscripten_sleep(100);
  }
#else
  while (!work_done) {
    instance.ProcessEvents();
  }
#endif
}
}

int main() {
  RunMatMultWrapper();
  return 0;
}
```

## Requirements

- CMake
- Emscripten
- DCP setup

You can use [Emscripten SDK](https://github.com/emscripten-core/emsdk) to install all the required tools.
Make sure to set environment variables (either in bash or everytime you want to use WASM toolchain)

```bash
emsdk install latest
emsdk activate latest
source "/path/to/emsdk/emsdk_env.sh"
```

To start your DCP journey, go to [here](https://docs.dcp.dev/intro/getting-setup.html).

## Build and Run

The current example is tested with Emscripten `3.1.61` (for DCP) and dawn `chrome/6562` (as standalone).

### Build

You can build the project using `./clean-and-build.sh` script with these options:

1. DCP (to build and deploy the package)
2. web (to test the the code as a standalone web example)
3. native (to run the binary file natively, again standalone)

For `DCP` and `web` options, the script uses emscripten cmake:

```bash
emcmake cmake -B build-web && cmake --build build-web
```

For native builds, make sure to set the correct address to the `dawn` directory in the `CMakeLists.txt` and the script has CMake taking care of building it with:

```bash
cmake -B build && cmake --build build -j4

# For debugging, you can add the following option
cmake -DCMAKE_BUILD_TYPE=Debug -B build && cmake --build build -j4
```

This is the content of the `./clean-and-build.sh` script:

```bash
#!/bin/bash

set -eux

# Arg could be DCP (default), web, or native
# Default to DCP if no argument is passed
MODE="${1:-DCP}"

BUILD_DIR=package/build
BUILD_WEB_DIR=package/build-web

# Function to prompt the user for confirmation
confirm() {
  local dir="$1"
  read -r -p "Are you sure you want to remove ${dir}? [y/N] " response
  case "$response" in
  [yY][eE][sS] | [yY])
    true
    ;;
  *)
    false
    ;;
  esac
}
# Set CMake options based on the MODE
if [ "$MODE" == "DCP" ]; then
  CMAKE_OPTIONS="-DBUILD_FOR_DCP=ON"
elif [ "$MODE" == "web" ]; then
  echo "Standalone web mode is enabled. Setting DCP to off."
  CMAKE_OPTIONS="-DBUILD_FOR_DCP=OFF"
elif [ "$MODE" == "native" ]; then
  echo "Standalone native mode is enabled. Setting DCP to off."
  CMAKE_OPTIONS="-DBUILD_FOR_DCP=OFF"
else
  echo "No valid option is passed. Options are DCP (default) or local."
  CMAKE_OPTIONS="-DBUILD_FOR_DCP=ON"
  MODE="DCP"
fi

if [ "$MODE" == "native" ]; then
  if confirm "$BUILD_DIR"; then
    echo "Doing a clean build!"
    rm -rf "$BUILD_DIR"
  fi
  cmake -B build -S package -B package/build && cmake --build package/build -j4
else
  if confirm "$BUILD_WEB_DIR"; then
    echo "Doing a clean build!"
    rm -rf "$BUILD_WEB_DIR"
  fi
  emcmake cmake -S package -B package/build-web $CMAKE_OPTIONS &&
    cmake --build package/build-web -- VERBOSE=1
fi

# Run additional commands only if MODE is DCP
if [ "$MODE" == "DCP" ]; then
  node ./updateVersion.js
  npm i -g dcp-client
  publish package package/package.dcp
fi
```

- The `./package/CMakelists.txt` file:

```cmake
cmake_minimum_required(VERSION 3.13)
project(wasm-webgpu-matmult LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 20)

add_executable(wasm-webgpu-matmult "src/wasm-webgpu-matmult.cpp")

if(EMSCRIPTEN)
  # Create a JS file only, and not the html template file
  set_target_properties(wasm-webgpu-matmult PROPERTIES SUFFIX ".js")

  target_link_options(wasm-webgpu-matmult PRIVATE "-sSINGLE_FILE=1")

  # Enable WebGPU through (webgpu/webgpu.h)
  target_link_options(wasm-webgpu-matmult PRIVATE "-sUSE_WEBGPU=1")

  # Help with printing stack trace, error prevention
  target_link_options(wasm-webgpu-matmult PRIVATE "-sASSERTIONS=1")

  # Enable memory growth at runtime and refrain from throwing exception
  target_link_options(wasm-webgpu-matmult PRIVATE "-sALLOW_MEMORY_GROWTH=1")

  # Disable WASM module generation. (Everything will be in a JS file)
  # So far, passing -sWASM=0 or -sWASM=1 doesn't make any difference :-?
  target_link_options(wasm-webgpu-matmult PRIVATE "-sWASM=1")

  # Whether to support async operations in the compiled code. This makes it
  # possible to call JS functions from synchronous-looking code in C/C++.
  target_link_options(wasm-webgpu-matmult PRIVATE "-sASYNCIFY=1")

  # Enable optimization in code speed and size
  target_link_options(wasm-webgpu-matmult PRIVATE "-O3")

  target_link_options(
    wasm-webgpu-matmult PRIVATE
    "-sEXPORTED_RUNTIME_METHODS=['ccall','cwrap','callMain']"
  )

  # Symbols that are explicitly exported. These symbols are kept alive through
  # LLVM dead code elimination, and also made accessible outside of the
  # generated code even after running closure compiler (on "Module").  Native
  # symbols listed here require an ``_`` prefix. By default if this setting is
  # not specified on the command line the ``_main`` function will be implicitly
  # exported.  In STANDALONE_WASM mode the default export is ``__start`` (or
  # ``__initialize`` if --no-entry is specified). JS Library symbols can also be
  # added to this list (without the leading `$`). var EXPORTED_FUNCTIONS = [];
  target_link_options(
    wasm-webgpu-matmult PRIVATE
    "-sEXPORTED_FUNCTIONS=['_RunMatMultWrapper','_main']"
  )

  # Whether we will run the main() function. Disable if you embed the generated
  # code in your own, and will call main() yourself at the right time (which you
  # can do with Module.callMain()
  if(BUILD_FOR_DCP)
    target_link_options(wasm-webgpu-matmult PRIVATE "-sINVOKE_RUN=0")
  else()
    target_link_options(wasm-webgpu-matmult PRIVATE "-sINVOKE_RUN=1")
  endif()

  # Specify which runtime environments the JS output will be capable of running
  # in.  For maximum portability this can configured to support all environments
  # or it can be limited to reduce overall code size.
  # var ENVIRONMENT = 'web,webview,worker,node';
  target_link_options(wasm-webgpu-matmult PRIVATE "-sENVIRONMENT=worker")

  # If set to 0, does not build in any filesystem support. Useful if you are
  # just doing pure computation, but not reading files or using any streams
  # (including fprintf, and other stdio.h things) or anything related.
  target_link_options(wasm-webgpu-matmult PRIVATE "-sFILESYSTEM=1")

  if(BUILD_FOR_DCP)
    target_link_options(
      wasm-webgpu-matmult PUBLIC
      "--extern-pre-js=${PROJECT_SOURCE_DIR}/src/openbravo.js"
    )

    target_link_options(
      wasm-webgpu-matmult PUBLIC
      "--extern-post-js=${PROJECT_SOURCE_DIR}/src/closebravo.js"
    )
  endif()
  
else()
  set(DAWN_FETCH_DEPENDENCIES ON)
  add_subdirectory("../../dawn" "build" EXCLUDE_FROM_ALL)
  target_link_libraries(wasm-webgpu-matmult PRIVATE webgpu_cpp webgpu_dawn)
endif()
```

### Test in the browser without DCP

To test the example in the browser without DCP, simply open the file `index.html` under `package/src` in the browser.

Make sure to enable `WebGPU` in your browser first! For instance, if you are on Linux, and your browser is chrome-unstable, pass the necessary options:

```bash
google-chrome-unstable --enable-unsafe-webgpu --enable-features=Vulkan \ 
  --disable-dawn-features=disallow_unsafe_apis &
```

This is the `./package/src/index.html` file:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>WASM + WebGPU</title>
    <script type="module" crossorigin src="../build-web/wasm-webgpu-matmult.js"></script>
  </head>

  <body>
    <pre>Open the console!</pre>
  </body>
</html>
```

### Test the binary natively

It is unnecessary, but if you could build the standalone native binary, the result should be something like this:

```bash
$ ./package/build/wasm-webgpu-matmult

GPU Adapter acquired.
Warning: SetUncapturedErrorCallback is deprecated. Pass the callback in the device descriptor instead.
GPU Device acquired.
First Matrix: 
2 4 1 2 3 4 5 6 7 8 
Second Matrix: 
4 2 1 2 3 4 5 6 7 8 
Commands submitted to the GPU Queue
Warning: Old MapAsync APIs are deprecated. If using C please pass a CallbackInfo struct that has two userdatas. Otherwise, if using C++, please use templated helpers.
In Buffer async call back, status: 1
Result Matrix: 
2 2 50 60 114 140 
Warning: No Dawn device lost callback was set. This is probably not intended. If you really want to ignore device lost and suppress this message, set the callback explicitly.
```

### Deploying the job on DCP

Again, the script `./clean-and-build.sh DCP` performs the necessary preparation steps. More specifically:

1. The code gets built and wrapped between `openbravo.js` and `closebravo.js` under the `package/src/` directory to make it a DCP-friendly module.
2. The version number under package/package.dcp will be update
3. The npm package `dcp-client` will be installed
4. The source `wasm-webgpu-matmult.js` under `package/build-web/` will be deployed.

After that, the job can be deployed to the scheduler specified in the environment variable `DCP_SCHEDULER_LOCATION`. Make sure you have valid authentication keys. Also, note that the current deploy function in `deployJob.js` deploys the job to the default compute group.

- The `./updateVersion.js` script which is used to update the version number in the `./package/package.dcp` file:

```js
const fs = require('node:fs');
const content = JSON.parse(
  fs.readFileSync('./package/package.dcp', { encoding: 'utf8' }),
);

const version = content.version.split('.');
version[2] = +version[2] + 1;
content.version = version.join('.');

fs.writeFileSync('./package/package.dcp', JSON.stringify(content), {
  encoding: 'utf8',
});
```

- The `./package/src/package.dcp` file:

```json
{
  "name": "wasm-webgpu-matmult",
  "version": "0.0.19",
  "files": {
    "./build-web/wasm-webgpu-matmult.js": "wasm-webgpu-matmult.js"
  }
}
```

- The `./package/src/openbravo.js` file:

```js
// file name: openbravo.js

// This is a BravoJS module definition, generated for DCP
module.declare([], function(require, exports, module) {
```

- The `./package/src/closebravo.js` file:

```js
// file name: closebravo.js

exports.Module = Module;
exports.ccall = ccall;
exports.cwrap = cwrap;
});

// This concludes the BravoJS module definition
```

- This is the content of the `./deployJob.js` script:

```js
#!/usr/bin/env node

async function workFn(sliceNumber, arg) {
  progress();
  const { Module } = require('wasm-webgpu-matmult.js');

  async function matmult() {
    // cwrap(function name, return type, args type); null means void here
    RunMatMultWrapper = Module.cwrap('RunMatMultWrapper', 'null', ['null'], {
      async: true,
    });
    await RunMatMultWrapper();
  }

  return new Promise((res) => {
    if (Module.onRuntimeInitialized) {
      const result = matmult();
      res(result);
    } else {
      Module.onRuntimeInitialized = () => {
        const result = matmult();
        res(result);
      };
    }
  });
}

async function deployJob() {
  await require('dcp-client').init();

  let startTime;

  const compute = require('dcp/compute');
  const wallet = require('dcp/wallet');

  const job = compute.for([1], workFn, [0]);

  // Get the stringified message from the worker and log
  job.on('console', (message) => console.log(message));

  // job.requirements.discrete = true;
  job.on('accepted', () => {
    console.log(' - Job accepted by scheduler, waiting for results');
    console.log(` - Job has id ${job.id}`);
    startTime = Date.now();
  });

  job.on('readystatechange', (arg) => {
    console.log(`new ready state: ${arg}`);
  });

  job.on('result', (ev) => {
    console.log(
      ` - Received result for slice ${ev.sliceNumber} at ${
        Math.round((Date.now() - startTime) / 100) / 10
      }s`,
    );
  });

  job.on('status', (ev) => {
    console.log('Got status update: ', ev);
  });

  job.on('error', (message) => console.log(message));

  const ks = await wallet.get(); /* usually loads ~/.dcp/default.keystore */
  job.requires(['wasm-webgpu-matmult/wasm-webgpu-matmult.js']);
  job.public.name = 'wasm-webgpu-matmult';
  job.requirements.environment = { webgpu: true };
  job.setPaymentAccountKeystore(ks);

  const results = await job.exec();
  console.log('results=', Array.from(results));
}

exports.deployJob = deployJob;
deployJob();
```

To deploy the job, simply run:

```bash
node deployJob.js
```

The current code has a lot of logging messages, so you should see something like the following as the output:

```bash
$ node deployJob.js
new ready state: exec
new ready state: init
new ready state: preauth
new ready state: deploying
new ready state: listeners
new ready state: compute-groups
new ready state: uploading
new ready state: deployed
 - Job accepted by scheduler, waiting for results

{
  level: 'log',
  message: [ 'GPU Adapter acquired.' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ 'GPU Device acquired.' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ 'First Matrix: ' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ '2 4 1 2 3 4 5 6 7 8 ' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ 'Second Matrix: ' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ '4 2 1 2 3 4 5 6 7 8 ' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ 'Commands submitted to the GPU Queue' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ 'In Buffer async call back, status: 0' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ 'Result Matrix: ' ],
  sliceNumber: 1
}
{
  level: 'log',
  message: [ '2 2 50 60 114 140 ' ],
  sliceNumber: 1
}
 - Received result for slice 1 at 5.2s
Got status update:  {
  runStatus: 'finished',
  total: 1,
  distributed: 1,
  computed: 1,
}
```

Some points:

1. The deployJob script, deploys the one-slice job with the entry point `workFn`. When a worker picks up a job slice, it starts to execute this function.
2. Before we can call any function from the generated WASM module we should wait for the runtime to be initialized. This is done like this:

```js
  const { Module } = require('wasm-webgpu-matmult.js');

  if (Module.onRuntimeInitialized) {
    // the module is already initialized
    // ...
  } else {
    // the module is not initialized, we will set a callback  
    Module.onRuntimeInitialized = () => {
      // ..
    };
  }
```

3. Next, the function `RunMatMultWrapper` gets called, and as we need its return value, the function should behave synchronously. However, the example in C++ `wasm-webgpu-matmult.cpp` uses callbacks everywhere (to hanle device and adapter initialization, etc.). According to [here](https://eliemichel.github.io/LearnWebGPU/getting-started/the-command-queue.html#device-polling), on the C/C++ side, we need to wait a little bit, and importantly to call tick/poll the device so that it updates its awaiting tasks. This is a part of the API that is not standard yet, so we must adapt our implementation to the backend.
4. All the optinos in `CMakeLists.txt` is explained to some extent. Note that we need the `-sASYNCIFY` option, specifically, so that we can `await` on the `cwrap`ed function from our `workFn` in JS.

```js
RunMatMultWrapper = Module.cwrap('RunMatMultWrapper', 'null', ['null'], {async: true});
await RunMatMultWrapper();
```

There you go! An example of how to deploy a WebGPU example on DCP using WASM. You can find the complete source of this post [here](https://github.com/Distributive-Network/dcp-wasm-webgpu-example)
