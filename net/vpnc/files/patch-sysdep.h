--- sysdep.h.orig	2008-11-19 21:36:12.000000000 +0100
+++ sysdep.h	2011-07-05 12:18:11.000000000 +0200
@@ -109,6 +109,12 @@
 #define HAVE_FGETLN    1
 #define HAVE_UNSETENV  1
 #define HAVE_SETENV    1
+
+#include <Availability.h>
+#ifdef __MAC_10_7
+#define HAVE_GETLINE   1
+#endif
+
 #endif
 
 /***************************************************************************/
