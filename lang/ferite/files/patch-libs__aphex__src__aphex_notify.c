--- libs/aphex/src/aphex_notify.c.orig	2005-04-27 04:18:02.000000000 -0400
+++ libs/aphex/src/aphex_notify.c	2005-04-27 04:18:37.000000000 -0400
@@ -1,8 +1,6 @@
 #include "../../../config.h"
 
-#ifndef USING_DARWIN
 # include <errno.h>
-#endif
 
 #include "poll.h"
 #include "aphex.h"
