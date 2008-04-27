--- src/misc.c.orig	2008-03-31 01:29:12.000000000 +0200
+++ src/misc.c	2008-03-31 01:32:29.000000000 +0200
@@ -741,7 +741,7 @@
 
 void jed_ungetkey_wchar (SLwchar_Type wc)
 {
-   SLuchar_Type *b, buf[SLUTF8_MAX_MBLEN];
+   SLuchar_Type *b, buf[JED_MAX_MULTIBYTE_SIZE];
 
    if (NULL == (b = jed_wchar_to_multibyte (wc, buf)))
      return;
