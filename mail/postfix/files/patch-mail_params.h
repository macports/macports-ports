$NetBSD: patch-ae,v 1.5 2002/03/27 13:10:18 martti Exp $

--- src/global/mail_params.h.orig	Mon Mar 25 14:22:11 2002
+++ src/global/mail_params.h	Wed Mar 27 13:59:44 2002
@@ -50,7 +50,7 @@
 extern gid_t var_owner_gid;
 
 #define VAR_SGID_GROUP		"setgid_group"
-#define DEF_SGID_GROUP		"postdrop"
+#define DEF_SGID_GROUP		"maildrop"
 extern char *var_sgid_group;
 extern gid_t var_sgid_gid;
 
@@ -169,18 +169,18 @@
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
 
