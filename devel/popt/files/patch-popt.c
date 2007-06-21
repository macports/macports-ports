--- ./popt.c.orig	2007-06-14 15:31:10.000000000 +0200
+++ ./popt.c	2007-06-21 22:34:24.000000000 +0200
@@ -396,7 +396,7 @@
     if (!strchr(item->argv[0], '/') && con->execPath != NULL) {
 	char *s = malloc(strlen(con->execPath) + strlen(item->argv[0]) + sizeof("/"));
 	if (s)
-	    sprintf(s, "%s/%s", con->execPath, item->argv[-1]);
+	    sprintf(s, "%s/%s", con->execPath, item->argv[0]);
 	argv[argc] = s;
     } else
 	argv[argc] = POPT_findProgramPath(item->argv[0]);
