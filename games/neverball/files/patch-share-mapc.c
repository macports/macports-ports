--- share/mapc.c.orig	2004-08-29 08:26:29.000000000 +1000
+++ share/mapc.c	2011-08-10 08:16:35.000000000 +1000
@@ -26,6 +26,7 @@
 /*---------------------------------------------------------------------------*/
 
 #include <SDL.h>
+#undef main
 #include <SDL_image.h>
 #include <stdio.h>
 #include <stdlib.h>
