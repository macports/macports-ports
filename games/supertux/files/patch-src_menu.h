--- src/menu.h.orig	2005-06-21 16:16:07.000000000 -0500
+++ src/menu.h	2011-08-29 03:28:39.000000000 -0500
@@ -207,7 +207,7 @@
 
   bool isToggled(int id);
 
-  void Menu::get_controlfield_key_into_input(MenuItem *item);
+  void get_controlfield_key_into_input(MenuItem *item);
 
   void draw   ();
   void draw_item(int index, int menu_width, int menu_height);
