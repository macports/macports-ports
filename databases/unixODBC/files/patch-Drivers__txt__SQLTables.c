--- Drivers/txt/SQLTables.c.orig	2005-09-20 14:38:17.000000000 -0700
+++ Drivers/txt/SQLTables.c	2005-09-20 14:38:42.000000000 -0700
@@ -10,10 +10,6 @@
  *
  **********************************************************************/
 
-#ifdef OSXHEADER
-#include <i386/types.h>
-#endif
-
 #if defined(__bsdi__)
 # include <sys/types.h>
 #endif
