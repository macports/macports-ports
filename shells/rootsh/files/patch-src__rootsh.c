--- src/rootsh.c.orig	Thu Mar 24 08:08:20 2005
+++ src/rootsh.c	Sun Mar 27 00:38:09 2005
@@ -42,6 +42,9 @@
 #include <sys/stat.h>
 #include <dirent.h>
 #include <regex.h>
+#include <sys/aio.h>
+#include <sys/ioctl.h>
+#include <util.h>
 #if HAVE_SYS_SELECT_H
 #  include <sys/select.h>
 #endif
@@ -177,7 +180,6 @@
 //  
 */
 extern char **environ;
-extern int errno;
 
 static char progName[MAXPATHLEN];
 static char sessionId[MAXPATHLEN + 11];
@@ -235,7 +237,7 @@
   //  
   //  long_options	Used by getopt_long.
   */
-  char *shell, *dashShell, *shellCommands = NULL;
+  char *shell, *dashShell = NULL, *shellCommands = NULL;
   char *sucmd = SUCMD;
   static char sessionIdEnv[sizeof(sessionId) + 17];
   fd_set readmask;
