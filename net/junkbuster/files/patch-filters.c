diff -urN ../ijb-zlib-11.orig/filters.c ./filters.c
--- ../ijb-zlib-11.orig/filters.c	Mon Jun  3 17:05:43 2002
+++ ./filters.c	Thu Jan  6 15:05:17 2005
@@ -19,7 +19,7 @@
 #endif
 
 #ifdef REGEX
-#include <gnu_regex.h>
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
