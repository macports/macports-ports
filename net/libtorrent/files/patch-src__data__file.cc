--- src/data/file.cc.orig	Tue Dec 28 02:50:38 2004
+++ src/data/file.cc	Tue Dec 28 02:51:03 2004
@@ -21,7 +21,6 @@
 		   (flags & in  ? O_RDONLY : 0) |
 		   (flags & out ? O_WRONLY : 0)) |
 		  
-		  (flags & largefile ? O_LARGEFILE : 0) |
 		  (flags & create    ? O_CREAT     : 0) |
 		  (flags & truncate  ? O_TRUNC     : 0) |
 		  (flags & nonblock  ? O_NONBLOCK  : 0),
