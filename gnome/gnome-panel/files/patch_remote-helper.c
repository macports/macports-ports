--- applets/gen_util/remote-helper.c.org	Sun Jul 27 15:45:27 2003
+++ applets/gen_util/remote-helper.c	Sun Jul 27 15:47:36 2003
@@ -17,7 +17,7 @@
 #include <sys/wait.h>
 #include <signal.h>
 #include <errno.h>
-#include <poll.h>
+#include <sys/poll.h>
 
 #include "popcheck.h"
 
