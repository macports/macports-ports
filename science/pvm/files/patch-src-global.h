--- src/global.h	2001-02-08 00:14:03.000000000 +0100
+++ src/global.h	2006-08-18 10:29:21.000000000 +0200
@@ -156,6 +156,8 @@
  *
  */
 
+#include "pvmtev.h"
+ 
 
 /* UDPMAXLEN should be set to the largest UDP message length
    your system can handle. */
@@ -318,6 +320,9 @@
 
 /* General Trace Globals Declarations */
 
+struct Pvmtevdid;
+struct Pvmtevinfo;
+
 extern	struct Pvmtevdid pvmtevdidlist[];
 
 extern	struct Pvmtevinfo pvmtevinfo[];
