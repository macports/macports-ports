--- config.mk.orig	2008-08-09 04:47:33.000000000 -0700
+++ config.mk	2008-11-29 09:53:59.000000000 -0800
@@ -1,7 +1,7 @@
 # Customize to fit your system
 
 # paths
-PREFIX      = /usr/local
+PREFIX      = __PREFIX__
 BINDIR      = ${PREFIX}/bin
 MANDIR      = ${PREFIX}/share/man
 MAN1DIR     = ${MANDIR}/man1
@@ -15,13 +15,13 @@
 VERSION     = 1.7
 
 # includes and libs
-INCLUDES    = -I. -I${INCDIR} -I/usr/include
-LIBS        = -L${LIBDIR} -L/usr/lib -lc
+INCLUDES    = 
+LIBS        = 
 # uncomment and comment other variables for compiling on Solaris
 #LIBS = -L${LIBDIR} -L/usr/lib -lc -lsocket -lnsl
 #CFLAGS      = -g ${INCLUDES} -DVERSION=\"${VERSION}\"
 
 # compiler
-CC          = cc
-CFLAGS      = -g -O0 -W -Wall ${INCLUDES} -DVERSION=\"${VERSION}\"
-LDFLAGS     = ${LIBS}
+CC          = __CC__
+CFLAGS      = -g __CFLAGS__ -W -Wall ${INCLUDES} -DVERSION=\"${VERSION}\"
+LDFLAGS     = __LDFLAGS__ ${LIBS}
