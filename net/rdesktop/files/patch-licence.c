--- ../rdesktop.orig/licence.c	Thu Feb 13 14:04:01 2003
+++ licence.c	Thu Feb 13 14:05:14 2003
@@ -113,7 +113,9 @@
 
 	out_uint32_le(s, 1);
 	out_uint16(s, 0);
-	out_uint16_le(s, 0xff01);
+	
+	/* 0xff01 == any Windows TSC, 0x0301 == Windows 2K */
+	out_uint16_le(s, 0x0301);
 
 	out_uint8p(s, client_random, SEC_RANDOM_SIZE);
 	out_uint16(s, 0);
