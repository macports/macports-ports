--- modules/pty-open.c.org	Mon Apr  5 12:09:11 2004
+++ modules/pty-open.c	Mon Apr  5 12:11:40 2004
@@ -44,6 +44,11 @@
 #include <glib.h>
 #include "pty-open.h"
 
+#undef HAVE_GETPT 
+#undef HAVE_GRANTPT 
+#undef HAVE_PTSNAME_R 
+#undef HAVE_UNLOCKPT 
+#undef HAVE_PTSNAME
 int _gnome_vfs_pty_set_size(int master, int columns, int rows);
 
 /* Reset the handlers for all known signals to their defaults.  The parent
