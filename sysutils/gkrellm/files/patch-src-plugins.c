--- src/plugins.c.org	2006-03-29 14:56:02.000000000 -0800
+++ src/plugins.c	2006-04-30 00:01:54.000000000 -0700
@@ -1156,9 +1156,6 @@
 	scan_for_plugins(LOCAL_PLUGINS_DIR);
 #endif
 
-#if defined(SYSTEM_PLUGINS_DIR)
-	scan_for_plugins(SYSTEM_PLUGINS_DIR);
-#endif
 	}
 
 #if 0
