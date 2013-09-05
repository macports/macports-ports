--- src/global/mail_params.h	2013-09-05 12:24:12.000000000 -0700
+++ src/global/mail_params.h.new	2013-09-05 12:22:41.000000000 -0700
@@ -241,7 +241,7 @@
   */
 #define VAR_QUEUE_DIR	"queue_directory"
 #ifndef DEF_QUEUE_DIR
-#define DEF_QUEUE_DIR	"/var/spool/postfix"
+#define DEF_QUEUE_DIR	"__PREFIX/var/spool/postfix"
 #endif
 extern char *var_queue_dir;
 
@@ -250,13 +250,13 @@
   */
 #define VAR_DAEMON_DIR		"daemon_directory"
 #ifndef DEF_DAEMON_DIR
-#define DEF_DAEMON_DIR		"/usr/libexec/postfix"
+#define DEF_DAEMON_DIR		"__PREFIX/libexec/postfix"
 #endif
 extern char *var_daemon_dir;
 
 #define VAR_COMMAND_DIR		"command_directory"
 #ifndef DEF_COMMAND_DIR
-#define DEF_COMMAND_DIR		"/usr/sbin"
+#define DEF_COMMAND_DIR		"__PREFIX/sbin"
 #endif
 extern char *var_command_dir;
 
@@ -288,7 +288,7 @@
   */
 #define VAR_CONFIG_DIR		"config_directory"
 #ifndef DEF_CONFIG_DIR
-#define DEF_CONFIG_DIR		"/etc/postfix"
+#define DEF_CONFIG_DIR		"__PREFIX/etc/postfix"
 #endif
 extern char *var_config_dir;
 
@@ -2489,22 +2489,22 @@
   */
 #define VAR_SENDMAIL_PATH		"sendmail_path"
 #ifndef DEF_SENDMAIL_PATH
-#define DEF_SENDMAIL_PATH		"/usr/sbin/sendmail"
+#define DEF_SENDMAIL_PATH		"__PREFIX/sbin/sendmail"
 #endif
 
 #define VAR_MAILQ_PATH			"mailq_path"
 #ifndef DEF_MAILQ_PATH
-#define DEF_MAILQ_PATH			"/usr/bin/mailq"
+#define DEF_MAILQ_PATH			"__PREFIX/bin/mailq"
 #endif
 
 #define VAR_NEWALIAS_PATH		"newaliases_path"
 #ifndef DEF_NEWALIAS_PATH
-#define DEF_NEWALIAS_PATH		"/usr/bin/newaliases"
+#define DEF_NEWALIAS_PATH		"__PREFIX/bin/newaliases"
 #endif
 
 #define VAR_MANPAGE_DIR			"manpage_directory"
 #ifndef DEF_MANPAGE_DIR
-#define DEF_MANPAGE_DIR			"/usr/local/man"
+#define DEF_MANPAGE_DIR			"__PREFIX/share/man"
 #endif
 
 #define VAR_SAMPLE_DIR			"sample_directory"
