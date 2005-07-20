--- 4.3/regex.c.orig	2005-05-18 12:20:12.000000000 +0900
+++ 4.3/regex.c	2005-05-18 12:20:27.000000000 +0900
@@ -47,7 +47,7 @@
 
 #include <sys/types.h>
 #include <stddef.h>
-#include <regexp.h>
+#include "regexp.h"
 #include <string.h>
 #include <stdlib.h>
 #include <string.h>
