--- w_keyboard.c.orig	2007-04-15 08:12:17.000000000 +0900
+++ w_keyboard.c	2007-04-15 08:12:21.000000000 +0900
@@ -37,6 +37,10 @@
 #define REG_NOERROR REG_OKAY
 #endif
 
+#ifndef REG_NOERROR
+#define REG_NOERROR 0
+#endif
+
 Boolean keyboard_input_available = False;
 int keyboard_x;
 int keyboard_y;
