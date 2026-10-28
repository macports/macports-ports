--- src/ftplib.h.orig	2006-07-11 19:19:02.000000000 +0200
+++ src/ftplib.h	2006-07-11 19:19:18.000000000 +0200
@@ -1,6 +1,6 @@
 #ifndef __FTPLIB_H
 #define __FTPLIB_H
-
+#include <time.h>
 #include "socketlib.h"
 #define SAVE_STRCMP(a,b) ((!a && !b) || (a && b && !strcmp(a,b)))
 
