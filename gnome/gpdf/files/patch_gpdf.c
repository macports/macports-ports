--- shell/gpdf.c.org	Sun Feb  8 22:34:02 2004
+++ shell/gpdf.c	Sun Feb  8 22:34:33 2004
@@ -128,7 +128,7 @@
 	if (pixbuf == NULL)
 		return;
 
-	gtk_window_set_default_icon (pixbuf);
+	/* gtk_window_set_default_icon (pixbuf); */
 
 	g_object_unref (pixbuf);
 }
