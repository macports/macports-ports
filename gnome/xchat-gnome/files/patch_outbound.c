--- src/common/outbound.c.org	Tue May 11 09:59:47 2004
+++ src/common/outbound.c	Tue May 11 10:00:19 2004
@@ -1233,7 +1233,6 @@
 	free (nbuf);
 }
 
-#ifndef HAVE_MEMRCHR
 static void *
 memrchr (const void *block, int c, size_t size)
 {
@@ -1244,7 +1243,6 @@
 			return p;
 	return 0;
 }
-#endif
 
 static gboolean
 exec_data (GIOChannel *source, GIOCondition condition, struct nbexec *s)
