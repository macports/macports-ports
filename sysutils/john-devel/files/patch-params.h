--- params.h.orig	2008-07-13 15:38:46.000000000 -0600
+++ params.h	2008-12-07 15:13:46.000000000 -0700
@@ -49,15 +49,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"@@PREFIX@@/share/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"@@PREFIX@@/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif
