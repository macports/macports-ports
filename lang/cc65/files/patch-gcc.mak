--- cc65/make/gcc.mak.orig	Mon Dec  8 02:34:23 2003
+++ cc65/make/gcc.mak	Mon Dec  8 02:34:49 2003
@@ -13,7 +13,7 @@
 COMMON	= ../common
 
 # Default for the compiler lib search path as compiler define
-CDEFS=-DCC65_INC=\"/usr/lib/cc65/include/\"
+CDEFS=-DCC65_INC=\"${PREFIX}/lib/cc65/include/\"
 CFLAGS = -O2 -g -Wall -W -I$(COMMON) $(CDEFS)
 CC=gcc
 EBIND=emxbind
--- ld65/make/gcc.mak.orig	Mon Dec  8 02:39:36 2003
+++ ld65/make/gcc.mak	Mon Dec  8 02:39:56 2003
@@ -6,7 +6,7 @@
 COMMON	= ../common
 
 # Default for the compiler lib search path as compiler define
-CDEFS=-DCC65_LIB=\"/usr/lib/cc65/lib/\"
+CDEFS=-DCC65_LIB=\"${PREFIX}/lib/cc65/lib/\"
 CFLAGS = -g -O2 -Wall -W -I$(COMMON) $(CDEFS)
 CC=gcc
 EBIND=emxbind
