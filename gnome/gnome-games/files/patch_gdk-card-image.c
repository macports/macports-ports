--- freecell/gdk-card-image/gdk-card-image.c.org	Sat Jul 26 17:36:35 2003
+++ freecell/gdk-card-image/gdk-card-image.c	Sat Jul 26 17:37:29 2003
@@ -41,6 +41,9 @@
 #include <dirent.h>
 #endif
 
+#include <sys/types.h>
+#include <dirent.h>
+
 #ifdef __osf__
 #undef HAVE_STRUCT_DIRECT
 #endif
