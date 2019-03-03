--- src/global/mail_params.h.orig	2019-02-12 00:05:13.000000000 +1100
+++ src/global/mail_params.h	2019-03-03 14:26:12.000000000 +1100
@@ -279,7 +279,7 @@ extern int var_smtp_mxsess_limit;
   */
 #define VAR_QUEUE_DIR	"queue_directory"
 #ifndef DEF_QUEUE_DIR
-#define DEF_QUEUE_DIR	"/var/spool/postfix"
+#define DEF_QUEUE_DIR	"__PREFIX/var/spool/postfix"
 #endif
 extern char *var_queue_dir;
 
@@ -288,13 +288,13 @@ extern char *var_queue_dir;
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
 
@@ -312,7 +312,7 @@ extern char *var_pid_dir;
   */
 #define VAR_DATA_DIR		"data_directory"
 #ifndef DEF_DATA_DIR
-#define DEF_DATA_DIR		"/var/lib/postfix"
+#define DEF_DATA_DIR		"__PREFIX/var/lib/postfix"
 #endif
 extern char *var_data_dir;
 
@@ -326,7 +326,7 @@ extern time_t var_starttime;
   */
 #define VAR_CONFIG_DIR		"config_directory"
 #ifndef DEF_CONFIG_DIR
-#define DEF_CONFIG_DIR		"/etc/postfix"
+#define DEF_CONFIG_DIR		"__PREFIX/etc/postfix"
 #endif
 extern char *var_config_dir;
 
@@ -2689,28 +2689,28 @@ extern int var_fault_inj_code;
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
 
 #define VAR_OPENSSL_PATH		"openssl_path"
 #ifndef DEF_OPENSSL_PATH
-#define DEF_OPENSSL_PATH		"openssl"
+#define DEF_OPENSSL_PATH		"__PREFIX/bin/openssl"
 #endif
 extern char *var_openssl_path;
 
 #define VAR_MANPAGE_DIR			"manpage_directory"
 #ifndef DEF_MANPAGE_DIR
-#define DEF_MANPAGE_DIR			"/usr/local/man"
+#define DEF_MANPAGE_DIR			"__PREFIX/share/man"
 #endif
 
 #define VAR_SAMPLE_DIR			"sample_directory"
@@ -4110,7 +4110,7 @@ extern bool var_smtp_tls_conn_reuse;
   */
 #define VAR_SHLIB_DIR	"shlib_directory"
 #ifndef DEF_SHLIB_DIR
-#define DEF_SHLIB_DIR	"/usr/lib/postfix"
+#define DEF_SHLIB_DIR	"__PREFIX/lib/postfix"
 #endif
 extern char *var_shlib_dir;
 
@@ -4163,7 +4163,7 @@ extern bool var_dns_ncache_ttl_fix;
 extern char *var_maillog_file;
 
 #define VAR_MAILLOG_FILE_PFXS	"maillog_file_prefixes"
-#define DEF_MAILLOG_FILE_PFXS	"/var, /dev/stdout"
+#define DEF_MAILLOG_FILE_PFXS	"__PREFIX/var, /dev/stdout"
 extern char *var_maillog_file_pfxs;
 
 #define VAR_MAILLOG_FILE_COMP	"maillog_file_compressor"
