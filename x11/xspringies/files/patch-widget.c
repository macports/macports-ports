--- widget.c.orig	2008-09-24 16:32:58.000000000 -0700
+++ widget.c	2008-09-24 16:33:21.000000000 -0700
@@ -127,8 +127,6 @@
 void init_widgets(notify)
 void (*notify)();
 {
-    extern Pixmap get_pixmap();
-
     numb = nums = numc = numm = cur_type = cur_num = 0;
     key_active = cur_but = -1;
     scan_flag = FALSE;
