--- source/status.c.orig	Sun Aug  3 21:01:54 2003
+++ source/status.c	Sun Aug  3 21:02:52 2003
@@ -1213,7 +1213,7 @@
  * current-type window, although i think they should go to all windows.
  */
 #define STATUS_VAR(x) \
-static	char	*status_user ## x ## (Window *window)			\
+static	char	*status_user ## x (Window *window)			\
 {									\
 	char	*text;							\
 									\
