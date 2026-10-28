--- ppp/ppp_msoft.c.orig	2005-01-21 22:02:07.000000000 +0100
+++ ppp/ppp_msoft.c	2015-01-24 13:42:43.120485776 +0100
@@ -163,14 +163,14 @@
 static void
 ppp_msoft_des_encrypt(const u_char *clear, u_char *key0, u_char *cypher)
 {
-	des_key_schedule ks;
+	DES_key_schedule ks;
 	u_char key[8];
 
 	/*
 	 * Create DES key
 	 *
 	 * Note: we don't bother setting the parity bit because
-	 * the des_set_key() algorithm does that for us. A different
+	 * the DES_set_key() algorithm does that for us. A different
 	 * algorithm may care though.
 	 */
 	key[0] = key0[0] & 0xfe;
@@ -181,10 +181,10 @@
 	key[5] = (key0[4] << 3) | (key0[5] >> 5);
 	key[6] = (key0[5] << 2) | (key0[6] >> 6);
 	key[7] = key0[6] << 1;
-	des_set_key((des_cblock *)key, ks);
+	DES_set_key((DES_cblock *)key, &ks);
 
 	/* Encrypt using key */
-	des_ecb_encrypt((des_cblock *)clear, (des_cblock *)cypher, ks, 1);
+	DES_ecb_encrypt((DES_cblock *)clear, (DES_cblock *)cypher, &ks, 1);
 }
 
 /*
