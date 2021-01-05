$NetBSD: patch-nss_coreconf_Darwin.mk $

use uname -m (arm64), not uname -p (arm), convert arm64 to aarch64

--- nss/coreconf/Darwin.mk.orig	2020-12-11 16:32:40.000000000 +0100
+++ nss/coreconf/Darwin.mk	2020-12-29 19:40:02.000000000 +0100
@@ -15,7 +15,7 @@
 ifndef CPU_ARCH
 # When cross-compiling, CPU_ARCH should already be defined as the target
 # architecture, set to powerpc or i386.
-CPU_ARCH	:= $(shell uname -p)
+CPU_ARCH	:= $(shell uname -m)
 endif
 
 ifeq (,$(filter-out i%86,$(CPU_ARCH)))
@@ -30,8 +30,9 @@
 override CPU_ARCH	= x86
 endif
 else
-ifeq (arm,$(CPU_ARCH))
-# Nothing set for arm currently.
+ifeq (arm64,$(CPU_ARCH))
+override CPU_ARCH	= aarch64
+# Nothing else set for arm64/aarch64 currently.
 else
 OS_REL_CFLAGS	= -Dppc
 CC              += -arch ppc
