--- gtk/gtkmain.c.orig	Sun Jan 12 13:19:09 2003
+++ gtk/gtkmain.c	Mon Apr  7 02:00:39 2003
@@ -26,7 +26,11 @@
 
 #include "gdkconfig.h"
 
-#include <locale.h>
+#if defined(X_LOCALE)
+# include <X11/Xlocale.h>
+#else
+# include <locale.h>
+#endif
 
 #ifdef HAVE_BIND_TEXTDOMAIN_CODESET
 #include <libintl.h>
