--- src/global/mail_params.h.orig	2015-01-18 11:06:00.000000000 +1100
+++ src/global/mail_params.h	2015-02-12 15:50:26.000000000 +1100
@@ -269,7 +269,7 @@ extern int var_smtp_mxsess_limit;
   */
 #define VAR_QUEUE_DIR	"queue_directory"
 #ifndef DEF_QUEUE_DIR
-#define DEF_QUEUE_DIR	"/var/spool/postfix"
+#define DEF_QUEUE_DIR	"__PREFIX/var/spool/postfix"
 #endif
 extern char *var_queue_dir;
 
@@ -278,13 +278,13 @@ extern char *var_queue_dir;
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
 
@@ -302,7 +302,7 @@ extern char *var_pid_dir;
   */
 #define VAR_DATA_DIR		"data_directory"
 #ifndef DEF_DATA_DIR
-#define DEF_DATA_DIR		"/var/lib/postfix"
+#define DEF_DATA_DIR		"__PREFIX/var/lib/postfix"
 #endif
 extern char *var_data_dir;
 
@@ -316,7 +316,7 @@ extern time_t var_starttime;
   */
 #define VAR_CONFIG_DIR		"config_directory"
 #ifndef DEF_CONFIG_DIR
-#define DEF_CONFIG_DIR		"/etc/postfix"
+#define DEF_CONFIG_DIR		"__PREFIX/etc/postfix"
 #endif
 extern char *var_config_dir;
 
@@ -2589,22 +2589,22 @@ extern int var_fault_inj_code;
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
@@ -3881,7 +3881,7 @@ extern char *var_smtpd_dns_re_filter;
   */
 #define VAR_SHLIB_DIR	"shlib_directory"
 #ifndef DEF_SHLIB_DIR
-#define DEF_SHLIB_DIR	"/usr/lib/postfix"
+#define DEF_SHLIB_DIR	"__PREFIX/lib/postfix"
 #endif
 extern char *var_shlib_dir;
 
