diff -urN ../ijb-zlib-11.orig/ssplit.c ./ssplit.c
--- ../ijb-zlib-11.orig/ssplit.c	Thu Aug  3 23:39:24 2000
+++ ./ssplit.c	Thu Jan  6 15:38:45 2005
@@ -22,9 +22,10 @@
  *      l = flag indicating whether to ignore leading field separators
  */
 
+#include "loaders.h"
 #include <stdlib.h>	/*  For free()		*/
 #include <stdio.h>	/*  Required by jcc.h	*/
-#include "gnu_regex.h"
+#include <gnuregex.h>
 #include "jcc.h"	/*  For zalloc()	*/
 #undef DEBUG 		/*  DEBUG macro use in this file is not	*/
 			/*  	consistent with use in jcc.h	*/
