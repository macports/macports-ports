--- ginsh/ginsh_parser.yy.sav	Thu Jan  8 10:53:36 2004
+++ ginsh/ginsh_parser.yy	Wed Apr 21 18:09:24 2004
@@ -29,12 +29,13 @@
 %{
 #include "config.h"
 
-#include <sys/resource.h>
-
 #if HAVE_UNISTD_H
 #include <sys/types.h>
 #include <unistd.h>
 #endif
+
+#include <sys/time.h>
+#include <sys/resource.h>
 
 #include <stdexcept>
 
