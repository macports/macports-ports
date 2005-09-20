--- script/errnogen.c.sav	2005-09-18 21:52:25.000000000 -0400
+++ script/errnogen.c	2005-09-18 21:53:27.000000000 -0400
@@ -1,3 +1,5 @@
+#include <stdlib.h>
+#include <stdio.h>
 #include <errno.h>
 main() {
   int i, j=0, max=0, noncontig=0, dup=0;
