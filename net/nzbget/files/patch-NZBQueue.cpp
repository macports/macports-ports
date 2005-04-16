--- NZBQueue.cpp~	Wed Feb 23 09:05:23 2005
+++ NZBQueue.cpp	Fri Apr 15 23:10:08 2005
@@ -26,6 +26,7 @@
 #ifdef HAVE_CONFIG_H
 #include <config.h>
 #endif
+#include <libgen.h>
 
 #include "NZBQueue.h"
 #include "global.h"
