--- bin/adv1tov2/adv1tov2.c~	2009-03-29 09:23:20.000000000 +0200
+++ bin/adv1tov2/adv1tov2.c	2009-11-10 18:36:50.000000000 +0100
@@ -8,16 +8,16 @@
 #include "config.h"
 #endif /* HAVE_CONFIG_H */
 
-#include <atalk/adouble.h>
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif /* HAVE_UNISTD_H */
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <dirent.h>
 #ifdef HAVE_FCNTL_H
 #include <fcntl.h>
 #endif /* HAVE_FCNTL_H */
-#ifdef HAVE_UNISTD_H
-#include <unistd.h>
-#endif /* HAVE_UNISTD_H */
 #include <ctype.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -25,6 +25,7 @@
 #include <errno.h>
 #include <string.h>
 
+#include <atalk/adouble.h>
 #include <atalk/util.h>
 
 #if AD_VERSION == AD_VERSION2
