$NetBSD: patch-ab,v 1.4 2002/03/06 15:07:54 martti Exp $

--- src/util/sys_defs.h.orig	Tue Feb 12 13:46:16 2002
+++ src/util/sys_defs.h	Tue Feb 12 13:47:13 2002
@@ -52,11 +52,11 @@
 #define STATFS_IN_SYS_MOUNT_H
 #define HAS_POSIX_REGEXP
 #define HAS_ST_GEN	/* struct stat contains inode generation number */
-#define DEF_SENDMAIL_PATH "/usr/sbin/sendmail"
-#define DEF_MAILQ_PATH	"/usr/bin/mailq"
-#define DEF_NEWALIAS_PATH "/usr/bin/newaliases"
-#define DEF_COMMAND_DIR	"/usr/sbin"
-#define DEF_DAEMON_DIR	"/usr/libexec/postfix"
+#define DEF_SENDMAIL_PATH "__PREFIX/sbin/sendmail"
+#define DEF_MAILQ_PATH	"__PREFIX/bin/mailq"
+#define DEF_NEWALIAS_PATH "__PREFIX/bin/newaliases"
+#define DEF_COMMAND_DIR	"__PREFIX/sbin"
+#define DEF_DAEMON_DIR	"__PREFIX/libexec/postfix"
 #endif
 
 #if defined(FREEBSD2) || defined(FREEBSD3) || defined(FREEBSD4)
