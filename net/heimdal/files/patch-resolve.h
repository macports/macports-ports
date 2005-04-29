--- lib/roken/resolve.h.orig	Thu Apr 28 22:17:16 2005
+++ lib/roken/resolve.h	Thu Apr 28 22:17:37 2005
@@ -35,6 +35,7 @@
 
 #ifndef __RESOLVE_H__
 #define __RESOLVE_H__
+#include <arpa/nameser_compat.h>
 
 /* We use these, but they are not always present in <arpa/nameser.h> */
 
