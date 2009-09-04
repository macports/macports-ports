--- src/signals.c.orig	2009-09-03 21:49:37.000000000 -0700
+++ src/signals.c	2009-09-03 21:49:56.000000000 -0700
@@ -503,9 +503,9 @@
     while (1) {
 	len = strcspn(dir, ":\0");
 	if (*dir == '/')
-	    sprintf(exebuf, "%.*s/%s", len, dir, argv0);
+	    sprintf(exebuf, "%.*s/%s", (int)len, dir, argv0);
 	else
-	    sprintf(exebuf, "%s/%.*s/%s", initial_dir, len, dir, argv0);
+	    sprintf(exebuf, "%s/%.*s/%s", initial_dir, (int)len, dir, argv0);
 	if (stat(exebuf, &statbuf) == 0)
 	    return exebuf;
 	if (!dir[len])
