===================================================================
RCS file: /usr/local/src/cvsroot/nefu/ttable.c,v
retrieving revision 1.22
retrieving revision 1.23
diff -u -r1.22 -r1.23
--- ttable.c	2003/09/22 21:19:54	1.22
+++ ttable.c	2003/11/20 18:34:51	1.23
@@ -12,6 +12,7 @@
 #include <stdio.h>
 
 #include "nefu.h"
+#include "config.h"
 #include "ttable.h"
 
 struct testtable testtable[] = {
