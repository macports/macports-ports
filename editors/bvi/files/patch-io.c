--- io.c.orig	Mon Jan  6 04:31:45 2003
+++ io.c	Mon Jan  6 04:32:23 2003
@@ -158,7 +158,7 @@
 				filemode = ERROR;
 			}
 		} else if (S_ISREG(buf.st_mode)) {
-			if ((unsigned long)buf.st_size > (unsigned long)SIZE_T_MAX) {
+			if (buf.st_size > SIZE_T_MAX) {
 				move(maxy, 0);
 				endwin();
 				printf("File too large\n");
