--- src/libirc/DCC.cpp.orig	Wed Apr  7 18:24:25 2004
+++ src/libirc/DCC.cpp	Wed Apr  7 18:24:36 2004
@@ -16,12 +16,13 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  */
 
+#include <sys/types.h>
+
 #ifndef WIN32
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #else
-#include <sys/types.h>
 #include <sys/stat.h>
 #define stat _stat
 #endif
