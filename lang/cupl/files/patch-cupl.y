--- cupl.y.orig	2005-04-15 01:49:23.000000000 -0400
+++ cupl.y	2005-04-15 01:49:56.000000000 -0400
@@ -23,6 +23,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <setjmp.h>
+#include <stdlib.h>
 
 #ifdef PARSEDEBUG
 static int statement_count;
