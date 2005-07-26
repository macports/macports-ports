--- libexif/exif-utils.c.orig	2005-07-26 12:53:46.000000000 -0700
+++ libexif/exif-utils.c	2005-07-26 12:54:02.000000000 -0700
@@ -83,7 +83,7 @@
 	}
 }
 
-static ExifSShort
+ExifSShort
 exif_get_sshort (const unsigned char *buf, ExifByteOrder order)
 {
 	if (!buf) return 0;
