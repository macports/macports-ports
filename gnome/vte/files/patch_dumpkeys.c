--- src/dumpkeys.c.org	Tue Oct 28 20:21:33 2003
+++ src/dumpkeys.c	Tue Oct 28 20:21:42 2003
@@ -18,9 +18,6 @@
 
 #ident "$Id: patch_dumpkeys.c,v 1.1 2004/01/10 19:25:33 olegb Exp $"
 #include "../config.h"
-#ifdef HAVE_SYS_SELECT_H
-#include <sys/select.h>
-#endif
 #include <sys/time.h>
 #include <sys/types.h>
 #include <unistd.h>
