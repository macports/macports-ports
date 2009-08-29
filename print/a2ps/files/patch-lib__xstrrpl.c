--- lib/xstrrpl.c.orig	2009-08-28 17:22:42.000000000 -0700
+++ lib/xstrrpl.c	2009-08-28 17:22:45.000000000 -0700
@@ -22,8 +22,6 @@
 #include <assert.h>
 #include "xstrrpl.h"
 
-extern char * stpcpy();
-
 /* Perform subsitutions in string.  Result is malloc'd
    E.g., result = xstrrrpl ("1234", subst) gives result = "112333"
    where subst = { {"1", "11"}, {"3", "333"}, { "4", ""}}
