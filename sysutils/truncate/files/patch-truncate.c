--- truncate.c	Thu Mar  4 21:54:13 2004
+++ ../../truncate.c	Fri Sep 24 13:42:27 2004
@@ -45,7 +45,7 @@
 		new_size = atoll(argv[2]);
 	}
 
-	if (truncate64(argv[1], new_size) == -1)
+	if (truncate(argv[1], new_size) == -1)
 	{
 		if (errno == ENOENT)
 		{
@@ -63,7 +63,7 @@
 				return 2;
 			}
 
-			if (ftruncate64(fd, new_size) == -1)
+			if (ftruncate(fd, new_size) == -1)
 			{
 				header();
 				fprintf(stderr, "Failed to truncate new file %s to size %d, reason: %s\n", argv[1], new_size, strerror(errno));
