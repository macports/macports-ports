--- config/Darwin.mk.orig	2008-03-27 00:54:53.000000000 +0900
+++ config/Darwin.mk	2008-03-27 00:57:23.000000000 +0900
@@ -43,13 +43,13 @@
 # Just ripped from Linux config
 #
 
-CC = cc
+CC = gcc
 CCC = g++
-CFLAGS +=  -Wall -Wno-format
-OS_CFLAGS = -DXP_UNIX -DSVR4 -DSYSV -D_BSD_SOURCE -DPOSIX_SOURCE -DDARWIN
+CFLAGS +=  -Wall -Wno-format -no-cpp-precomp -fno-common -pipe
+OS_CFLAGS = -DJS_THREADSAFE -DXP_UNIX -DSVR4 -DSYSV -D_BSD_SOURCE -DPOSIX_SOURCE -DDARWIN
 
 RANLIB = ranlib
-MKSHLIB = $(CC) -dynamiclib $(XMKSHLIBOPTS) -framework System
+MKSHLIB = $(CC) -framework System -dynamiclib $(XMKSHLIBOPTS) -lm -lplds4 -lplc4 -lnspr4 $(LDFLAGS)
 
 SO_SUFFIX = dylib
 
@@ -59,7 +59,6 @@
 CPU_ARCH = $(shell uname -m)
 ifeq (86,$(findstring 86,$(CPU_ARCH)))
 CPU_ARCH = x86
-OS_CFLAGS+= -DX86_LINUX
 endif
 GFX_ARCH = x
 
@@ -67,14 +66,6 @@
 
 ASFLAGS += -x assembler-with-cpp
 
-ifeq ($(CPU_ARCH),alpha)
-
-# Ask the C compiler on alpha linux to let us work with denormalized
-# double values, which are required by the ECMA spec.
-
-OS_CFLAGS += -mieee
-endif
-
 # Use the editline library to provide line-editing support.
 JS_EDITLINE = 1
 
