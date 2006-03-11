--- mixgtk/mixgtk_device.c.orig	2005-09-26 10:23:30.000000000 +0200
+++ mixgtk/mixgtk_device.c	2005-09-26 10:23:59.000000000 +0200
@@ -88,7 +88,7 @@
 static void
 write_char_ (struct mixgtk_device_t *dev, const mix_word_t *block)
 {
-  enum {MAX_BLOCK = 16, BUFF_SIZE = MAX_BLOCK * 5 + 2};
+  enum {MAX_BLOCK = 24, BUFF_SIZE = MAX_BLOCK * 5 + 2};
   static gchar BUFFER[BUFF_SIZE];
 
   guint k, j;
