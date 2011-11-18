--- ./thunar-vfs/thunar-vfs-exec.c.orig	2010-05-21 19:10:52.000000000 +0200
+++ ./thunar-vfs/thunar-vfs-exec.c	2011-11-07 08:54:09.000000000 +0100
@@ -370,6 +370,7 @@ tvsn_get_active_workspace_number (GdkScr
 
   root = gdk_screen_get_root_window (screen);
 
+#if defined(GDK_WINDOWING_X11)
   /* determine the X atom values */
   _NET_CURRENT_DESKTOP = XInternAtom (GDK_WINDOW_XDISPLAY (root), "_NET_CURRENT_DESKTOP", False);
   _WIN_WORKSPACE = XInternAtom (GDK_WINDOW_XDISPLAY (root), "_WIN_WORKSPACE", False);
@@ -398,6 +399,9 @@ tvsn_get_active_workspace_number (GdkScr
         ws_num = *prop_ret;
       XFree (prop_ret);
     }
+#else
+  /* dunno what to do on non-X11 window systems */
+#endif
 
   gdk_error_trap_pop ();
 
