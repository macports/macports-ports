--- kanji.c~	2006-08-08 00:00:00.000000000 +0900
+++ kanji.c	2006-08-09 13:04:03.000000000 +0900
@@ -730,11 +730,13 @@
 	else strcatdelim2(path, unitblpath, file);
 
 	if ((fd = Xopen(path, O_BINARY | O_RDONLY, 0666)) < 0) fd = -1;
-	else if (!unitblent && sureread(fd, buf, 2) != 2) {
+	else if (!unitblent) {
+	  if (sureread(fd, buf, 2) != 2) {
 		Xclose(fd);
 		fd = -1;
+	  }
+	  else unitblent = getword(buf, 0);
 	}
-	else unitblent = getword(buf, 0);
 
 	return(fd);
 }
