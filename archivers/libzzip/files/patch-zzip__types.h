--- zzip/types.h.orig	2005-04-03 23:39:54.000000000 -0400
+++ zzip/types.h	2005-04-03 23:40:03.000000000 -0400
@@ -25,6 +25,7 @@
 #include <fcntl.h>
 #include <stddef.h> /* size_t and friends */
 /* msvc6 has neither ssize_t (we assume "int") nor off_t (assume "long") */
+#include <unistd.h>
 
 
 typedef       _zzip_off_t       zzip_off_t;
