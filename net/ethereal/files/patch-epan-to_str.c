--- epan/to_str.c	Sat Dec  7 18:32:36 2002
+++ epan/to_str.c	Sun Dec 29 19:38:08 2002
@@ -63,6 +63,7 @@
 #include <stdio.h>
 #include <time.h>
 
+static const gchar hex_digits[16] = "0123456789abcdef";
 
 /* Wrapper for the most common case of asking
  * for a string using a colon as the hex-digit separator.
@@ -85,7 +86,6 @@
   gchar        *p;
   int          i;
   guint32      octet;
-  static const gchar hex_digits[16] = "0123456789abcdef";
 
   if (cur == &str[0][0]) {
     cur = &str[1][0];
@@ -214,7 +214,6 @@
   gchar        *p;
   int          i;
   guint32      octet;
-  static const gchar hex_digits[16] = "0123456789ABCDEF";
   static const guint32  octet_mask[4] =
 	  { 0xff000000 , 0x00ff0000, 0x0000ff00, 0x000000ff };
 
@@ -571,7 +570,6 @@
   gchar        *p;
   int          i;
   guint32      octet;
-  static const gchar hex_digits[16] = "0123456789abcdef";
 
   if (cur == &str[0][0]) {
     cur = &str[1][0];
