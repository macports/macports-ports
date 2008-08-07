--- erts/emulator/drivers/unix/unix_efile.c.orig	2008-08-06 22:13:42.000000000 -0700
+++ erts/emulator/drivers/unix/unix_efile.c	2008-08-06 22:18:36.000000000 -0700
@@ -44,6 +44,14 @@
 #endif
 #endif /* _OSE_ */
 
+#if defined(__APPLE__) && defined(__MACH__) && !defined(__DARWIN__)
+#define DARWIN 1
+#endif
+
+#ifdef DARWIN
+#include <fcntl.h>
+#endif /* DARWIN */
+
 #ifdef VXWORKS
 #include <ioLib.h>
 #include <dosFsLib.h>
@@ -818,7 +826,11 @@
   undefined fsync
 #endif /* VXWORKS */
 #else
+#if defined(DARWIN) && defined(F_FULLFSYNC)
+    return check_error(fcntl(fd, F_FULLFSYNC), errInfo);
+#else
     return check_error(fsync(fd), errInfo);
+#endif /* DARWIN */
 #endif /* NO_FSYNC */
 }
 
