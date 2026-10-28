--- ../rep-gtk-0.18.orig/gtk-compat.c	2006-08-07 09:16:07.000000000 -0600
+++ gtk-compat.c	2006-08-07 09:16:29.000000000 -0600
@@ -63,23 +63,25 @@
 }
 
 GtkWidget*
-gtk_radio_menu_item_new_with_label_from_widget (GtkRadioMenuItem *group,
-						gchar            *label)
+wrapper_gtk_radio_menu_item_new_with_label_from_widget (
+    GtkRadioMenuItem *group,
+    const gchar *label)
 {
   GSList *g = group? gtk_radio_menu_item_group (group) : NULL;
   return gtk_radio_menu_item_new_with_label (g, label);
 }
 
 GtkWidget*
-gtk_radio_menu_item_new_with_mnemonic_from_widget (GtkRadioMenuItem *group,
-						   gchar            *label)
+wrapper_gtk_radio_menu_item_new_with_mnemonic_from_widget (
+    GtkRadioMenuItem *group,
+    const gchar *label)
 {
   GSList *g = group? gtk_radio_menu_item_group (group) : NULL;
   return gtk_radio_menu_item_new_with_mnemonic (g, label);
 }
 
 GtkWidget*
-gtk_radio_menu_item_new_from_widget (GtkRadioMenuItem *group)
+wrapper_gtk_radio_menu_item_new_from_widget (GtkRadioMenuItem *group)
 {
   GSList *g = group? gtk_radio_menu_item_group (group) : NULL;
   return gtk_radio_menu_item_new (g);
