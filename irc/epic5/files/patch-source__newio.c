--- source/newio.c.orig	Wed Feb  2 19:04:43 2005
+++ source/newio.c	Wed Feb  2 19:05:20 2005
@@ -111,7 +111,7 @@
 {
 	char		*buffer;
 	size_t		buffer_size;
-	unsigned 	read_pos,
+	size_t 		read_pos,
 			write_pos;
 	int		segments;
 	int		error;
