--- log.c.orig	2005-06-06 06:04:35.000000000 -0400
+++ log.c	2005-06-06 06:04:38.000000000 -0400
@@ -80,7 +80,7 @@
 		}
 		return 0;
 	} else
-		free(tmp);
+		closedir(tmp);
 
 	return 0;
 }
