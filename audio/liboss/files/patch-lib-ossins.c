--- lib/ossins.c.orig	2005-08-15 16:14:02.000000000 +0900
+++ lib/ossins.c	2005-08-15 16:14:05.000000000 +0900
@@ -23,7 +23,7 @@
 }
 
 int close (int x) {return liboss_close(x);}
-int write (int x, const void *y, size_t l)
+ssize_t write (int x, const void *y, size_t l)
 {
     return liboss_write(x,y,l);
 }
