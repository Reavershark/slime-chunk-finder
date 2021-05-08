#!/usr/bin/env bash
set -e

ldc2 \
  -mtriple=wasm32-unknown-unknown-wasm \
  -Oz \
  -betterC \
  -L-allow-undefined \
  -L-no-entry \
  -L-strip-all \
  wasm/wasm.d \
  --of=public/wasm.wasm

rm public/wasm.o
