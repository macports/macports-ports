--- applets/gen_util/clock.c.org	Fri Jul 25 18:09:46 2003
+++ applets/gen_util/clock.c	Fri Jul 25 18:22:20 2003
@@ -14,7 +14,8 @@
 #include <dirent.h>
 #include <string.h>
 #include <time.h>
-#include <langinfo.h>
+/* not in darwin 6.6 #include <langinfo.h> */
+#define AM_STR          5       /* Ante Meridian affix */
 
 #include <panel-applet.h>
 #include <panel-applet-gconf.h>
