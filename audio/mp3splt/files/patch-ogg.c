--- ogg.c.orig	Sat Jul 17 08:28:01 2004
+++ ogg.c	Mon Nov 29 18:16:05 2004
@@ -57,8 +57,6 @@
 #define ftello ftell
 #endif
 
-#include <values.h>
-
 static v_packet *save_packet(ogg_packet *packet)
 {
 	v_packet *p = malloc(sizeof(v_packet));
