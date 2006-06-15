--- epan/filesystem.c.b	2006-04-17 07:46:53.000000000 -0700
+++ epan/filesystem.c	2006-06-14 23:04:21.000000000 -0700
@@ -300,7 +300,7 @@
 			return;
 		}
 		curdir = g_malloc(path_max);
-		if (getcwd(curdir, sizeof curdir) == NULL) {
+		if (getcwd(curdir, path_max) == NULL) {
 			/*
 			 * It failed - give up, and just stick
 			 * with DATAFILE_DIR.
