--- gsf/gsf-infile-stdio.c.org	Mon May 10 09:00:19 2004
+++ gsf/gsf-infile-stdio.c	Mon May 10 09:00:30 2004
@@ -39,7 +39,7 @@
 #include <dirent.h>
 #include <string.h>
 
-GObjectClass *parent_class;
+extern GObjectClass *parent_class;
 
 struct _GsfInfileStdio {
 	GsfInfile parent;
