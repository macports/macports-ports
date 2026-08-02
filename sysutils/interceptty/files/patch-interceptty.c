--- interceptty.c	Mon Sep  6 01:01:35 2004
+++ interceptty.c.new	Mon Sep  6 14:34:47 2004
@@ -31,6 +31,7 @@
 #include <netdb.h>
 #include <pwd.h>
 #include <grp.h>
+#include <sys/aio.h>
 
 #include "bsd-openpty.h"
 #include "common.h"
