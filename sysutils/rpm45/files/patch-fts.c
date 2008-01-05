--- rpmio/fts.c	2007-05-25 10:36:36.000000000 -0700
+++ rpmio/fts.c	2007-06-13 10:52:54.000000000 -0700
@@ -34,6 +34,7 @@
 static char sccsid[] = "@(#)fts.c	8.6 (Berkeley) 8/14/94";
 #endif /* LIBC_SCCS and not lint */
 
+#include "system.h"
 #if defined(_LIBC)
 #include <sys/param.h>
 #include <include/sys/stat.h>
@@ -70,7 +71,6 @@
 #   define stat64              stat
 #   define __fxstat64(_stat_ver, _fd, _sbp)    fstat((_fd), (_sbp))
 #endif
-#include "system.h"
 #include "fts.h"
 #include "rpmio.h"
 #include "rpmurl.h"
