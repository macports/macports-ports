diff -urN ../ijb-zlib-11.orig/encode.c ./encode.c
--- ../ijb-zlib-11.orig/encode.c	Thu Aug  3 23:38:38 2000
+++ ./encode.c	Thu Jan  6 15:05:14 2005
@@ -13,7 +13,7 @@
 #include <ctype.h>
 
 #ifdef REGEX
-#include "gnu_regex.h"
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
