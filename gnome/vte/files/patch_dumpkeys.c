--- src/dumpkeys.c.org	Tue May 11 10:29:17 2004
+++ src/dumpkeys.c	Tue May 11 10:29:11 2004
@@ -18,9 +18,6 @@
 
 #ident "$Id: patch_dumpkeys.c,v 1.2 2004/06/15 09:03:06 olegb Exp $"
 #include "../config.h"
-#ifdef HAVE_SYS_SELECT_H
-#include <sys/select.h>
-#endif
 #ifdef HAVE_SYS_TERMIOS_H
 #include <sys/termios.h>
 #endif
