--- tests/ferret.c.org	Sat Jul 26 14:45:37 2003
+++ tests/ferret.c	Sat Jul 26 14:46:04 2003
@@ -3,9 +3,9 @@
 #define MAX_GROUPS 20
 #define MAX_NAME_VALUE 20
 
-#include <netinet/in.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <netinet/in.h>
 #include <sys/un.h>
 #include <errno.h>
 #include <unistd.h>
@@ -239,8 +239,8 @@
 static GtkWidget *menuitem_trackmouse = NULL;
 static GtkWidget *menuitem_trackfocus = NULL;
 
-static struct sockaddr_un mag_server = { AF_UNIX , "/tmp/magnifier_socket" };
-static struct sockaddr_un client = { AF_UNIX, "/tmp/mag_client"};
+static struct sockaddr_un mag_server = { 0, AF_UNIX , "/tmp/magnifier_socket" };
+static struct sockaddr_un client = { 0, AF_UNIX, "/tmp/mag_client"};
 
 /* GUI Information for the output window */
 typedef struct
