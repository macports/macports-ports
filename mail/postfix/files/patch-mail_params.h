--- src/global/mail_params.h	Mon Mar  3 23:07:03 2003
+++ src/global/mail_params.h.new	Sat Jun 21 13:12:41 2003
@@ -178,7 +178,7 @@
   */
 #define VAR_QUEUE_DIR	"queue_directory"
 #ifndef DEF_QUEUE_DIR
-#define DEF_QUEUE_DIR	"/var/spool/postfix"
+#define DEF_QUEUE_DIR	"__PREFIX/var/spool/postfix"
 #endif
 extern char *var_queue_dir;
 
@@ -187,18 +187,18 @@
   */
 #define VAR_PROGRAM_DIR		"program_directory"
 #ifndef DEF_PROGRAM_DIR
-#define DEF_PROGRAM_DIR		"/usr/libexec/postfix"
+#define DEF_PROGRAM_DIR		"__PREFIX/libexec/postfix"
 #endif
 
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
 
@@ -221,7 +221,7 @@
   */
 #define VAR_CONFIG_DIR		"config_directory"
 #ifndef DEF_CONFIG_DIR
-#define DEF_CONFIG_DIR		"/etc/postfix"
+#define DEF_CONFIG_DIR		"__PREFIX/etc/postfix"
 #endif
 extern char *var_config_dir;
 
@@ -1525,22 +1525,22 @@
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
+#define DEF_MANPAGE_DIR			"__PREFIX/local/man"
 #endif
 
 #define VAR_SAMPLE_DIR			"sample_directory"
