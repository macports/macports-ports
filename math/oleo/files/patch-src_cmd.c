--- src/cmd.c.orig	Wed Feb 14 13:54:50 2001
+++ src/cmd.c	Thu Feb 19 17:38:57 2004
@@ -31,7 +31,9 @@
 #include <stdarg.h>
 #include "sysdef.h"
 #include <termios.h>
+#ifdef HAVE_MALLOC_H
 #include <malloc.h>
+#endif
 
 #ifdef	HAVE_MOTIF
 #include "io-motif.h"
