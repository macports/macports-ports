--- include/atalk/paths.h	Sat Oct  5 15:07:18 2002
+++ include/atalk/paths.h.new	Thu Oct 28 16:57:53 2004
@@ -15,21 +15,7 @@
 
 
 /* lock file path. this should be re-organized a bit. */
-#if ! defined (_PATH_LOCKDIR)
-#  if defined (FHS_COMPATIBILITY)
-#    define _PATH_LOCKDIR	"/var/run/"
-#  elif defined (BSD4_4)
-#    ifdef MACOSX_SERVER
-#      define _PATH_LOCKDIR	"/var/run/"
-#    else
-#      define _PATH_LOCKDIR	"/var/spool/lock/"
-#    endif
-#  elif defined (linux)
-#    define _PATH_LOCKDIR	"/var/lock/"
-#  else
-#    define _PATH_LOCKDIR	"/var/spool/locks/"
-#  endif
-#endif
+#define _PATH_LOCKDIR	"__PREFIX__/var/run/netatalk/"
 
 /*
  * papd paths
@@ -49,7 +35,7 @@
 /*
  * atalkd paths
  */
-#define _PATH_ATALKDEBUG	"/tmp/atalkd.debug"
+#define _PATH_ATALKDEBUG	"/private/tmp/atalkd.debug"
 #define _PATH_ATALKDTMP		"atalkd.tmp"
 #ifdef FHS_COMPATIBILITY
 #  define _PATH_ATALKDLOCK	ATALKPATHCAT(_PATH_LOCKDIR,"atalkd.pid")
