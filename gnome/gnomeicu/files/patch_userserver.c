--- src/userserver.c.org	Sun Feb  1 08:55:26 2004
+++ src/userserver.c	Sun Feb  1 08:55:43 2004
@@ -28,13 +28,13 @@
 #include <gdk/gdk.h>
 #include <gdk/gdkkeysyms.h>
 #include <errno.h>
-#include <netinet/in.h>
 #include <pwd.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <netinet/in.h>
 #include <sys/stat.h>
 #include <sys/un.h>
 #include <unistd.h>
