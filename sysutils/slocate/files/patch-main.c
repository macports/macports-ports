--- main.c	Sun Dec  7 02:14:30 2003
+++ main.c	Sun Dec  7 02:20:06 2003
@@ -125,23 +125,11 @@
 char **SLOCATE_PATH = NULL;
 
 /* More fitting paths for FreeBSD -matt */
-#if defined(__FreeBSD__)
-char *SLOCATEDB = "/var/db/slocate/slocate.db";
-char *TMPSLOCATEDB = "/var/db/slocate/slocate.db.tmp";
-char *SLOCATEDB_DIR = "/var/db/slocate/";
-#elif defined(__SunOS__)
-char *SLOCATEDB = "/var/db/slocate/slocate.db";
-char *TMPSLOCATEDB = "/var/db/slocate/slocate.db.tmp";
-char *SLOCATEDB_DIR = "/var/db/slocate/";
-#undef MTAB_FILE
-#define MTAB_FILE "/etc/mnttab"
-#else
-char *SLOCATEDB = "/var/lib/slocate/slocate.db";
-char *TMPSLOCATEDB = "/var/lib/slocate/slocate.db.tmp";
-char *SLOCATEDB_DIR = "/var/lib/slocate/";
-#endif
+char *SLOCATEDB = "__PREFIX__/var/db/slocate/slocate.db";
+char *TMPSLOCATEDB = "__PREFIX__/var/db/slocate/slocate.db.tmp";
+char *SLOCATEDB_DIR = "__PREFIX__/var/db/slocate/";
 
-# define UPDATEDB_CONF "/etc/updatedb.conf"
+# define UPDATEDB_CONF "__PREFIX__/etc/updatedb.conf"
 char *EXCLUDE_DIR=NULL;
 int EXCLUDE=0;
 int VERBOSE=0;
