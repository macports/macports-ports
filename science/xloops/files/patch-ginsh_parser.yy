--- ginsh/ginac/ginsh_parser.yy.orig	2005-09-08 08:45:41.000000000 -0400
+++ ginsh/ginac/ginsh_parser.yy	2006-04-13 14:07:41.000000000 -0400
@@ -29,13 +29,14 @@
 %{
 #include "config.h"
 
-#include <sys/resource.h>
-
 #if HAVE_UNISTD_H
 #include <sys/types.h>
 #include <unistd.h>
 #endif
 
+#include <sys/time.h>
+#include <sys/resource.h>
+
 #include <stdexcept>
 
 #include "ginsh.h"
