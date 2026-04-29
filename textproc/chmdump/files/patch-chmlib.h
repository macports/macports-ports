--- chmlib.h.orig	2005-01-05 22:30:33.000000000 -0800
+++ chmlib.h	2005-01-05 22:30:51.000000000 -0800
@@ -20,7 +20,7 @@
 
 #include <stdio.h>
 typedef unsigned long ulong;
-// typedef unsigned short ushort; Already defined for Darwin
+typedef unsigned short ushort;
 typedef unsigned char ubyte;
 
 typedef struct guid_t
