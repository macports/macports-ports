--- src/rootsh.c.orig	Fri Dec 17 20:04:39 2004
+++ src/rootsh.c	Wed Feb  2 16:59:16 2005
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
@@ -167,7 +170,6 @@
 //  
 */
 extern char **environ;
-extern int errno;
 
 static char progName[MAXPATHLEN];
 static char sessionId[MAXPATHLEN + 11];
@@ -222,7 +224,7 @@
   //  
   //  long_options	Used by getopt_long.
   */
-  char *shell, *dashShell, *shellCommands = NULL;
+  char *shell, *dashShell = NULL, *shellCommands = NULL;
   char *sucmd = SUCMD;
   fd_set readmask;
   int n, childPid;
