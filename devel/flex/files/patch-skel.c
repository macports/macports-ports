--- flex-2.5.31/skel.c.orig	Mon Feb 21 10:43:59 2005
+++ flex-2.5.31/skel.c	Mon Feb 21 10:44:04 2005
@@ -169,6 +169,7 @@
   "#include <string.h>",
   "#include <errno.h>",
   "#include <stdlib.h>",
+  "#include <stdint.h>",
   "%endif",
   "",
   "%if-tables-serialization",
