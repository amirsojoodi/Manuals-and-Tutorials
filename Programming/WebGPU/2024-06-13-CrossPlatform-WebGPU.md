---
title: 'Cross Platform WebGPU Example - Compute API'
date: 2023-06-13
permalink: /posts/Cross-Platform-WebGPU/
tags:
  - Programming
  - WebGPU
  - WASM
  - Emscripten
---

As a part of my work at [Distributive](https://distributive.network/), I developed an example providing a simple matrix multiplication using WebGPU Compute API in C++. This example is written in C++ and can be compiled to WebAssembly using Emscripten, native executable file using Dawn. The example is based on [here](https://developer.chrome.com/docs/web-platform/webgpu/build-app), and its complete source can be found [there](https://github.com/amirsojoodi/WebGPU-Playground/tree/main/Examples/12-Cross-platform-WebGPU-Compute).

## Matmult Source Code

The following is a simple matrix multiplication using WebGPU Compute API in C++. Look how the code uses callbacks to handle the asynchronous nature of the GPU operations.

```cpp
GetAdapter([]() {
  std::cout << "GPU Adapter acquired." << std::endl;
  GetDevice([]() {
    std::cout << "GPU Device acquired." << std::endl;
    RunMatMult();
  });
});
```

Here, `GetAdapter` is called first, and it gets the GPU adapter. Once the adapter is acquired, it calls the callback which calls `GetDevice` to get the GPU device. After the device is acquired, it calls `RunMatMult` to run the matrix multiplication.

See the complete source code below with the shader module written in WGSL.

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
#ifndef __EMSCRIPTEN__
  while (!work_done) {
    instance.ProcessEvents();
  }
#else
  while (!work_done) {
    emscripten_sleep(100);
  }
#endif
}
}

int main() {
  // I put the call to the RunMatMult function in a wrapper, so that
  // I can pass arguments if necessary
  RunMatMultWrapper();
  return 0;
}
```

## CMakeLists.txt

Now, you can use the following `CMakeLists.txt` to build the example for both Emscripten and Dawn.

```cmake
cmake_minimum_required(VERSION 3.13) 
project(matmult
  LANGUAGES C CXX
)                         
set(CMAKE_CXX_STANDARD 20)           

add_executable(matmult "matmult.cpp")

if(EMSCRIPTEN)
  # set_target_properties(matmult PROPERTIES SUFFIX ".html")
  
  # Create a JS file only, and not the html template file
  set_target_properties(matmult PROPERTIES SUFFIX ".js")

  # Enable WebGPU through (webgpu/webgpu.h)
  target_link_options(matmult PRIVATE "-sUSE_WEBGPU=1")

  # Help with printing stack trace, error prevention
  target_link_options(matmult PRIVATE "-sASSERTIONS=1")

  # Enable memory growth at runtime and refrain from throwing exception
  target_link_options(matmult PRIVATE "-sALLOW_MEMORY_GROWTH=1")

  # Disable WASM module generation. (Everything will be in a JS file)
  target_link_options(matmult PRIVATE "-sWASM=0")
  
  # Whether to support async operations in the compiled code. This makes it
  # possible to call JS functions from synchronous-looking code in C/C++.
  target_link_options(matmult PRIVATE "-sASYNCIFY=1")
  
  # Enable optimization in code speed and size
  target_link_options(matmult PRIVATE "-O3")

  # target_link_options(matmult PRIVATE "-sDISABLE_EXCEPTION_CATCHING=0")
  
  # Whether we will run the main() function. Disable if you embed the generated
  # code in your own, and will call main() yourself at the right time (which you
  # can do with Module.callMain()
  # target_link_options(matmult PRIVATE "-sINVOKE_RUN=0")

  # Specify which runtime environments the JS output will be capable of running
  # in.  For maximum portability this can configured to support all environments
  # or it can be limited to reduce overall code size.
  # var ENVIRONMENT = 'web,webview,worker,node';
  target_link_options(matmult PRIVATE "-sENVIRONMENT=web")

  # If set to 0, does not build in any filesystem support. Useful if you are just
  # doing pure computation, but not reading files or using any streams (including
  # fprintf, and other stdio.h things) or anything related.
  target_link_options(matmult PRIVATE "-sFILESYSTEM=0")
  
else()
  set(DAWN_FETCH_DEPENDENCIES ON)
  add_subdirectory("../../dawn" "build" EXCLUDE_FROM_ALL)
  target_link_libraries(matmult PRIVATE webgpu_cpp webgpu_dawn)
endif()
```

## Building with Emscripten

To install Emscripten, you can use emsdk github [repository](https://github.com/emscripten-core/emsdk). Install and activate it like this:

```bash
emsdk install latest
emsdk activate latest
source "/path/to/emsdk/emsdk_env.sh"
```

The current code works with the latest emscripten as the time of writing this document. (3.1.61) If you have set it up properly, you would only need to run this command in the directory where `CMakeLists.txt` is located.

```bash
emcmake cmake -B build-web && cmake --build build-web
```

The resulted `matmult.js` file is generated in the `build-web` directory, and can be run in the browser.

You can create an `index.html` file with the following content to run the generated `matmult.js` file.

```html
<!DOCTYPE html>
<html>
<head>
</head>

<body>
    <pre>Open the console!</pre>
    <script type="module" crossorigin src="./build-web/matmult.js">
    </script>
</body>

</html>
```

```bash
python3 -m http.server <port>
```

## Building with Dawn

**Attention!** This part is written before Dawn adopts the new CMake build system. Take a look at [here](https://dawn.googlesource.com/dawn/+/HEAD/docs/quickstart-cmake.md) for the latest build instructions.

You can clone Dawn (or add it as a submodule to your repo) and let CMake takes care of building it. Make sure to update the `CMakeLists.txt` file to include the Dawn library from the correct path.

```bash
# Dawn is already added as a submodule to this repo
# git submodule add https://dawn.googlesource.com/dawn --branch chromium/6478
cmake -B build && cmake --build build -j8
```

## Known Issues

For versions of Dawn before `chromium/6478`, the `dawn/src/dawn/native/Surface.cpp` file has a bug that prevents the example from running properly. My current workaround is commenting the following lines from `dawn/src/dawn/native/Surface.cpp` function `ValidateSurfaceConfiguration`, then building dawn again.

```cpp
DAWN_INVALID_IF(presentModeIt == capabilities.presentModes.end(),
                "Present mode (%s) is not supported by the adapter (%s) for this surface.",
                config->format, config->device->GetAdapter());
```
