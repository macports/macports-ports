--- Source/x11/XGServerWindow.m.orig	2007-04-25 11:55:59.000000000 -0400
+++ Source/x11/XGServerWindow.m	2007-04-25 12:00:04.000000000 -0400
@@ -2959,7 +2959,7 @@
 	      data[1] = generic.wintypes.win_menu_atom;
 	      len = 2;
 #else
-	      data[0] = generic.wintypes.win_menu_atom;
+	      data[0] = generic.wintypes.win_dock_atom;
 	      len = 1;
 #endif
 	      skipTaskbar = YES;
@@ -2978,7 +2978,7 @@
 	      data[1] = generic.wintypes.win_floating_atom;
 	      len = 2;
 #else
-	      data[0] = generic.wintypes.win_modal_atom;
+	      data[0] = generic.wintypes.win_dock_atom;
 	      len = 1;
 #endif
 	      skipTaskbar = YES;
