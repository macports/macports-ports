--- mysys/base64.c	2007-05-08 12:40:54.000000000 +0300
+++ mysys/base64.c	2007-05-25 09:59:33.000000000 +0300
@@ -16,7 +16,7 @@
 #include <my_global.h>
 #include <m_string.h>  /* strchr() */
 #include <m_ctype.h>  /* my_isspace() */
-#include <base64.h>
+#include "include/base64.h"
 
 #ifndef MAIN
 
