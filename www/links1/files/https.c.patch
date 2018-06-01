--- https.c.orig	2006-09-11 02:09:24 UTC
+++ https.c
@@ -33,7 +33,10 @@ SSL *getSSL(void)
 		char f_randfile[PATH_MAX];
 
 		const char *f = RAND_file_name(f_randfile, sizeof(f_randfile));
-		if (f && RAND_egd(f)<0) {
+#ifndef OPENSSL_NO_EGD
+		if (f && RAND_egd(f)<0) 
+#endif
+		{
 			/* Not an EGD, so read and write to it */
 			if (RAND_load_file(f_randfile, -1))
 				RAND_write_file(f_randfile);
