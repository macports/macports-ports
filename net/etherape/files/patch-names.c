--- src/names.c.org	2006-01-11 13:26:21.000000000 -0800
+++ src/names.c	2006-02-16 22:37:08.000000000 -0800
@@ -17,6 +17,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <stdint.h>
+#include <sys/types.h>
 #include <gnome.h>
 #include <netinet/in.h>
 #include "dns.h"
