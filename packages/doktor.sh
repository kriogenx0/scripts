#!/usr/bin/env sh

# GCC FIX
if [[ ! -e /usr/bin/g++ && -e /usr/bin/llvm-g++-4.2 ]]; then
  ln -s /usr/bin/llvm-g++-4.2 /usr/bin/g++
fi

if [[ ! -e /usr/bin/gcc && -e /usr/bin/llvm-gcc-4.2 ]]; then
  ln -s /usr/bin/llvm-gcc-4.2 /usr/bin/gcc
fi
