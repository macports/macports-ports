--- src/rootsh.c.orig	2009-06-28 03:19:08.000000000 -0700
+++ src/rootsh.c	2009-06-28 03:24:41.000000000 -0700
@@ -43,6 +43,8 @@
 #include <dirent.h>
 #include <regex.h>
 #include <wordexp.h>
+#include <sys/ioctl.h>
+#include <util.h>
 #if HAVE_SYS_SELECT_H
 #  include <sys/select.h>
 #endif
@@ -180,7 +182,6 @@
 //  
 */
 extern char **environ;
-extern int errno;
 
 volatile sig_atomic_t sigwinch_received;
 
@@ -242,7 +243,7 @@
   //  
   //  long_options	Used by getopt_long.
   */
-  char *shell, *dashShell, *shellCommands = NULL;
+  char *shell, *dashShell = NULL, *shellCommands = NULL;
   char *sucmd = SUCMD;
   static char sessionIdEnv[sizeof(sessionId) + 17];
   fd_set readmask;
@@ -296,7 +297,9 @@
         version();
         break;
       case 'c':
+	/*
 	// if they supply a -c somewhere and it isn't the first arg, then the command is no good
+	*/
 	if ( strcmp("-c", argv[1]) ) usage ();
 	doscp = 1;
 	break;
@@ -339,10 +342,10 @@
   // The user requested a SCP command
   */
   if (doscp) {
+	  int i;
 	  if (! beginlogging()) {
 		  exit(EXIT_FAILURE);
 	  }
-	  int i;
 	  for ( i = 0; i < argc; i++ ) {
 		  dologging(argv[i], sizeof(argv[i]));
 		  dologging("\n", sizeof("\n"));
@@ -834,7 +837,8 @@
         */
         msglen = snprintf(msgbuf, (sizeof(msgbuf) - 1),
             "*** USER TRIED TO DELETE AND RECREATE THIS FILE ***\r\n");
-        unlink(logFileName) && rmdir(logFileName);
+        if (unlink(logFileName))
+          rmdir(logFileName);
       } else {
         if (fstat(logFile, &statBuf) == -1) {
           /*
