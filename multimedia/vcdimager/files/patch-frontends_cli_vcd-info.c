--- frontends/cli/vcd-info.c.orig	Fri Feb  6 20:00:39 2004
+++ frontends/cli/vcd-info.c	Wed Jan  5 20:25:54 2005
@@ -207,14 +207,14 @@
     return PBC_VCD2_NOPE;
 
   img = vcdinfo_get_cd_image(obj);
-  statbuf = iso9660_fs_stat (img, "EXT/LOT_X.VCD;1", true);
+  statbuf = iso9660_fs_stat (img, "EXT/LOT_X.VCD;1");
   if (NULL == statbuf)
     return PBC_VCD2_NO_LOT_X;
   if (statbuf->size != ISO_BLOCKSIZE * LOT_VCD_SIZE) {
     ret_status = PBC_VCD2_BAD_LOT_SIZE;
   } else {
     free(statbuf);
-    statbuf = iso9660_fs_stat (img, "EXT/PSD_X.VCD;1", true);
+    statbuf = iso9660_fs_stat (img, "EXT/PSD_X.VCD;1");
     if (NULL != statbuf) {
       ret_status = PBC_VCD2_EXT;
     } else {
@@ -1184,8 +1184,7 @@
                                  ((vcdinfo_get_VCD_type(obj) == VCD_TYPE_SVCD 
                              || vcdinfo_get_VCD_type(obj) == VCD_TYPE_HQVCD)
                                   ? "/SVCD/PSD.SVD;1" 
-                                  : "/VCD/PSD.VCD;1"),
-                                 true);
+                                  : "/VCD/PSD.VCD;1"));
       if (NULL == statbuf)
         vcd_warn ("no PSD file entry found in ISO9660 fs");
       else {
