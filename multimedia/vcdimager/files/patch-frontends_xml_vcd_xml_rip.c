--- frontends/xml/vcd_xml_rip.c.orig	Sun Nov 16 12:32:01 2003
+++ frontends/xml/vcd_xml_rip.c	Wed Jan  5 20:27:37 2005
@@ -781,7 +781,7 @@
 
   if (obj->vcd_type == VCD_TYPE_VCD2)
     {
-      statbuf = iso9660_fs_stat (img, "EXT/LOT_X.VCD;1", true);
+      statbuf = iso9660_fs_stat (img, "EXT/LOT_X.VCD;1");
       if (statbuf != NULL) {
 	extended = true;
 	_lot_vcd_sector = statbuf->lsn;
@@ -790,7 +790,7 @@
 
       free(statbuf);
       if (extended &&
-	  NULL != (statbuf = iso9660_fs_stat (img, "EXT/PSD_X.VCD;1", true))) {
+	  NULL != (statbuf = iso9660_fs_stat (img, "EXT/PSD_X.VCD;1"))) {
 	_psd_vcd_sector = statbuf->lsn;
 	_psd_size = statbuf->size;
 	free(statbuf);
