--- src/server.c	Thu Dec 11 16:56:57 2003
+++ src/server.c	Thu Dec 11 17:01:52 2003
@@ -36,12 +36,14 @@
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
+
 #ifdef _WIN32
 #include <io.h>
 #else
-/* Check this
-#include <sys/io.h>
-*/
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
 #endif	/* _WIN32 */
 #include <fcntl.h>
 #include "abyss.h"
@@ -803,9 +805,18 @@
 	if (strlen(s->requestline)>1024-26-50)
 		s->requestline[1024-26-50]='\0';
 
+#ifdef _WIN32
 	n=sprintf(z,"%d.%d.%d.%d - %s - [",s->conn->peerip.S_un.S_un_b.s_b1,
 		s->conn->peerip.S_un.S_un_b.s_b2,s->conn->peerip.S_un.S_un_b.s_b3,
 		s->conn->peerip.S_un.S_un_b.s_b4,(s->user?s->user:""));
+#else
+	{
+		char theIPString[256];
+		(void) inet_ntop( AF_INET, &s->conn->peerip, theIPString, 256 );
+
+		n=sprintf(z,"%s - %s - [",theIPString,(s->user?s->user:""));
+	}
+#endif
 
 	DateToLogString(&s->date,z+n);
 
