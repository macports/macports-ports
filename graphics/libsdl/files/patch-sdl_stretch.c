--- src/video/SDL_stretch.c.orig	Fri Aug 15 22:30:49 2003
+++ src/video/SDL_stretch.c	Fri Aug 15 22:31:00 2003
@@ -261,9 +261,7 @@
 			break;
 		    default:
 #ifdef __GNUC__
-			__asm__ __volatile__ ("
-				call _copy_row
-			"
+			__asm__ __volatile__ (" call _copy_row "
 			: "=&D" (u1), "=&S" (u2)
 			: "0" (dstp), "1" (srcp)
 			: "memory" );
