--- gdk/x11/gdkim-x11.c.orig	Fri Nov  1 09:45:32 2002
+++ gdk/x11/gdkim-x11.c	Mon Apr  7 02:00:38 2003
@@ -24,7 +24,11 @@
  * GTK+ at ftp://ftp.gtk.org/pub/gtk/. 
  */
 
-#include <locale.h>
+#if defined(X_LOCALE)
+# include <X11/Xlocale.h>
+#else
+# include <locale.h>
+#endif
 #include <stdlib.h>
 
 #include "gdkx.h"
