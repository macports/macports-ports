--- converter/other/cameratopam/cameratopam.c.orig	2005-10-01 11:25:21.000000000 -0400
+++ converter/other/cameratopam/cameratopam.c	2005-10-01 11:26:49.000000000 -0400
@@ -32,6 +32,7 @@
   static bool const have64BitArithmetic = true;
 #else
   #include <unistd.h>
+  #include <sys/types.h>
   #include <netinet/in.h>
 #endif
 
