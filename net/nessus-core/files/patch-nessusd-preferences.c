--- nessusd/preferences.c.orig	2005-11-08 11:44:20.000000000 -0800
+++ nessusd/preferences.c	2005-11-08 11:47:15.000000000 -0800
@@ -64,6 +64,8 @@
   
  fprintf(fd, "# Configuration file of the Nessus Security Scanner\n\n\n\n");
  fprintf(fd, "# Every line starting with a '#' is a comment\n\n");
+ fprintf(fd, "# On Mac OS X 10.4, nessus+openssl-0.9.8+gcc4 (at least) needs sslv3 (not tlsv1) : \n");
+ fprintf(fd, "ssl_version = sslv3\n\n");
  fprintf(fd, "# Path to the security checks folder : \n");
  fprintf(fd, "plugins_folder = %s\n\n", NESSUSD_PLUGINS);
  fprintf(fd, "# Maximum number of simultaneous hosts tested : \n");
