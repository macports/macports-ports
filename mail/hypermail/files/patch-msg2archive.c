--- archive/msg2archive.c.orig	Thu Feb 20 10:04:00 2003
+++ archive/msg2archive.c	Sun Apr 27 22:03:34 2003
@@ -21,7 +21,7 @@
 #include <ctype.h>
 #include <fcntl.h>
 #include <time.h>
-#include <wait.h>
+#include <sys/wait.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include "lists.h"
