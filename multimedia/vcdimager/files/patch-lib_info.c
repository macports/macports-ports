--- lib/info.c.orig	Sun Feb  8 10:57:11 2004
+++ lib/info.c	Wed Jan  5 20:17:59 2005
@@ -1806,7 +1806,7 @@
   }
 
   if (obj->vcd_type == VCD_TYPE_SVCD || obj->vcd_type == VCD_TYPE_HQVCD) {
-    statbuf = iso9660_fs_stat (obj->img, "MPEGAV", true);
+    statbuf = iso9660_fs_stat (obj->img, "MPEGAV");
     
     if (NULL != statbuf) {
       vcd_warn ("non compliant /MPEGAV folder detected!");
@@ -1814,7 +1814,7 @@
     }
     
 
-    statbuf = iso9660_fs_stat (obj->img, "SVCD/TRACKS.SVD;1", true);
+    statbuf = iso9660_fs_stat (obj->img, "SVCD/TRACKS.SVD;1");
     if (NULL != statbuf) {
       lsn_t lsn = statbuf->lsn;
       if (statbuf->size != ISO_BLOCKSIZE)
@@ -1836,7 +1836,7 @@
        iso9660_fs_readdir(img, "EXT", true) and then scanning for
        the files listed below.
     */
-    statbuf = iso9660_fs_stat (img, "EXT/PSD_X.VCD;1", true);
+    statbuf = iso9660_fs_stat (img, "EXT/PSD_X.VCD;1");
     if (NULL != statbuf) {
       lsn_t lsn        = statbuf->lsn;
       uint32_t secsize = statbuf->secsize;
@@ -1852,7 +1852,7 @@
         return VCDINFO_OPEN_ERROR;
     }
 
-    statbuf = iso9660_fs_stat (img, "EXT/LOT_X.VCD;1", true);
+    statbuf = iso9660_fs_stat (img, "EXT/LOT_X.VCD;1");
     if (NULL != statbuf) {
       lsn_t lsn        = statbuf->lsn;
       uint32_t secsize = statbuf->secsize;
@@ -1877,13 +1877,13 @@
        iso9660_fs_readdir(img, "SVCD", true) and then scanning for
        the files listed below.
     */
-    statbuf = iso9660_fs_stat (img, "MPEGAV", true);
+    statbuf = iso9660_fs_stat (img, "MPEGAV");
     if (NULL != statbuf) {
       vcd_warn ("non compliant /MPEGAV folder detected!");
       free(statbuf);
     }
     
-    statbuf = iso9660_fs_stat (img, "SVCD/TRACKS.SVD;1", true);
+    statbuf = iso9660_fs_stat (img, "SVCD/TRACKS.SVD;1");
     if (NULL == statbuf)
       vcd_warn ("mandatory /SVCD/TRACKS.SVD not found!");
     else {
@@ -1892,7 +1892,7 @@
       free(statbuf);
     }
     
-    statbuf = iso9660_fs_stat (img, "SVCD/SEARCH.DAT;1", true);
+    statbuf = iso9660_fs_stat (img, "SVCD/SEARCH.DAT;1");
     if (NULL == statbuf)
       vcd_warn ("mandatory /SVCD/SEARCH.DAT not found!");
     else {
@@ -1931,7 +1931,7 @@
     ;
   }
 
-  statbuf = iso9660_fs_stat (img, "EXT/SCANDATA.DAT;1", true);
+  statbuf = iso9660_fs_stat (img, "EXT/SCANDATA.DAT;1");
   if (statbuf != NULL) {
     lsn_t    lsn       = statbuf->lsn;
     uint32_t secsize   = statbuf->secsize;
