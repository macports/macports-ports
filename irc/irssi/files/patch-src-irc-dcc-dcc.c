--- src/irc/dcc/dcc.c.orig	Fri Dec  9 01:32:48 2005
+++ src/irc/dcc/dcc.c	Thu May  4 13:39:02 2006
@@ -58,8 +58,8 @@
 
 	pos = gslist_find_string(dcc_types, type);
 	if (pos != NULL) {
-                dcc_types = g_slist_remove(dcc_types, pos->data);
 		g_free(pos->data);
+                dcc_types = g_slist_remove(dcc_types, pos->data);
 	}
 }
 

