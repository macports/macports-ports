--- ProjectModules/GNUstepAppLauncher/GNUstepAppLauncher.h.orig	2007-03-29 16:33:43.000000000 -0400
+++ ProjectModules/GNUstepAppLauncher/GNUstepAppLauncher.h	2007-03-29 16:34:22.000000000 -0400
@@ -24,6 +24,14 @@
 #import <Foundation/NSObject.h>
 #import "../../ProjectModule.h"
 
+extern FILE *__stdinp;
+extern FILE *__stdoutp;
+extern FILE *__stderrp;
+#define	stdin	__stdinp
+#define	stdout	__stdoutp
+#define	stderr	__stderrp
+
+
 @class NSMutableArray,
        NSMutableDictionary,
        NSTask,
