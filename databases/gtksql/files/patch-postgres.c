--- postgres.c.orig	Sat Jun  5 06:05:36 1999
+++ postgres.c	Tue Sep 17 03:58:59 2002
@@ -18,7 +18,7 @@
 
 #include <libpq-fe.h>
 #include <string.h>
-#include <postgres.h>
+#include <internal/c.h>
 
 #include "common.h"
 #include "status.h"
