--- src/util/sys_defs.h	Thu Apr 14 00:07:32 2005
+++ src/util/sys_defs.h.new	Thu Jul  7 11:53:17 2005
@@ -43,13 +43,13 @@
 #define HAS_SA_LEN
 #define DEF_DB_TYPE	"hash"
 #if (defined(__NetBSD_Version__) && __NetBSD_Version__ >= 104250000)
-#define ALIAS_DB_MAP   "hash:/etc/mail/aliases"	/* sendmail 8.10 */
+#define ALIAS_DB_MAP   "hash:__PREFIX/etc/mail/aliases"	/* sendmail 8.10 */
 #endif
 #ifndef ALIAS_DB_MAP
-#define ALIAS_DB_MAP	"hash:/etc/aliases"
+#define ALIAS_DB_MAP	"hash:__PREFIX/etc/aliases"
 #endif
 #define GETTIMEOFDAY(t)	gettimeofday(t,(struct timezone *) 0)
-#define ROOT_PATH	"/bin:/usr/bin:/sbin:/usr/sbin"
+#define ROOT_PATH	"__PREFIX/bin:/bin:/usr/bin:/sbin:/usr/sbin"
 #if (defined(__NetBSD_Version__) && __NetBSD_Version__ > 200040000)
 # define USE_STATVFS
 # define STATVFS_IN_SYS_STATVFS_H
@@ -59,11 +59,11 @@
 #endif
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
 
 #ifdef BSDI4
@@ -153,9 +153,9 @@
 #define HAS_DB
 #define HAS_SA_LEN
 #define DEF_DB_TYPE	"hash"
-#define ALIAS_DB_MAP	"hash:/etc/aliases"
+#define ALIAS_DB_MAP	"hash:__PREFIX/etc/aliases"
 #define GETTIMEOFDAY(t) gettimeofday(t,(struct timezone *) 0)
-#define ROOT_PATH	"/bin:/usr/bin:/sbin:/usr/sbin"
+#define ROOT_PATH	"__PREFIX/bin:/bin:/usr/bin:/sbin:/usr/sbin"
 #define USE_STATFS
 #define STATFS_IN_SYS_MOUNT_H
 #define HAS_POSIX_REGEXP
@@ -169,11 +169,11 @@
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
