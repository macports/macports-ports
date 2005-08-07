--- main.c.orig	2005-06-20 15:29:38.000000000 +0900
+++ main.c	2005-06-20 15:30:16.000000000 +0900
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
@@ -1031,7 +1019,7 @@
 	*dirchk = dirstr;
 	dirchk[1] = NULL;
 	
-	dir = fts_open(dirchk,FTS_PHYSICAL,NULL);
+	dir = fts_open(dirchk,FTS_PHYSICAL|FTS_NOCHDIR,NULL);
 	
 	/* If fts_open failes, report and exit */
 	if (!dir)
