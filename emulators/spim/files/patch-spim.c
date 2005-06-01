--- spim.c.orig	2005-06-01 01:02:42.000000000 -0400
+++ spim.c	2005-06-01 01:02:51.000000000 -0400
@@ -111,7 +111,7 @@
 
 /* Non-zero => load standard exception handler */
 static int load_exception_handler = 1;
-static char *exception_file_name = DEFAULT_EXCEPTION_HANDLER;
+char *exception_file_name = DEFAULT_EXCEPTION_HANDLER;
 static int console_state_saved;
 #ifdef USE_TERMIOS
 static struct termios saved_console_state;
