--- loadparts.cpp.orig	Wed Nov 19 09:49:31 2003
+++ loadparts.cpp	Fri Mar 19 18:17:45 2004
@@ -245,7 +245,7 @@
 
 	while ('\\' == line[l-1]) {
             // concat next line(s)
-	    int bufsize = clamp(0U, sizeof(line)-l, sizeof(line)-1);
+	    int bufsize = clamp((long unsigned int)0, sizeof(line)-l, sizeof(line)-1);
 	    fgets(&line[l-2], bufsize, fp);
 	    if (feof((FILE*)fp)) break;
 	    l = strlen(line);
