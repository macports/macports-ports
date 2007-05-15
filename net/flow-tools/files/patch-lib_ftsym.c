--- lib/ftsym.c.orig	Wed Nov  8 03:51:51 2006
+++ lib/ftsym.c	Wed Nov  8 03:51:56 2006
@@ -35,6 +35,7 @@
 #include <ctype.h>
 #include <stddef.h>
 #include <stdlib.h>
+#include <unistd.h>
 
 #if HAVE_STRINGS_H
  #include <strings.h>
