--- gsf/gsf-outfile-stdio.c.org	Mon May 10 09:07:49 2004
+++ gsf/gsf-outfile-stdio.c	Mon May 10 09:08:00 2004
@@ -37,7 +37,7 @@
 #include <sys/stat.h>
 #include <dirent.h>
 
-GObjectClass *parent_class;
+extern GObjectClass *parent_class;
 
 struct _GsfOutfileStdio {
 	GsfOutfile parent;
