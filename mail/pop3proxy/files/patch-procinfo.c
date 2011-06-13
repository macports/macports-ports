--- procinfo.c.orig	2006-01-07 08:03:10.000000000 -0600
+++ procinfo.c	2011-06-13 03:23:49.000000000 -0500
@@ -29,7 +29,7 @@
 
 #include <ctype.h>
 #include <signal.h>
-#include <wait.h>
+#include <sys/wait.h>
 #include <errno.h>
 #include <time.h>
 
