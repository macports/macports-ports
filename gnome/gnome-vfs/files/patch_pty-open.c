--- modules/pty-open.c.org	Fri Jun  4 20:51:58 2004
+++ modules/pty-open.c	Fri Jun  4 20:53:17 2004
@@ -44,6 +44,12 @@
 #include <glib.h>
 #include "pty-open.h"
 
+#undef HAVE_POSIX_OPENPT
+#undef HAVE_GETPT 
+#undef HAVE_GRANTPT 
+#undef HAVE_PTSNAME_R 
+#undef HAVE_UNLOCKPT 
+#undef HAVE_PTSNAME
 int _gnome_vfs_pty_set_size(int master, int columns, int rows);
 
 /* Reset the handlers for all known signals to their defaults.  The parent
