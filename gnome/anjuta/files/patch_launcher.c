--- src/launcher.c.org	Fri Feb  6 14:49:34 2004
+++ src/launcher.c	Fri Feb  6 14:50:27 2004
@@ -23,10 +23,10 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <signal.h>
-#include <pty.h>
 #include <assert.h>
 #include <gnome.h>
 #include <termios.h>
+#include <vte/pty.h>
 
 #include "pixmaps.h"
 #include "launcher.h"
@@ -36,6 +36,15 @@
 #include "anjuta.h"
 
 #define FILE_BUFFER_SIZE 1024
+
+#ifndef __MAX_BAUD
+#  define __MAX_BAUD B115200
+#endif
+
+#ifndef O_SYNC
+#  define O_SYNC O_FSYNC
+#endif
+
 /*
 static gboolean
 anjuta_launcher_pty_check_child_exit_code (AnjutaLauncher *launcher,
