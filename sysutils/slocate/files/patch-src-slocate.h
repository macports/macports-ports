--- src/slocate.h.orig	2006-07-25 23:54:44.000000000 +0900
+++ src/slocate.h	2006-07-25 23:55:28.000000000 +0900
@@ -32,20 +32,12 @@
 /* Printable version of WARN_SECONDS.  */
 #define WARN_MESSAGE "8 days"
 
-#define MTAB_FILE "/etc/mtab"
-#define UPDATEDB_FILE "/etc/updatedb.conf"
+#define MTAB_FILE "__PREFIX__/etc/mtab"
+#define UPDATEDB_FILE "__PREFIX__/etc/updatedb.conf"
 
 /* More fitting paths for FreeBSD -matt */
-#if defined(__FreeBSD__)
-# define DEFAULT_DB "/var/db/slocate/slocate.db"
-# define DEFAULT_DB_DIR "/var/db/slocate/"
-#elif defined(__SunOS__)
-# define DEFAULT_DB "/var/db/slocate/slocate.db"
-# define DEFAULT_DB_DIR "/var/db/slocate/"
-#else
-# define DEFAULT_DB "/var/lib/slocate/slocate.db"
-# define DEFAULT_DB_DIR "/var/lib/slocate/"
-#endif
+# define DEFAULT_DB "__PREFIX__/var/db/slocate/slocate.db"
+# define DEFAULT_DB_DIR "__PREFIX__/var/db/slocate/"
 
 #define DB_UID 0
 #define DB_GROUP "slocate"
