--- src/socketlib.c.orig	2006-07-11 19:24:23.000000000 +0200
+++ src/socketlib.c	2006-07-11 19:24:48.000000000 +0200
@@ -20,7 +20,7 @@
  * It is meant to provide some library functions. The only required external depency
  * the printip function that is provided in utils.c */
 
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
 #ifndef WIN32
