--- image/new.c.orig	Wed Nov 12 11:08:13 2003
+++ image/new.c	Wed Nov 12 11:08:20 2003
@@ -11,7 +11,7 @@
 #include "copyright.h"
 #include "image.h"
 
-#include <malloc.h>
+#include <unistd.h>
 
 extern int _Xdebug;
 extern void memoryExhausted(void);
