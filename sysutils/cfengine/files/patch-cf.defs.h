--- ../cfengine-2.1.6.orig/src/cf.defs.h	Thu Apr 22 04:14:15 2004
+++ src/cf.defs.h	Sun Jun 13 13:48:26 2004
@@ -153,11 +153,13 @@
 #include <sys/paths.h>
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
