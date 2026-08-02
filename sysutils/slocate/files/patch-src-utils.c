--- src/utils.c	2006-01-06 09:16:19.000000000 +0900
+++ src/utils.c	2006-10-22 10:33:13.000000000 +0900
@@ -130,7 +130,7 @@
 			}
 			
 		} else
-		    foundit = (strcasestr(search_str, search_str) != NULL);
+		    foundit = (strcasestr(full_path, search_str) != NULL);
 
 #endif /* FNM_CASEFOLD */
 	} 
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
 
