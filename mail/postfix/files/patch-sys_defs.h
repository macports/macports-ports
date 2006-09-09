--- src/util/sys_defs.h.orig	2006-07-03 22:37:32.000000000 +1000
+++ src/util/sys_defs.h	2006-08-11 02:11:36.000000000 +1000
@@ -161,10 +161,10 @@
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
@@ -178,11 +178,11 @@
 # define HAS_IPV6
 # define HAVE_GETIFADDRS
 #endif
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
 
  /*
