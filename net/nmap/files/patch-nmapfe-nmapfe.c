--- nmapfe/nmapfe.c.b	Sun Aug 29 02:12:04 2004
+++ nmapfe/nmapfe.c	Mon Jan  3 11:16:56 2005
@@ -1306,7 +1306,7 @@
 GtkWidget *hbox;
 GtkWidget *button;
 
-  helpDialog = gtk_window_new(GTK_WINDOW_DIALOG);
+  helpDialog = gtk_window_new(GTK_WINDOW_POPUP);
   gtk_widget_set_usize(helpDialog, 400, 300);
   gtk_window_set_title(GTK_WINDOW(helpDialog), "Help With NmapFE");
   gtk_window_set_policy(GTK_WINDOW(helpDialog), FALSE, FALSE, FALSE);
