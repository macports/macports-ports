--- mktool.c	2005-04-28 10:11:24.000000000 +0200
+++ mktool.c	2005-11-24 19:59:06.000000000 +0100
@@ -82,7 +82,7 @@
 		" -std=c89",
 		" -fPIC",
 		" -fPIC",
-		" -install_name lib%n.%1.%2.dylib",
+		" -install_name __LIBDIR__/lib%n.%1.%2.dylib",
 		" -current_version %1.%2.%3",
 		" -dynamiclib",
 		"",
