--- config.h.orig	Tue Jun 24 22:12:38 2003
+++ config.h	Tue Jun 24 22:15:00 2003
@@ -33,8 +33,8 @@
  * override those settings you should uncomment and possibly change the
  * DEFSPATH and DEFPATH defines below
  */
-/*#define DEFSPATH	"PATH=/bin:/usr/bin"			/* */
-/*#define DEFPATH	"PATH=$HOME/bin:/bin:/usr/bin"		/* */
+#define DEFSPATH "PATH=/bin:/usr/bin:@PREFIX@/bin:/usr/X11R6/bin"
+#define DEFPATH "PATH=$HOME/bin:/bin:/usr/bin:@PREFIX@/bin:/usr/X11R6/bin"
 
 /* every environment variable appearing in PRESTENV will be set or wiped
  * out of the environment (variables without an '=' sign will be thrown
@@ -116,11 +116,11 @@
 	is not found, maildelivery will proceed as normal to the default
 	system mailbox.	 This also must be an absolute path */
 
-#define ETCRC	"/etc/procmailrc"	/* optional global procmailrc startup
+#define ETCRC	"@PREFIX@/etc/procmailrc"	/* optional global procmailrc startup
 					   file (will only be read if procmail
 	is started with no rcfile on the command line). */
 
-#define ETCRCS	"/etc/procmailrcs/"	/* optional trusted path prefix for
+#define ETCRCS	"@PREFIX@/etc/procmailrcs/"	/* optional trusted path prefix for
 					   rcfiles which will be executed with
 	the uid of the owner of the rcfile (this only happens if procmail is
 	called with the -m option, without variable assignments on the command
