--- ../rep-gtk-0.18.orig/rep-gtk.h	2006-08-07 09:16:07.000000000 -0600
+++ rep-gtk.h	2006-08-07 09:16:23.000000000 -0600
@@ -290,12 +290,15 @@
 			    repv position);
 
 GtkWidget*
-gtk_radio_menu_item_new_with_label_from_widget (GtkRadioMenuItem *group,
-						gchar            *label);
+wrapper_gtk_radio_menu_item_new_with_label_from_widget (
+    GtkRadioMenuItem *group,
+    const gchar *label);
 GtkWidget*
-gtk_radio_menu_item_new_with_mnemonic_from_widget (GtkRadioMenuItem *group,
-						   gchar            *label);
-GtkWidget* gtk_radio_menu_item_new_from_widget (GtkRadioMenuItem *group);
+wrapper_gtk_radio_menu_item_new_with_mnemonic_from_widget (
+    GtkRadioMenuItem *group,
+    const gchar *label);
+GtkWidget*
+wrapper_gtk_radio_menu_item_new_from_widget (GtkRadioMenuItem *group);
 GtkWidget* gtk_pixmap_new_interp (char *file, GtkWidget *intended_parent);
 
 #ifndef HAVE_GDK_COLOR_COPY
