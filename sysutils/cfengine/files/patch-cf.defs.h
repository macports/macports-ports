--- src/cf.defs.h.orig	Tue Feb 10 11:30:51 2004
+++ src/cf.defs.h	Tue Feb 10 11:32:31 2004
@@ -148,11 +148,13 @@
 #include <unistd.h>
 #endif
 
-#ifdef HAVE_MALLOC_H
+#ifdef HAVE_SYS_MALLOC_H
 #ifdef DARWIN
 #include <sys/malloc.h>
 #include <sys/paths.h>
+#endif
 #else
+#ifdef HAVE_MALLOC_H
 #ifndef OPENBSD
 #ifdef __FreeBSD__
 #include <stdlib.h>
