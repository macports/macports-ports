--- src/atomic/macosx/SDL_atomic.c.orig	2009-08-14 14:59:31.000000000 -0700
+++ src/atomic/macosx/SDL_atomic.c	2009-08-14 15:01:53.000000000 -0700
@@ -165,7 +165,7 @@
 /* 8 bit atomic operations */
 
 Uint8
-SDL_AtomicExchange8(Uint8 * ptr, Uint8 value)
+SDL_AtomicExchange8(volatile Uint8 * ptr, Uint8 value)
 {
 #ifdef nativeExchange8
    return nativeExchange8(ptr, value);
@@ -182,7 +182,7 @@
 }
 
 SDL_bool
-SDL_AtomicCompareThenSet8(Uint8 * ptr, Uint8 oldvalue, Uint8 newvalue)
+SDL_AtomicCompareThenSet8(volatile Uint8 * ptr, Uint8 oldvalue, Uint8 newvalue)
 {
 #ifdef nativeCompareThenSet8
    return (SDL_bool)nativeCompareThenSet8(ptr, oldvalue, newvalue);
@@ -202,7 +202,7 @@
 }
 
 SDL_bool
-SDL_AtomicTestThenSet8(Uint8 * ptr)
+SDL_AtomicTestThenSet8(volatile Uint8 * ptr)
 {
 #ifdef nativeTestThenSet8
    return (SDL_bool)nativeTestThenSet8(ptr);
@@ -222,7 +222,7 @@
 }
 
 void
-SDL_AtomicClear8(Uint8 * ptr)
+SDL_AtomicClear8(volatile Uint8 * ptr)
 {
 #ifdef nativeClear8
    nativeClear8(ptr);
@@ -236,7 +236,7 @@
 }
 
 Uint8
-SDL_AtomicFetchThenIncrement8(Uint8 * ptr)
+SDL_AtomicFetchThenIncrement8(volatile Uint8 * ptr)
 {
 #ifdef nativeFetchThenIncrement8
    return nativeFetchThenIncrement8(ptr);
@@ -253,7 +253,7 @@
 }
 
 Uint8
-SDL_AtomicFetchThenDecrement8(Uint8 * ptr)
+SDL_AtomicFetchThenDecrement8(volatile Uint8 * ptr)
 {
 #ifdef nativeFetchThenDecrement8
    return nativeFetchThenDecrement8(ptr);
@@ -270,7 +270,7 @@
 }
 
 Uint8
-SDL_AtomicFetchThenAdd8(Uint8 * ptr, Uint8 value)
+SDL_AtomicFetchThenAdd8(volatile Uint8 * ptr, Uint8 value)
 {
 #ifdef nativeFetchThenAdd8
    return nativeFetchThenAdd8(ptr, value);
@@ -287,7 +287,7 @@
 }
 
 Uint8
-SDL_AtomicFetchThenSubtract8(Uint8 * ptr, Uint8 value)
+SDL_AtomicFetchThenSubtract8(volatile Uint8 * ptr, Uint8 value)
 {
 #ifdef nativeFetchThenSubtract8
    return nativeFetchThenSubtract8(ptr, value);
@@ -304,7 +304,7 @@
 }
 
 Uint8
-SDL_AtomicIncrementThenFetch8(Uint8 * ptr)
+SDL_AtomicIncrementThenFetch8(volatile Uint8 * ptr)
 {
 #ifdef nativeIncrementThenFetch8
    return nativeIncrementThenFetch8(ptr);
@@ -321,7 +321,7 @@
 }
 
 Uint8
-SDL_AtomicDecrementThenFetch8(Uint8 * ptr)
+SDL_AtomicDecrementThenFetch8(volatile Uint8 * ptr)
 {
 #ifdef nativeDecrementThenFetch8
    return nativeDecrementThenFetch8(ptr);
@@ -338,7 +338,7 @@
 }
 
 Uint8
-SDL_AtomicAddThenFetch8(Uint8 * ptr, Uint8 value)
+SDL_AtomicAddThenFetch8(volatile Uint8 * ptr, Uint8 value)
 {
 #ifdef nativeAddThenFetch8
    return nativeAddThenFetch8(ptr, value);
@@ -355,7 +355,7 @@
 }
 
 Uint8
