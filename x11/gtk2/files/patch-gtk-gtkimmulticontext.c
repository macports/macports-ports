--- gtk/gtkimmulticontext.c.orig	Wed Oct 23 04:17:02 2002
+++ gtk/gtkimmulticontext.c	Mon Apr  7 02:00:39 2003
@@ -20,7 +20,11 @@
 #include "config.h"
 
 #include <string.h>
-#include <locale.h>
+#if defined(X_LOCALE)
+# include <X11/Xlocale.h>
+#else
+# include <locale.h>
+#endif
 
 #include "gtkimmulticontext.h"
 #include "gtkimmodule.h"
@@ -229,7 +233,7 @@
 	{
 	  const char *locale;
 	  
-#ifdef HAVE_LC_MESSAGES
+#if defined(HAVE_LC_MESSAGES) && !defined(X_LOCALE)
 	  locale = setlocale (LC_MESSAGES, NULL);
 #else
 	  locale = setlocale (LC_CTYPE, NULL);
