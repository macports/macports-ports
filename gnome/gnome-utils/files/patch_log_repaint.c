--- logview/log_repaint.c.org	Sun Jul 27 18:01:20 2003
+++ logview/log_repaint.c	Sun Jul 27 18:01:32 2003
@@ -24,7 +24,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <string.h>
 #include <gnome.h>
 #include "logview.h"
