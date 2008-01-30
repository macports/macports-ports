--- w_library.c.orig	2007-11-06 16:39:32.000000000 +0100
+++ w_library.c	2007-11-06 16:40:16.000000000 +0100
@@ -1029,9 +1029,9 @@
     Widget	     menu, entry;
 #ifndef XAW3D1_5E
     Widget	     submenu;
-    char	     submenu_name[200];
 #endif /* XAW3D1_5E */
     char	     menu_name[200];
+    char	     submenu_name[200];
     int		     i;
 
     menu = XtCreatePopupShell(name, simpleMenuWidgetClass, 
