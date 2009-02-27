--- _mysql.c.orig	2007-02-27 18:35:56.000000000 -0800
+++ _mysql.c	2007-11-25 21:54:09.000000000 -0800
@@ -34,9 +34,6 @@
 #else
 #include "my_config.h"
 #endif
-#ifndef uint
-#define uint unsigned int
-#endif
 #include "mysql.h"
 #include "mysqld_error.h"
 #include "errmsg.h"
@@ -481,8 +478,8 @@
 #endif
 	char *host = NULL, *user = NULL, *passwd = NULL,
 		*db = NULL, *unix_socket = NULL;
-	uint port = MYSQL_PORT;
-	uint client_flag = 0;
+	unsigned int port = MYSQL_PORT;
+	unsigned int client_flag = 0;
 	static char *kwlist[] = { "host", "user", "passwd", "db", "port",
 				  "unix_socket", "conv",
 				  "connect_timeout", "compress",
