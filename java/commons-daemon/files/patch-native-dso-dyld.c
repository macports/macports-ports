--- src/native/unix/native/dso-dyld.c.orig	2005-01-22 07:15:01.000000000 -0800
+++ src/native/unix/native/dso-dyld.c	2005-01-22 07:17:47.000000000 -0800
@@ -14,12 +14,17 @@
    limitations under the License.
 */
 /* @version $Id: patch-native-dso-dyld.c,v 1.1 2005/01/22 15:31:51 jberry Exp $ */
-#include "jsvc.h"
 
 #ifdef DSO_DYLD
 
 #include <mach-o/dyld.h>
 
+/* dyld.h hauls in stdbool, which jsvc doesn't expect; undo that */
+#undef false
+#undef true
+#undef bool
+#include "jsvc.h"
+
 /* Print an error message and abort all if a specified symbol wasn't found */
 static void nosymbol(const char *s) {
     log_error("Cannot find symbol '%s' in library",s);
@@ -106,7 +111,7 @@
     /* Process the correct name (add a _ before the name) */
     while (nam[x]!='\0') x++;
     und=(char*)malloc(sizeof(char)*(x+2));
-    while(x>=0) und[x+1]=nam[x--];
+    for(; x>=0; --x) und[x+1]=nam[x];
     und[0]='_';
 
     /* Find the symbol */
