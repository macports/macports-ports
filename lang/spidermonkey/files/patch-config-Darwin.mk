$NetBSD: patch-ac,v 1.2 2006/12/05 18:04:18 tron Exp $

--- config/Darwin.mk.orig	2005-02-12 20:10:33.000000000 +0000
+++ config/Darwin.mk	2006-12-05 16:41:04.000000000 +0000
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
-MKSHLIB = libtool $(XMKSHLIBOPTS) -framework System
+MKSHLIB = $(CC) -framework System -dynamiclib $(XMKSHLIBOPTS) -lm -lplds4 -lplc4 -lnspr4 $(LDFLAGS)
 
 #.c.o:
 #      $(CC) -c -MD $*.d $(CFLAGS) $<
@@ -57,7 +57,6 @@
 CPU_ARCH = $(shell uname -m)
 ifeq (86,$(findstring 86,$(CPU_ARCH)))
 CPU_ARCH = x86
-OS_CFLAGS+= -DX86_LINUX
 endif
 GFX_ARCH = x
 
@@ -65,14 +64,6 @@
 
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
 
