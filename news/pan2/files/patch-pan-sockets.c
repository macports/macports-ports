--- pan/sockets.c.orig	Sun Mar  9 18:41:42 2003
+++ pan/sockets.c	Sun Mar  9 18:42:07 2003
@@ -25,7 +25,6 @@
 
 #include <errno.h>
 #include <string.h>
-#include <signal.h> /* for sigignore(SIGPIPE) on unix */
 #include <unistd.h>
 
 #include <glib.h>
@@ -91,11 +90,6 @@
 	g_return_val_if_fail (is_nonempty_string (server_name), NULL);
 	g_return_val_if_fail (is_nonempty_string (server_address), NULL);
 	g_return_val_if_fail (port>=0, NULL);
-
-	/* needed on Unix */
-#	ifdef SIGPIPE
-	sigignore (SIGPIPE);
-#	endif
 
 	/* create the socket */
 	sock = g_new0 (PanSocket, 1);	
