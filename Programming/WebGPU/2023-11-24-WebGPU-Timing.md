---
title: 'WebGPU Timestamp'
date: 2023-11-24
permalink: /posts/WebGPU-Timestamp/
tags:
  - Programming
  - JavaScript
  - WebGPU
  - Timestamp
  - Measure
---

> This documentation is a part of my work at [Distributive](https://distributive.network/).

As stated in the dawn updates [here](https://developer.chrome.com/blog/new-in-webgpu-119/#dawn-updates), dawn now supports timestamp queries. "Timestamp queries allow WebGPU applications to measure precisely (down to the nanosecond) how much time their GPU commands take to execute." This is a very useful feature for performance analysis. So, in this post, I will show how to use timestamp queries in WebGPU and JavaScript. (The complete source can be found [here](https://github.com/amirsojoodi/WebGPU-Playground/blob/main/Examples/09-Timing.js))

## Requestion timing features

To request the timing feature, we need to add the `timestamp` feature to the `features` field of the `GPUDeviceDescriptor` object. Then, we can create a device with this descriptor.

```js
const adapter = await navigator.gpu.requestAdapter();
const device = await adapter.requestDevice({
  requiredFeatures: ['timestamp-query'],
});
```

## Creating timestamp buffers

To create a timestamp buffer, we need to create a `GPUQuerySet` object with the `timestamp` type. Then, we can create a `GPUBuffer` object with the `QUERY_RESOLVE` usage. The `GPUBuffer` object will be used to store the timestamp values.

```js
const querySet = device.createQuerySet({
  type: 'timestamp',
  count: 2, // We need two timestamps for instance 
});

const timestampBuffer = device.createBuffer({
  size: 16, // 2 * 8 bytes
  usage: GPUBufferUsage.QUERY_RESOLVE | GPUBufferUsage.COPY_SRC,
});
```

Then, we create read buffers to read the timestamp values from the GPU.

```js
const queryReadBuffer = device.createBuffer({
  size: 16, // 2 * 8 bytes
  usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ,
});
```

## Recording timestamps

To record timestamps, we need to call the `writeTimestamp` method of the `GPUCommandEncoder` object. This method takes two arguments: the `GPUQuerySet` object and the index of the timestamp in the query set. The index should be in the range of `[0, count - 1]`.

```js

// Recording the initial timestamp after creating the command encoder
encoder.writeTimestamp(querySet, 0);

// the rest of the commands for the command encoder

// Recording the final timestamp before finishing the command encoder
encoder.writeTimestamp(querySet, 1);
```

**Important**: `writeTimeStamp` cannot be called within a pass: any time between calls to `beginComputePass()` and `passEncoder.end()` methods.

## Resolving timestamps

To resolve the timestamp values, we need to call the `resolveQuerySet` method of the `GPUCommandEncoder` object. This method takes three arguments: the `GPUQuerySet` object, the index of the first timestamp in the query set, and the number of timestamps to resolve. The index should be in the range of `[0, count - 1]`. The number of timestamps to resolve should be in the range of `[1, count - index]`.

This method should be called before command encoder is finished. Then, we can copy the timestamp values from the `GPUBuffer` object to the read buffer.

```js
// Resolving the timestamps
encoder.resolveQuerySet(querySet, 0, 2, timestampBuffer, 0);

// Copying the timestamp values to the read buffer
encoder.copyBufferToBuffer(timestampBuffer, 0, queryReadBuffer, 0, 16);

// Finishing the command encoder
const gpuCommands = encoder.finish();
device.queue.submit([gpuCommands]);
```

## Reading timestamp values

To read the timestamp values, we need to map the read buffer to the host memory. Then, we can read the timestamp values from the mapped buffer.

```js
// Mapping the read buffer to the host memory
await queryReadBuffer.mapAsync(GPUMapMode.READ);

// Reading the timestamp values from the mapped buffer
const timestamps =
      new BigUint64Array(queryReadBuffer.getMappedRange()).slice();

console.log(`Elapsed time: ${(timestamps[1] - timestamps[0]) ns}`);

// If want to convert the elapsed time to microseconds:
console.log(`Matrix multiplication on the device took: ${
      Number(timestamps[1] - timestamps[0]) / 1000.0} us`);

// And at the end, unmap the buffers.
queryReadBuffer.unmap();
querryBuffer.destroy();
queryReadBuffer.destroy();
```

## References

- [Timestamp in WebGPU Spec](https://www.w3.org/TR/webgpu/#timestamp)
- [Dawn updates in Chrome 119](https://developer.chrome.com/blog/new-in-webgpu-119/#dawn-updates)
