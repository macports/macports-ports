--- include/uriparser/UriBase.h.bak	2007-03-26 22:10:23.000000000 +0200
+++ include/uriparser/UriBase.h	2007-03-26 22:10:39.000000000 +0200
@@ -116,7 +116,7 @@
 # include <stdio.h> /* For NULL */
 # include <ctype.h> /* For wchar_t */
 # include <string.h> /* For strlen, memset, memcpy */
-# include <malloc.h> /* For malloc */
+# include <malloc/malloc.h> /* For malloc */
 #endif /* URI_DOXYGEN */
 
 
