--- thunar/thunar-metafile.c.orig	2007-12-02 14:46:32.000000000 +0100
+++ thunar/thunar-metafile.c	2008-06-19 09:15:36.000000000 +0200
@@ -37,6 +37,10 @@
 #include <string.h>
 #endif
 
+#ifdef HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+
 #include <tdb/tdb.h>
 
 #include <thunar/thunar-metafile.h>
