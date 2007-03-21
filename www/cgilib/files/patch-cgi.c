--- cgi.c.orig	Sat Aug 21 01:14:07 1999
+++ cgi.c	Sun May  8 22:42:30 2005
@@ -31,7 +31,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <ctype.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <cgi.h>
 
 int cgiDebugLevel = 0;
