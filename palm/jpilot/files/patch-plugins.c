diff -rauN plugins.c.orig plugins.c
--- plugins.c.orig	Mon Sep  1 05:54:10 2003
+++ plugins.c	Sun Mar 21 14:12:26 2004
@@ -19,6 +19,7 @@
 
 #include "config.h"
 #ifdef  ENABLE_PLUGINS
+#include <sys/types.h>
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
