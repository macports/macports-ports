--- src/ui.c.org	Mon Jan 19 19:16:28 2004
+++ src/ui.c	Mon Jan 19 19:17:12 2004
@@ -21,6 +21,7 @@
    Author: Jaka Mocnik <jaka@gnu.org>
 */
 
+#include <stdarg.h>
 #include <config.h>
 #include <gnome.h>
 
@@ -875,7 +876,7 @@
 	g_return_if_fail (msg != NULL);
 	va_start(args, msg);
 	real_msg = g_strdup_vprintf(msg, args);
-	va_end(msg);
+	va_end(real_msg);
 	info_dlg = gtk_message_dialog_new (
 			GTK_WINDOW (win),
 			GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
