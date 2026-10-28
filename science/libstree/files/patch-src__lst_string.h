--- src/lst_string.h.orig	2008-12-14 21:30:40.000000000 -0800
+++ src/lst_string.h	2008-12-14 21:30:46.000000000 -0800
@@ -25,6 +25,7 @@
 #ifndef __lst_string_h
 #define __lst_string_h
 
+#include <sys/types.h>
 #include <string.h>
 #include <unistd.h>
 #include <stdlib.h>