-SDL_AtomicSubtractThenFetch8(Uint8 * ptr, Uint8 value)
+SDL_AtomicSubtractThenFetch8(volatile Uint8 * ptr, Uint8 value)
 {
 #ifdef nativeSubtractThenFetch8
    return nativeSubtractThenFetch8(ptr, value);
@@ -374,7 +374,7 @@
 /* 16 bit atomic operations */
 
 Uint16
-SDL_AtomicExchange16(Uint16 * ptr, Uint16 value)
+SDL_AtomicExchange16(volatile Uint16 * ptr, Uint16 value)
 {
 #ifdef nativeExchange16
    return nativeExchange16(ptr, value);
@@ -391,7 +391,7 @@
 }
 
 SDL_bool
-SDL_AtomicCompareThenSet16(Uint16 * ptr, Uint16 oldvalue, Uint16 newvalue)
+SDL_AtomicCompareThenSet16(volatile Uint16 * ptr, Uint16 oldvalue, Uint16 newvalue)
 {
 #ifdef nativeCompareThenSet16
    return (SDL_bool)nativeCompareThenSet16(ptr, oldvalue, newvalue);
@@ -411,7 +411,7 @@
 }
 
 SDL_bool
-SDL_AtomicTestThenSet16(Uint16 * ptr)
+SDL_AtomicTestThenSet16(volatile Uint16 * ptr)
 {
 #ifdef nativeTestThenSet16
    return (SDL_bool)nativeTestThenSet16(ptr);
@@ -431,7 +431,7 @@
 }
 
 void
-SDL_AtomicClear16(Uint16 * ptr)
+SDL_AtomicClear16(volatile Uint16 * ptr)
 {
 #ifdef nativeClear16
    nativeClear16(ptr);
@@ -445,7 +445,7 @@
 }
 
 Uint16
-SDL_AtomicFetchThenIncrement16(Uint16 * ptr)
+SDL_AtomicFetchThenIncrement16(volatile Uint16 * ptr)
 {
 #ifdef nativeFetchThenIncrement16
    return nativeFetchThenIncrement16(ptr);
@@ -462,7 +462,7 @@
 }
 
 Uint16
-SDL_AtomicFetchThenDecrement16(Uint16 * ptr)
+SDL_AtomicFetchThenDecrement16(volatile Uint16 * ptr)
 {
 #ifdef nativeFetchThenDecrement16
    return nativeFetchThenDecrement16(ptr);
@@ -479,7 +479,7 @@
 }
 
 Uint16
-SDL_AtomicFetchThenAdd16(Uint16 * ptr, Uint16 value)
+SDL_AtomicFetchThenAdd16(volatile Uint16 * ptr, Uint16 value)
 {
 #ifdef nativeFetchThenAdd16
    return nativeFetchThenAdd16(ptr, value);
@@ -496,7 +496,7 @@
 }
 
 Uint16
-SDL_AtomicFetchThenSubtract16(Uint16 * ptr, Uint16 value)
+SDL_AtomicFetchThenSubtract16(volatile Uint16 * ptr, Uint16 value)
 {
 #ifdef nativeFetchThenSubtract16
    return nativeFetchThenSubtract16(ptr, value);
@@ -513,7 +513,7 @@
 }
 
 Uint16
-SDL_AtomicIncrementThenFetch16(Uint16 * ptr)
+SDL_AtomicIncrementThenFetch16(volatile Uint16 * ptr)
 {
 #ifdef nativeIncrementThenFetch16
    return nativeIncrementThenFetch16(ptr);
@@ -530,7 +530,7 @@
 }
 
 Uint16
-SDL_AtomicDecrementThenFetch16(Uint16 * ptr)
+SDL_AtomicDecrementThenFetch16(volatile Uint16 * ptr)
 {
 #ifdef nativeDecrementThenFetch16
    return nativeDecrementThenFetch16(ptr);
@@ -547,7 +547,7 @@
 }
 
 Uint16
-SDL_AtomicAddThenFetch16(Uint16 * ptr, Uint16 value)
+SDL_AtomicAddThenFetch16(volatile Uint16 * ptr, Uint16 value)
 {
 #ifdef nativeAddThenFetch16
    return nativeAddThenFetch16(ptr, value);
@@ -564,7 +564,7 @@
 }
 
 Uint16
-SDL_AtomicSubtractThenFetch16(Uint16 * ptr, Uint16 value)
+SDL_AtomicSubtractThenFetch16(volatile Uint16 * ptr, Uint16 value)
 {
 #ifdef nativeSubtractThenFetch16
    return nativeSubtractThenFetch16(ptr, value);
@@ -583,7 +583,7 @@
 /* 32 bit atomic operations */
 
 Uint32
-SDL_AtomicExchange32(Uint32 * ptr, Uint32 value)
+SDL_AtomicExchange32(volatile Uint32 * ptr, Uint32 value)
 {
 #ifdef nativeExchange32
    return nativeExchange32(ptr, value);
@@ -600,7 +600,7 @@
 }
 
 SDL_bool
-SDL_AtomicCompareThenSet32(Uint32 * ptr, Uint32 oldvalue, Uint32 newvalue)
+SDL_AtomicCompareThenSet32(volatile Uint32 * ptr, Uint32 oldvalue, Uint32 newvalue)
 {
 #ifdef nativeCompareThenSet32
    return (SDL_bool)nativeCompareThenSet32(ptr, oldvalue, newvalue);
@@ -620,7 +620,7 @@
 }
 
 SDL_bool
-SDL_AtomicTestThenSet32(Uint32 * ptr)
+SDL_AtomicTestThenSet32(volatile Uint32 * ptr)
 {
 #ifdef nativeTestThenSet32
    return (SDL_bool)nativeTestThenSet32(ptr);
@@ -640,7 +640,7 @@
 }
 
 void
-SDL_AtomicClear32(Uint32 * ptr)
+SDL_AtomicClear32(volatile Uint32 * ptr)
 {
 #ifdef nativeClear32
    nativeClear32(ptr);
@@ -654,7 +654,7 @@
 }
 
 Uint32
-SDL_AtomicFetchThenIncrement32(Uint32 * ptr)
+SDL_AtomicFetchThenIncrement32(volatile Uint32 * ptr)
 {
 #ifdef nativeFetchThenIncrement32
    return nativeFetchThenIncrement32(ptr);
@@ -671,7 +671,7 @@
 }
 
 Uint32
-SDL_AtomicFetchThenDecrement32(Uint32 * ptr)
+SDL_AtomicFetchThenDecrement32(volatile Uint32 * ptr)
 {
 #ifdef nativeFetchThenDecrement32
    return nativeFetchThenDecrement32(ptr);
@@ -688,7 +688,7 @@
 }
 
 Uint32
-SDL_AtomicFetchThenAdd32(Uint32 * ptr, Uint32 value)
+SDL_AtomicFetchThenAdd32(volatile Uint32 * ptr, Uint32 value)
 {
 #ifdef nativeFetchThenAdd32
    return nativeFetchThenAdd32(ptr, value);
@@ -705,7 +705,7 @@
 }
 
 Uint32
-SDL_AtomicFetchThenSubtract32(Uint32 * ptr, Uint32 value)
+SDL_AtomicFetchThenSubtract32(volatile Uint32 * ptr, Uint32 value)
 {
 #ifdef nativeFetchThenSubtract32
    return nativeFetchThenSubtract32(ptr, value);
@@ -722,7 +722,7 @@
 }
 
 Uint32
-SDL_AtomicIncrementThenFetch32(Uint32 * ptr)
+SDL_AtomicIncrementThenFetch32(volatile Uint32 * ptr)
 {
 #ifdef nativeIncrementThenFetch32
    return nativeIncrementThenFetch32(ptr);
@@ -739,7 +739,7 @@
 }
 
 Uint32
-SDL_AtomicDecrementThenFetch32(Uint32 * ptr)
+SDL_AtomicDecrementThenFetch32(volatile Uint32 * ptr)
 {
 #ifdef nativeDecrementThenFetch32
    return nativeDecrementThenFetch32(ptr);
@@ -756,7 +756,7 @@
 }
 
 Uint32
-SDL_AtomicAddThenFetch32(Uint32 * ptr, Uint32 value)
+SDL_AtomicAddThenFetch32(volatile Uint32 * ptr, Uint32 value)
 {
 #ifdef nativeAddThenFetch32
    return nativeAddThenFetch32(ptr, value);
@@ -773,7 +773,7 @@
 }
 
 Uint32
-SDL_AtomicSubtractThenFetch32(Uint32 * ptr, Uint32 value)
+SDL_AtomicSubtractThenFetch32(volatile Uint32 * ptr, Uint32 value)
 {
 #ifdef nativeSubtractThenFetch32
    return nativeSubtractThenFetch32(ptr, value);
@@ -793,7 +793,7 @@
 #ifdef SDL_HAS_64BIT_TYPE
 
 Uint64
-SDL_AtomicExchange64(Uint64 * ptr, Uint64 value)
+SDL_AtomicExchange64(volatile Uint64 * ptr, Uint64 value)
 {
 #ifdef nativeExchange64
    return nativeExchange64(ptr, value);
@@ -810,7 +810,7 @@
 }
 
 SDL_bool
-SDL_AtomicCompareThenSet64(Uint64 * ptr, Uint64 oldvalue, Uint64 newvalue)
+SDL_AtomicCompareThenSet64(volatile Uint64 * ptr, Uint64 oldvalue, Uint64 newvalue)
 {
 #ifdef nativeCompareThenSet64
    return (SDL_bool)nativeCompareThenSet64(ptr, oldvalue, newvalue);
@@ -830,7 +830,7 @@
 }
 
 SDL_bool
-SDL_AtomicTestThenSet64(Uint64 * ptr)
+SDL_AtomicTestThenSet64(volatile Uint64 * ptr)
 {
 #ifdef nativeTestThenSet64
    return (SDL_bool)nativeTestThenSet64(ptr);
@@ -850,7 +850,7 @@
 }
 
 void
-SDL_AtomicClear64(Uint64 * ptr)
+SDL_AtomicClear64(volatile Uint64 * ptr)
 {
 #ifdef nativeClear64
    nativeClear64(ptr);
@@ -864,7 +864,7 @@
 }
 
 Uint64
-SDL_AtomicFetchThenIncrement64(Uint64 * ptr)
+SDL_AtomicFetchThenIncrement64(volatile Uint64 * ptr)
 {
 #ifdef nativeFetchThenIncrement64
    return nativeFetchThenIncrement64(ptr);
@@ -881,7 +881,7 @@
 }
 
 Uint64
-SDL_AtomicFetchThenDecrement64(Uint64 * ptr)
+SDL_AtomicFetchThenDecrement64(volatile Uint64 * ptr)
 {
 #ifdef nativeFetchThenDecrement64
    return nativeFetchThenDecrement64(ptr);
@@ -898,7 +898,7 @@
 }
 
 Uint64
-SDL_AtomicFetchThenAdd64(Uint64 * ptr, Uint64 value)
+SDL_AtomicFetchThenAdd64(volatile Uint64 * ptr, Uint64 value)
 {
 #ifdef nativeFetchThenAdd64
    return nativeFetchThenAdd64(ptr, value);
@@ -915,7 +915,7 @@
 }
 
 Uint64
-SDL_AtomicFetchThenSubtract64(Uint64 * ptr, Uint64 value)
+SDL_AtomicFetchThenSubtract64(volatile Uint64 * ptr, Uint64 value)
 {
 #ifdef nativeFetchThenSubtract64
    return nativeFetchThenSubtract64(ptr, value);
@@ -932,7 +932,7 @@
 }
 
 Uint64
-SDL_AtomicIncrementThenFetch64(Uint64 * ptr)
+SDL_AtomicIncrementThenFetch64(volatile Uint64 * ptr)
 {
 #ifdef nativeIncrementThenFetch64
    return nativeIncrementThenFetch64(ptr);
@@ -949,7 +949,7 @@
 }
 
 Uint64
-SDL_AtomicDecrementThenFetch64(Uint64 * ptr)
+SDL_AtomicDecrementThenFetch64(volatile Uint64 * ptr)
 {
 #ifdef nativeDecrementThenFetch64
    return nativeDecrementThenFetch64(ptr);
@@ -966,7 +966,7 @@
 }
 
 Uint64
-SDL_AtomicAddThenFetch64(Uint64 * ptr, Uint64 value)
+SDL_AtomicAddThenFetch64(volatile Uint64 * ptr, Uint64 value)
 {
 #ifdef nativeAddThenFetch64
    return nativeAddThenFetch64(ptr, value);
@@ -983,7 +983,7 @@
 }
 
 Uint64
-SDL_AtomicSubtractThenFetch64(Uint64 * ptr, Uint64 value)
+SDL_AtomicSubtractThenFetch64(volatile Uint64 * ptr, Uint64 value)
 {
 #ifdef nativeSubtractThenFetch64
    return nativeSubtractThenFetch64(ptr, value);
