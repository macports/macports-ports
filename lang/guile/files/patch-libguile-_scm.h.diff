--- libguile/_scm.h~	2007-05-09 16:22:03.000000000 -0400
+++ libguile/_scm.h	2007-12-17 20:06:31.000000000 -0500
@@ -145,17 +145,17 @@
 #endif
 
 /* These names are a bit long, but they make it clear what they represent. */
-#define dirent_or_dirent64              CHOOSE_LARGEFILE(dirent,dirent64)
+#define dirent_or_dirent64              CHOOSE_LARGEFILE(dirent,dirent)
 #define fstat_or_fstat64                CHOOSE_LARGEFILE(fstat,fstat64)
-#define ftruncate_or_ftruncate64        CHOOSE_LARGEFILE(ftruncate,ftruncate64)
-#define lseek_or_lseek64                CHOOSE_LARGEFILE(lseek,lseek64)
+#define ftruncate_or_ftruncate64        CHOOSE_LARGEFILE(ftruncate,ftruncate)
+#define lseek_or_lseek64                CHOOSE_LARGEFILE(lseek,lseek)
 #define lstat_or_lstat64                CHOOSE_LARGEFILE(lstat,lstat64)
-#define off_t_or_off64_t                CHOOSE_LARGEFILE(off_t,off64_t)
-#define open_or_open64                  CHOOSE_LARGEFILE(open,open64)
-#define readdir_or_readdir64            CHOOSE_LARGEFILE(readdir,readdir64)
-#define readdir_r_or_readdir64_r        CHOOSE_LARGEFILE(readdir_r,readdir64_r)
+#define off_t_or_off64_t                CHOOSE_LARGEFILE(off_t,off_t)
+#define open_or_open64                  CHOOSE_LARGEFILE(open,open)
+#define readdir_or_readdir64            CHOOSE_LARGEFILE(readdir,readdir)
+#define readdir_r_or_readdir64_r        CHOOSE_LARGEFILE(readdir_r,readdir_r)
 #define stat_or_stat64                  CHOOSE_LARGEFILE(stat,stat64)
-#define truncate_or_truncate64          CHOOSE_LARGEFILE(truncate,truncate64)
+#define truncate_or_truncate64          CHOOSE_LARGEFILE(truncate,truncate)
 #define scm_from_off_t_or_off64_t       CHOOSE_LARGEFILE(scm_from_off_t,scm_from_int64)
 #define scm_from_ino_t_or_ino64_t       CHOOSE_LARGEFILE(scm_from_ulong,scm_from_uint64)
 #define scm_from_blkcnt_t_or_blkcnt64_t CHOOSE_LARGEFILE(scm_from_ulong,scm_from_uint64)
