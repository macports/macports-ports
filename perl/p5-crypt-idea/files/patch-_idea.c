--- _idea.c.orig	Tue Dec 28 23:29:28 2004
+++ _idea.c	Tue Dec 28 23:31:38 2004
@@ -5,7 +5,7 @@
 
 #include "idea.h"
 
-#include <endian.h>
+#include <machine/endian.h>
 
 #define KEYS_PER_ROUND	6
 #define ROUNDS			8 
