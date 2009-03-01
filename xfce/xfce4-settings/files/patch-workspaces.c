--- xfce4-settings-helper/workspaces.c.orig	2009-01-25 15:29:31.000000000 +0100
+++ xfce4-settings-helper/workspaces.c	2009-01-27 13:32:51.000000000 +0100
@@ -129,9 +129,14 @@ xfce_workspaces_helper_set_workspace_nam
         wnck_screen_force_update(screen);
 
         /* walk all the workspaces on this screen */
+#if 0
         workspaces = wnck_screen_get_workspaces(screen);
         for(li = workspaces, i = 0; li != NULL; li = li->next, i++) {
             workspace = WNCK_WORKSPACE(li->data);
+#else
+        for(i = 0; i < wnck_screen_get_workspace_count(screen); i++) {
+            workspace = wnck_screen_get_workspace(screen, i);
+#endif
 
             /* check if we have a valid name in the array */
             if(n_names > i && names[i] != NULL && names[i] != '\0') {
