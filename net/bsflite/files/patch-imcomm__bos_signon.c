--- imcomm/bos_signon.c.orig	2005-04-13 11:03:56.000000000 -0400
+++ imcomm/bos_signon.c	2005-06-06 06:18:26.000000000 -0400
@@ -478,6 +478,8 @@
 		md5_append(&state, (const md5_byte_t *) AIM_MD5_STRING, strlen(AIM_MD5_STRING));
 		md5_finish(&state, auth_hash);
 
+		free(authkey);
+
 		packet = pkt_init(67 + strlen(CLIENT_IDENT) + 16 + strlen(((IMCOMM *) handle)->sn));
 
 		/*
@@ -573,6 +575,8 @@
 			}
 		}
 
+		clear_tlv_list(tlv);
+
 		if (status == 2) {
 			if (((IMCOMM *) handle)->callbacks[IMCOMM_ERROR])
 				((IMCOMM *) handle)->callbacks[IMCOMM_ERROR] (handle, IMCOMM_STATUS_AUTHDONE);
