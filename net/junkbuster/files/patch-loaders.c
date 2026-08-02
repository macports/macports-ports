diff -urN ../ijb-zlib-11.orig/loaders.c ./loaders.c
--- ../ijb-zlib-11.orig/loaders.c	Mon Jun  3 17:15:47 2002
+++ ./loaders.c	Thu Jan  6 15:11:11 2005
@@ -12,7 +12,11 @@
 #include <stdlib.h>
 #include <sys/types.h>
 #include <string.h>
+#ifdef __APPLE__
+#include <sys/malloc.h>
+#else
 #include <malloc.h>
+#endif
 #include <errno.h>
 #include <sys/stat.h>
 #include <ctype.h>
@@ -22,7 +26,7 @@
 #endif
 
 #ifdef REGEX
-#include <gnu_regex.h>
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
@@ -1163,7 +1167,7 @@
 
 	extern char	*acl_rcs, *bind_rcs, *conn_rcs, *encode_rcs,
 			*jcc_rcs, *loaders_rcs, *parsers_rcs, *filters_rcs,
-			*socks4_rcs, *ssplit_rcs, *gnu_regex_rcs, *win32_rcs;
+			*socks4_rcs, *ssplit_rcs, *win32_rcs;
 
 	b = strsav(b, "<h2>Source versions:</h2>\n");
 	b = strsav(b, "<pre>");
@@ -1177,7 +1181,6 @@
 	sprintf(buf, "%s\n", socks4_rcs    );	b = strsav(b, buf);
 	sprintf(buf, "%s\n", ssplit_rcs    );	b = strsav(b, buf);
 	sprintf(buf, "%s\n", acl_rcs       );	b = strsav(b, buf);
-	sprintf(buf, "%s\n", gnu_regex_rcs );	b = strsav(b, buf);
 	sprintf(buf, "%s\n", win32_rcs     );	b = strsav(b, buf);
 	b = strsav(b, "</pre>");
 
