--- memory.c.orig	2005-08-18 23:15:54.000000000 +0200
+++ memory.c	2007-06-25 14:54:48.000000000 +0200
@@ -4,10 +4,16 @@
  * daniel@veillard.com
  */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <sys/types.h>
 #include <string.h>
 #include <stdio.h>
+#ifdef HAVE_MALLOC_H
 #include <malloc.h>
+#endif
 #include <libxml/xmlmemory.h>
 #include "memory.h"
 
