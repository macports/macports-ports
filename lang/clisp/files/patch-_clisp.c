--- src/_clisp.c.sav	Fri Feb  7 14:42:33 2003
+++ src/_clisp.c	Fri Feb  7 14:43:03 2003
@@ -31,12 +31,8 @@
 # include <string.h>
 
 /* Declare malloc(). */
-#ifdef HAVE_STDLIB_H
 # include <stdlib.h>
-#endif
-#ifdef HAVE_UNISTD_H
 # include <unistd.h>
-#endif
 
 /* Declare errno. */
 # include <errno.h>
