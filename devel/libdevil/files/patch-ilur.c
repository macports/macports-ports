--- src-ILU/ilur/ilur.c.orig	2009-03-08 18:10:12.000000000 +1100
+++ src-ILU/ilur/ilur.c	2009-11-14 04:59:19.000000000 +1100
@@ -1,6 +1,6 @@
 #include <string.h>
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
 
 #include <IL/il.h>
 #include <IL/ilu.h>
