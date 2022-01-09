--- config.mk.orig	2022-01-07 14:17:23.000000000 -0800
+++ config.mk	2022-01-07 14:21:22.000000000 -0800
@@ -2,13 +2,15 @@
 VERSION = 1.9
 
 # paths
-PREFIX    = /usr/local
+PREFIX    = __PREFIX__
 MANPREFIX = ${PREFIX}/share/man
 DOCPREFIX = ${PREFIX}/share/doc
 
 # on systems which provide strlcpy(3),
 # remove NEED_STRLCPY from CFLAGS and
 # remove strlcpy.o from LIBS
-CFLAGS   = -DNEED_STRLCPY -Os
-LDFLAGS  = -s
-LIBS     = strlcpy.o
+CFLAGS   = __CFLAGS__
+LDFLAGS  = __LDFLAGS__
+LIBS     = 
+
+CC       = __CC__
