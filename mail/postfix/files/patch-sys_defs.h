--- src/util/sys_defs.h.orig	Wed Nov  5 21:17:37 2003
+++ src/util/sys_defs.h	Wed Jan 21 20:31:50 2004
@@ -52,11 +52,11 @@
 #define STATFS_IN_SYS_MOUNT_H
 #define HAS_POSIX_REGEXP
 #define HAS_ST_GEN	/* struct stat contains inode generation number */
-#define NATIVE_SENDMAIL_PATH "/usr/sbin/sendmail"
-#define NATIVE_MAILQ_PATH "/usr/bin/mailq"
-#define NATIVE_NEWALIAS_PATH "/usr/bin/newaliases"
-#define NATIVE_COMMAND_DIR "/usr/sbin"
-#define NATIVE_DAEMON_DIR "/usr/libexec/postfix"
+#define NATIVE_SENDMAIL_PATH "__PREFIX/sbin/sendmail"
+#define NATIVE_MAILQ_PATH "__PREFIX/bin/mailq"
+#define NATIVE_NEWALIAS_PATH "__PREFIX/bin/newaliases"
+#define NATIVE_COMMAND_DIR "__PREFIX/sbin"
+#define NATIVE_DAEMON_DIR "__PREFIX/libexec/postfix"
 #endif
 
 #if defined(FREEBSD2) || defined(FREEBSD3) || defined(FREEBSD4)
@@ -88,10 +88,10 @@
 #define HAS_FSYNC
 #define HAS_DB
 #define HAS_SA_LEN
-#define DEF_DB_TYPE	"hash"
-#define ALIAS_DB_MAP	"hash:/etc/aliases"
+#define DEF_DB_TYPE	"netinfo"
+#define ALIAS_DB_MAP	"netinfo:/aliases"
 #define GETTIMEOFDAY(t) gettimeofday(t,(struct timezone *) 0)
-#define ROOT_PATH	"/bin:/usr/bin:/sbin:/usr/sbin"
+#define ROOT_PATH	"/bin:/usr/bin:/sbin:/usr/sbin:__PREFIX/bin:__PREFIX/sbin"
 #define USE_STATFS
 #define STATFS_IN_SYS_MOUNT_H
 #define HAS_POSIX_REGEXP
