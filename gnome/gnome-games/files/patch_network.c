--- iagno/network.c.org	Sat Jul 26 16:25:10 2003
+++ iagno/network.c	Sat Jul 26 16:26:03 2003
@@ -24,6 +24,8 @@
 #include "gnothello.h"
 #include "network.h"
 
+#define socklen_t	long
+
 /* (('g'<<8)+'n' */
 #define GAME_PORT "26478"
 
