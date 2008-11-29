--- config.mk.orig	2008-11-29 10:00:14.000000000 -0800
+++ config.mk	2008-11-29 10:00:45.000000000 -0800
@@ -4,7 +4,7 @@
 # Customize below to fit your system
 
 # paths
-PREFIX = /usr/local
+PREFIX = __PREFIX__
 MANPREFIX = ${PREFIX}/share/man
 
 # includes and libs
@@ -13,8 +13,8 @@
 
 # flags
 CPPFLAGS = -DVERSION=\"${VERSION}\" -D_GNU_SOURCE
-CFLAGS = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
-LDFLAGS = -s ${LIBS}
+CFLAGS = __CFLAGS__ -std=c99 -pedantic -Wall ${CPPFLAGS}
+LDFLAGS = __LDFLAGS__
 
 # compiler and linker
-CC = cc
+CC = __CC__
