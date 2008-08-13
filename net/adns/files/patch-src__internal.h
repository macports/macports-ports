--- src/internal.h.orig	2008-08-12 21:30:51.000000000 -0700
+++ src/internal.h	2008-08-12 21:31:01.000000000 -0700
@@ -185,7 +185,7 @@
   void *p;
   void (*fp)(void);
   union maxalign *up;
-} data;
+};
 
 typedef struct {
   void *ext;
