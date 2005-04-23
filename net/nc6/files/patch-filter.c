Index: src/filter.c
diff -u src/filter.c.orig src/filter.c
--- src/filter.c.orig	Mon Apr 14 18:00:50 2003
+++ src/filter.c	Thu Oct 30 00:23:07 2003
@@ -205,8 +205,14 @@
 	if (err != 0) {
 		/* some errors just indicate that the address wasn't suitable */
 		switch (err) {
+#ifdef EAI_NODATA
 		case EAI_NODATA:
+#else
+		case EAI_NONAME:
+#endif
+#ifdef EAI_ADDRFAMILY
 		case EAI_ADDRFAMILY:
+#endif
 		case EAI_SERVICE:
 		case EAI_SOCKTYPE:
 			return FALSE;
