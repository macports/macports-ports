--- src/icu_db.c.org	Sun Feb  1 09:00:19 2004
+++ src/icu_db.c	Sun Feb  1 09:00:35 2004
@@ -27,7 +27,7 @@
 
 #include <fcntl.h>
 #include <errno.h>
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/param.h>
