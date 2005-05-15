--- src/internal.h	2003-06-22 06:58:15.000000000 -0700
+++ src/internal.h	2005-05-12 00:29:31.000000000 -0700
@@ -160,7 +160,7 @@
   void *p;
   void (*fp)(void);
   union maxalign *up;
-} data;
+};
 
 typedef struct {
   void *ext;
