===================================================================
RCS file: /usr/local/src/cvsroot/nefu/TDK/tester.c,v
retrieving revision 1.9
retrieving revision 1.10
diff -u -r1.9 -r1.10
--- TDK/tester.c	2002/11/26 16:26:35	1.9
+++ TDK/tester.c	2003/11/04 19:40:56	1.10
@@ -1,6 +1,7 @@
 /**********	tester.c	***********/
 
 #include <sys/types.h>
+#include <sys/time.h>
 #include <netinet/in.h>
 
 #include <string.h>
