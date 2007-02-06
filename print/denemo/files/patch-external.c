--- src/external.c.orig	2007-02-06 12:25:59.000000000 -0500
+++ src/external.c	2007-02-06 12:27:40.000000000 -0500
@@ -12,6 +12,7 @@
 #include "prefops.h"
 #include <signal.h>
 #include "external.h"
+#include <unistd.h>
 
 
 /* test it a given temp filename points to an 
