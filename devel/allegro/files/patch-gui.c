--- src/gui.c.orig	2007-01-06 21:02:25.000000000 -0800
+++ src/gui.c	2007-01-06 21:08:11.000000000 -0800
@@ -46,6 +46,7 @@
 DIALOG *active_dialog = NULL;
 MENU *active_menu = NULL;
 
+static int shutdown_single_menu(MENU_PLAYER *, int *);
 
 /* list of currently active (initialized) dialog players */
 struct al_active_dialog_player {
@@ -1784,8 +1785,6 @@
  */
 int update_menu(MENU_PLAYER *player)
 {
-   static int shutdown_single_menu(MENU_PLAYER *, int *);
-
    MENU_PLAYER *i;
    int c, c2;
    int old_sel, child_ret;
