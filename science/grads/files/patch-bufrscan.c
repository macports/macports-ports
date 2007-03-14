--- src/bufrscan.c.orig	2007-03-14 11:08:44.000000000 +0900
+++ src/bufrscan.c	2007-03-14 11:08:59.000000000 +0900
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include <sys/types.h>
 #include "gabufr.h"
 
 #ifndef HAVE_FSEEKO
