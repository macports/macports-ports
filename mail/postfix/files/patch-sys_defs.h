--- src/util/sys_defs.h.org	2007-10-17 21:27:59.000000000 -0700
+++ src/util/sys_defs.h	2007-10-17 21:32:35.000000000 -0700
@@ -185,10 +185,10 @@
 #define HAS_DB
 #define HAS_SA_LEN
 #define DEF_DB_TYPE	"hash"
-#define ALIAS_DB_MAP	"hash:/etc/aliases"
+#define ALIAS_DB_MAP	"hash:__PREFIX/etc/postfix/aliases"
 #define GETTIMEOFDAY(t) gettimeofday(t,(struct timezone *) 0)
 #define RESOLVE_H_NEEDS_NAMESER8_COMPAT_H
-#define ROOT_PATH	"/bin:/usr/bin:/sbin:/usr/sbin"
+#define ROOT_PATH	"__PREFIX/bin:/usr/bin:/sbin:/usr/sbin"
 #define USE_STATFS
 #define STATFS_IN_SYS_MOUNT_H
 #define HAS_POSIX_REGEXP
@@ -203,11 +203,11 @@
 # define HAVE_GETIFADDRS
 #endif
 #define HAS_FUTIMES			/* XXX Guessing */
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
 #define SOCKADDR_SIZE	socklen_t
 #define SOCKOPT_SIZE	socklen_t
 #endif
