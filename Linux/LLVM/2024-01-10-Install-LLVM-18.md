---
title: 'Install and configure LLVM 18 on Ubuntu 20.04'
date: 2024-01-10
permalink: /posts/Install-LLVM-on-Ubuntu/
tags:
  - Linux
  - Ubuntu
  - LLVM
  - Clang
---

In earlier posts, I wrote about how to compile a CUDA code with Clang and LLVM on Ubtuntu. Check the LLVM tag.

In this post, I dumped required steps to install LLVM+Clang 18 on Ubuntu 20.04.

I used apt to install the packages; checkout the apt packages of LLVM [here](https://apt.llvm.org/).

First of all, update the source addresses for your package manager. In the cases similar to mine, add these lines to `/etc/apt/source.list`:

```bash
deb http://apt.llvm.org/focal/ llvm-toolchain-focal main
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main
# 16
deb http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main
# 17
deb http://apt.llvm.org/focal/ llvm-toolchain-focal-17 main
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-17 main
```

If you scroll down to *development branch*, you can see installation commands to config LLVM 18.

Basically, you might not need all of the tools.

```bash
# LLVM
apt-get install libllvm-18-ocaml-dev libllvm18 llvm-18 llvm-18-dev llvm-18-doc llvm-18-examples llvm-18-runtime
# Clang and co
apt-get install clang-18 clang-tools-18 clang-18-doc libclang-common-18-dev libclang-18-dev libclang1-18 clang-format-18 python3-clang-18 clangd-18 clang-tidy-18
# compiler-rt
apt-get install libclang-rt-18-dev
# polly
apt-get install libpolly-18-dev
# libfuzzer
apt-get install libfuzzer-18-dev
# lldb
apt-get install lldb-18
# lld (linker)
apt-get install lld-18
# libc++
apt-get install libc++-18-dev libc++abi-18-dev
# OpenMP
apt-get install libomp-18-dev
# libclc
apt-get install libclc-18-dev
# libunwind
apt-get install libunwind-18-dev
# mlir
apt-get install libmlir-18-dev mlir-18-tools
# bolt
apt-get install libbolt-18-dev bolt-18
# flang
apt-get install flang-18
# wasm support
apt-get install libclang-rt-18-dev-wasm32 libclang-rt-18-dev-wasm64 libc++-18-dev-wasm32 libc++abi-18-dev-wasm32 libclang-rt-18-dev-wasm32 libclang-rt-18-dev-wasm64
```

In my case, I had to install some other libs at some point:

```bash
sudo apt install libc++-dev libc++abi-dev
sudo apt install libstdc++-10-dev
```
