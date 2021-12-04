/*
 * Source: https://github.com/llvm/llvm-project/blob/llvmorg-13.0.0/compiler-rt/lib/builtins/muloti4.c
 *
 * The goal of this code is only allow to run binary
 * which was linked against macOS 10.8 on macOS 10.7 and below.
 *
 * Such binaries are used to boostrap rust on stage0 only.
 */

//===-- muloti4.c - Implement __muloti4 -----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements __muloti4 for the compiler_rt library.
//
//===----------------------------------------------------------------------===//

#include "int_lib.h"

#ifdef CRT_HAS_128BIT

// Returns: a * b

// Effects: sets *overflow to 1  if a * b overflows

#define fixint_t ti_int
#include "int_mulo_impl.inc"

COMPILER_RT_ABI ti_int __muloti4(ti_int a, ti_int b, int *overflow) {
  return __muloXi4(a, b, overflow);
}

#endif // CRT_HAS_128BIT
