--- ../rdesktop.orig/licence.c	Thu Oct 30 14:07:37 2003
+++ licence.c	Thu Oct 30 14:08:04 2003
@@ -118,7 +118,9 @@
 
 	out_uint32_le(s, 1);
 	out_uint16(s, 0);
-	out_uint16_le(s, 0xff01);
+
+	/* 0xff01 == any Windows TSC, 0x0301 == Windows 2K */
+	out_uint16_le(s, 0x0301);
 
 	out_uint8p(s, client_random, SEC_RANDOM_SIZE);
 	out_uint16(s, 0);
