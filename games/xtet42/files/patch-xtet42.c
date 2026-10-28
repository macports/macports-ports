--- xtet42.c	Mon Feb 15 00:37:09 1999
+++ xtet42.c	Mon Feb 15 00:39:51 1999
@@ -67,23 +67,23 @@
 #endif
 
 #ifndef _Lock 
-#define _Lock "/local/games/lib/xtet42/.xtet42.lock"
+#define _Lock "__PREFIX__/var/games/xtet42/.xtet42.lock"
 #endif
 
 #ifndef _Unlock
-#define _Unlock "/local/games/lib/xtet42/.xtet42.unlock"
+#define _Unlock "__PREFIX__/var/games/xtet42/.xtet42.unlock"
 #endif
 
 #ifndef _Log
-#define _Log "/local/games/lib/xtet42/.xtet42.log"
+#define _Log "__PREFIX__/var/games/xtet42/.xtet42.log"
 #endif
 
 #ifndef _Hiscore
-#define _Hiscore "/local/games/lib/xtet42/.xtet42.hiscore"
+#define _Hiscore "__PREFIX__/var/games/xtet42/.xtet42.hiscore"
 #endif
 
 #ifndef _Hione
-#define _Hione "/local/games/lib/xtet42/.xtet42.hiscore.single"
+#define _Hione "__PREFIX__/var/games/xtet42/.xtet42.hiscore.single"
 #endif
 
 static int bricks[7][4][4][4]=
