--- src/assuan-domain-connect.c.orig	Mon Apr 19 16:41:29 2004
+++ src/assuan-domain-connect.c	Wed Aug  4 17:00:32 2004
@@ -33,6 +33,7 @@
 #include <fcntl.h>
 #include <string.h>
 #include <assert.h>
+#include <sys/uio.h>
 
 #include "assuan-defs.h"
 
