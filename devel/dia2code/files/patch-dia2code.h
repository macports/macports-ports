--- dia2code/dia2code.h.org	2005-05-09 19:45:48.000000000 +0200
+++ dia2code/dia2code.h	2005-05-09 19:46:12.000000000 +0200
@@ -20,13 +20,12 @@
 
 #include <string.h>
 #include <ctype.h>
-#include <malloc.h>
 #include <stdio.h>
 #include <stdlib.h>
 
 /* libxml[2] headers */
-#include <parser.h>
-#include <tree.h>
+#include <libxml/parser.h>
+#include <libxml/tree.h>
 
 #define VERSION "0.8.1"
 
