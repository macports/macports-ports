--- mutt-1.4.2.1/keymap.h.orig	2001-09-11 06:20:34.000000000 -0500
+++ mutt-1.4.2.1/keymap.h	2006-04-14 14:01:56.000000000 -0500
@@ -19,6 +19,8 @@
 #ifndef KEYMAP_H
 #define KEYMAP_H
 
+#include "mapping.h"
+
 /* maximal length of a key binding sequence used for buffer in km_bindkey */
 #define MAX_SEQ 8
 

