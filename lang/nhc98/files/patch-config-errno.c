--- script/config-errno.c.sav	2005-09-18 21:52:17.000000000 -0400
+++ script/config-errno.c	2005-09-18 21:52:50.000000000 -0400
@@ -1,3 +1,5 @@
+#include <stdlib.h>
+#include <stdio.h>
 #include <errno.h>
 
 #ifdef E2BIG
