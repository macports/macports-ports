--- nessus/preferences.c.orig	2005-11-08 11:47:30.000000000 -0800
+++ nessus/preferences.c	2005-11-08 16:47:35.000000000 -0800
@@ -164,6 +164,8 @@
       }
   fprintf(f,"# Nessus Client Preferences File\n\n");
   fprintf(f, "trusted_ca = %s/cacert.pem\n", NESSUSD_CA);
+  fprintf(f, "# On Mac OS X 10.4, nessus+openssl-0.9.8+gcc4 (at least) needs sslv3 (not tlsv1) : \n");
+  fprintf(f, "ssl_version = sslv3\n");
   fprintf(f, "begin(SCANNER_SET)\n");
   fprintf(f, "10180 = yes\n");
   fprintf(f, "10278 = no\n");
