diff -urN ../ijb-zlib-11.orig/win32.c ./win32.c
--- ../ijb-zlib-11.orig/win32.c	Thu Aug  3 23:39:26 2000
+++ ./win32.c	Thu Jan  6 15:05:43 2005
@@ -11,7 +11,7 @@
 
 #include <stdio.h>
 #ifdef REGEX
-#include "gnu_regex.h"
+#include <gnuregex.h>
 #endif
 #include "jcc.h"
 #include "win32.h"
