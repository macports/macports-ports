--- common/updater_list.c.orig	2005-04-19 05:39:17.000000000 -0400
+++ common/updater_list.c	2005-04-19 05:39:23.000000000 -0400
@@ -27,6 +27,8 @@
  * SUCH DAMAGE.
  */
 
+#include <sys/types.h>
+
 #include <stdlib.h>
 
 #include <ctype.h>
