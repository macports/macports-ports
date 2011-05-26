--- ssmtp.c.orig	2011-05-27 03:59:39.000000000 +1000
+++ ssmtp.c	2011-05-27 04:01:21.000000000 +1000
@@ -13,6 +13,7 @@
 #define VERSION "2.64"
 #define _GNU_SOURCE
 
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <sys/param.h>
@@ -24,6 +25,7 @@
 #include <setjmp.h>
 #include <string.h>
 #include <ctype.h>
+#include <libgen.h>
 #include <netdb.h>
 #ifdef HAVE_SSL
 #include <openssl/crypto.h>
@@ -2078,6 +2080,8 @@ main() -- make the program behave like s
 int main(int argc, char **argv)
 {
 	char **new_argv;
+	char *tmp1;
+	char *tmp2;
 
 	/* Try to be bulletproof :-) */
 	(void)signal(SIGHUP, SIG_IGN);
@@ -2086,7 +2090,25 @@ int main(int argc, char **argv)
 	(void)signal(SIGTTOU, SIG_IGN);
 
 	/* Set the globals */
-	prog = basename(argv[0]);
+	/* basename may write to its input string, so we can't give it argv;
+	   plus the string it returns isn't permanently malloc'd, so we have to
+	   make a copy */
+	tmp1 = strdup(argv[0]);
+	if (!tmp1) {
+	    perror("strdup");
+	    die("main: strdup()");
+	}
+	tmp2 = basename(tmp1);
+	if (!tmp2) {
+	    perror("basename");
+	    die("main: basename()");
+	}
+	prog = strdup(tmp2);
+	if (!prog) {
+	    perror("strdup");
+	    die("main: strdup()");
+	}
+	free(tmp1);
 
 	hostname = xgethostname();
 
