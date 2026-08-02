--- sources/main.h.orig	2005-06-01 05:36:18.000000000 -0500
+++ sources/main.h	2012-03-03 20:03:48.000000000 -0600
@@ -37,18 +37,18 @@
 #define MIME_TYPE_DEFAULT   "application/octet-stream"
 
 /* configuration file location */
-#define DEFAULT_CONFIG_LOCATION "/usr/local/etc/pserv/"
+#define DEFAULT_CONFIG_LOCATION "@PREFIX@/etc/pserv/"
 
 /* hard-wired defaults, if loading of config file fails */
 #define DEFAULT_PORT	    	2000
 #define DEFAULT_MAX_CHILDREN	5
-#define DEFAULT_DOCS_LOCATION	"/usr/local/var/www"
+#define DEFAULT_DOCS_LOCATION	"@PREFIX@/var/www"
 #define DEFAULT_FILE_NAME   	"index.html"
 #define DEFAULT_SEC_TO	    	1
 #define DEFAULT_USEC_TO     	100
-#define DEFAULT_LOG_FILE    	"/usr/local/var/log/pserv.log"
-#define DEFAULT_MIME_FILE   	"/usr/local/etc/pserv/mime_types.dat"
-#define DEFAULT_CGI_ROOT    	"/usr/local/var/www/cgi-bin"
+#define DEFAULT_LOG_FILE    	"@PREFIX@/var/log/pserv/pserv.log"
+#define DEFAULT_MIME_FILE   	"@PREFIX@/etc/pserv/mime_types.dat"
+#define DEFAULT_CGI_ROOT    	"@PREFIX@/var/www/cgi-bin"
 #define DEFAULT_SERVER_NAME 	"localhost"
 
 /* amount of connections queued in listening */
