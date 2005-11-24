--- fcgid_conf.c.orig	Mon Jul 26 07:08:03 2004
+++ fcgid_conf.c	Fri Aug 13 05:04:44 2004
@@ -15,7 +15,7 @@
 #define DEFAULT_ERROR_SCAN_INTERVAL 3
 #define DEFAULT_ZOMBIE_SCAN_INTERVAL 3
 #define DEFAULT_PROC_LIFETIME (60*60)
-#define DEFAULT_SOCKET_PREFIX "logs/fcgidsock"
+#define DEFAULT_SOCKET_PREFIX "/var/run/fcgidsock"
 #define DEFAULT_SPAWNSOCRE_UPLIMIT 10
 #define DEFAULT_SPAWN_SCORE 1
 #define DEFAULT_TERMINATION_SCORE 2
