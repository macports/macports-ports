--- xmalloc.c.orig	Mon Aug  4 22:23:50 2003
+++ xmalloc.c	Wed Dec 29 04:56:49 2004
@@ -44,8 +44,6 @@
 # define _(Text) Text
 #endif
 
-#include "error.h"
-
 #ifndef EXIT_FAILURE
 # define EXIT_FAILURE 1
 #endif
@@ -64,12 +62,6 @@
    The caller may set it to some other value.  */
 int xmalloc_exit_failure = EXIT_FAILURE;
 
-#if __STDC__ && (HAVE_VPRINTF || HAVE_DOPRNT)
-void error (int, int, const char *, ...);
-#else
-void error ();
-#endif
-
 static VOID *
 fixup_null_alloc (n)
      size_t n;
@@ -79,8 +71,6 @@
   p = 0;
   if (n == 0)
     p = malloc ((size_t) 1);
-  if (p == 0)
-    error (xmalloc_exit_failure, 0, _("Memory exhausted"));
   return p;
 }
 
