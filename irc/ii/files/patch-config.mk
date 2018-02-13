--- config.mk.orig	2018-02-13 11:24:10.000000000 -0800
+++ config.mk	2018-02-13 11:26:28.000000000 -0800
@@ -2,18 +2,18 @@
 VERSION = 1.8
 
 # paths
-PREFIX   = /usr/local
+PREFIX   = __PREFIX__
 BINDIR   = ${PREFIX}/bin
 MANDIR   = ${PREFIX}/share/man
 MAN1DIR  = ${MANDIR}/man1
 DOCDIR   = ${PREFIX}/share/doc/ii
 
 # includes and libs
-INCLUDES = -I. -I/usr/include
+INCLUDES =
 LIBS     =
 
 # compiler
-CC       = cc
+CC       = __CC__
 
 # debug
 #CFLAGS  = -g -O0 -pedantic -Wall ${INCLUDES} -DVERSION=\"${VERSION}\" \
@@ -21,5 +21,5 @@
 #LDFLAGS = ${LIBS}
 
 # release
-CFLAGS   = -Os ${INCLUDES} -DVERSION=\"${VERSION}\" -std=c99 -D_DEFAULT_SOURCE
-LDFLAGS  = -s ${LIBS}
+CFLAGS   = __CFLAGS__ ${INCLUDES} -DVERSION=\"${VERSION}\" -std=c99 -D_DEFAULT_SOURCE
+LDFLAGS  = __LDFLAGS__ ${LIBS}
