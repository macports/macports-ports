--- src/mrss_parser.c	2007-04-02 14:55:34.000000000 +0200
+++ src/mrss_parser.c	2007-04-03 23:02:59.000000000 +0200
@@ -22,6 +22,8 @@
 # error Use configure; make; make install
 #endif
 
+#include <xlocale.h>
+
 #include "mrss_internal.h"
 #include "mrss.h"
 
