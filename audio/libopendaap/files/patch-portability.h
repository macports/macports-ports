--- portability.h.orig	Sat Jan  8 06:13:46 2005
+++ portability.h	Sat Jan  8 06:14:00 2005
@@ -34,7 +34,6 @@
 #define SYSTEM_POSIX
 
 #include <sys/types.h>
-#include "config.h"
 
 #else /* WIN32 */
 
