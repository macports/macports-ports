--- lib/Canna.c.orig	2002-10-03 18:35:27.000000000 +0900
+++ lib/Canna.c	2007-10-17 07:58:25.000000000 +0900
@@ -61,6 +61,8 @@
 #include "CannaP.h"
 #include "DebugPrint.h"
 
+#define CANNA_WCHAR16
+#define CANNA_NEW_WCHAR_AWARE
 #define _WCHAR_T /* この定義は jrkanji.h で wcKanjiStatus などを定義するため */
 #define wchar_t wchar
 
@@ -246,9 +248,9 @@
     kanabuf[0] = '\0';
     nbytes = XKanaLookup(event, kanabuf, 20, &ks, &compose_status);
 
-    buf[0] = (wchar)kanabuf[0]; /* きたない */
+    buf[0] = (wchar)(unsigned char)kanabuf[0]; /* きたない */
 
-    if (ks == XK_space && (event->xkey.state & ShiftMask)) {
+    if (ks == XK_space && ((event->xkey.state & ShiftMask) || (event->xkey.state & Mod2Mask))) {
       void convend();
 
       convend(obj);
@@ -271,7 +273,7 @@
 
     /* かな漢字変換する */
     len = wcKanjiString((int)obj, (int)buf[0],
-			(wchar_t *)buf, 1024, &kanji_status);
+			(wchar *)buf, 1024, &kanji_status);
 
     displayPreEdit(obj, len, buf, &kanji_status);
     return (kanji_status.info & KanjiThroughInfo) ? 1 : 0;
@@ -642,7 +644,9 @@
 CannaObject obj;
 {
   char **warn = 0;
+#ifndef CANNA_JR_BEEP_FUNC_DECLARED
   extern (*jrBeepFunc)();
+#endif
 
   if (nCannaContexts == 0) {
 #ifdef KC_SETSERVERNAME
