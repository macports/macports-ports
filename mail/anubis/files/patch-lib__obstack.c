--- lib/obstack.c.orig	Tue Jan  4 19:24:07 2005
+++ lib/obstack.c	Tue Jan  4 19:24:27 2005
@@ -103,12 +103,7 @@
 
 /* Exit value used when `print_and_abort' is used.  */
 # include <stdlib.h>
-# ifdef _LIBC
 int obstack_exit_failure = EXIT_FAILURE;
-# else
-#  include "exitfail.h"
-#  define obstack_exit_failure exit_failure
-# endif
 
 # ifdef _LIBC
 #  if SHLIB_COMPAT (libc, GLIBC_2_0, GLIBC_2_3_4)
