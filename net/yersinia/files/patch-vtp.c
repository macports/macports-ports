--- src/vtp.c	2024-03-08 17:08:08
+++ src/vtp.c	2024-03-08 17:10:02
@@ -1437,7 +1437,7 @@
     u_int16_t *aux_short;
 #ifdef LBL_ALIGN
     u_int32_t aux_long2;
-    u_int16_t *aux_short2;
+    u_int16_t aux_short2;
 #endif
     vtp = (struct vtp_data *)values;
     ether = (struct libnet_802_3_hdr *) data->packet;
