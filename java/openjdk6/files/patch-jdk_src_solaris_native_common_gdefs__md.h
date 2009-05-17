--- jdk.orig/src/solaris/native/common/gdefs_md.h	2009-04-24 00:34:34.000000000 -0700
+++ jdk/src/solaris/native/common/gdefs_md.h	2009-05-15 01:28:11.000000000 -0700
@@ -24,15 +24,11 @@
  */
 
 /*
- * Solaris dependent type definitions  includes intptr_t, etc
+ * Solaris/Linux dependent type definitions  includes intptr_t, etc
  */
 
+#include <stddef.h>
+#include <stdint.h>  /* For uintptr_t */
+#include <stdlib.h>
 
 #include <sys/types.h>
-/*
- * Linux version of <sys/types.h> does not define intptr_t
- */
-#ifdef __linux__
-#include <stdint.h>
-#include <malloc.h>
-#endif /* __linux__ */
