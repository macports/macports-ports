--- src/utils.c.orig	2006-07-26 00:06:53.000000000 +0900
+++ src/utils.c	2006-07-26 00:08:07.000000000 +0900
@@ -139,6 +139,7 @@
 	    ret = 1;		
 
 EXIT:
+#ifndef FNM_CASEFOLD
 	if (nocase_str)
 	    free(nocase_str);
 	nocase_str = NULL;
@@ -147,7 +148,8 @@
 	    free(nocase_path);
 	
 	nocase_path = NULL;
-	
+#endif
+
 	return ret;
 }
 
