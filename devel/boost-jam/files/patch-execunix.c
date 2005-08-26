--- execunix.c.orig	2005-08-26 12:50:18.000000000 -0700
+++ execunix.c	2005-08-26 12:50:52.000000000 -0700
@@ -9,6 +9,7 @@
 # include "execcmd.h"
 # include <errno.h>
 # include <time.h>
+# include <unistd.h>
 
 #if defined(sun) || defined(__sun)
 #include <unistd.h> /* need to include unistd.h on sun for the vfork prototype*/
