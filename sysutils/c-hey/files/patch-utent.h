--- utent.h.orig	2001-12-30 18:26:06.000000000 -0500
+++ utent.h	2005-04-24 15:24:45.000000000 -0400
@@ -15,9 +15,14 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <stdlib.h>
 
 #include "config.h"
 
+#ifdef __APPLE__
+#undef HAVE_UTMPX_H
+#endif
+
 /* Include the right flavour of utmp */
 #ifndef HAVE_UTMPX_H
 
