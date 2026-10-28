diff -urN ../ijb-zlib-11.orig/acl.c ./acl.c
--- ../ijb-zlib-11.orig/acl.c	Thu Aug  3 23:38:22 2000
+++ ./acl.c	Thu Jan  6 15:04:59 2005
@@ -22,7 +22,7 @@
 #endif
 
 #ifdef REGEX
-#include "gnu_regex.h"
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
