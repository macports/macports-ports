--- gdcache.h.old	Tue Feb  6 20:44:02 2001
+++ gdcache.h	Wed Jun 13 21:58:15 2001
@@ -40,7 +40,9 @@
 /* header                                                */
 /*********************************************************/
 
+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #ifndef NULL
 #define NULL (void *)0
 #endif
