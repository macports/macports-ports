--- lib/ssluse.c.orig	2005-02-09 23:45:08.000000000 -0800
+++ lib/ssluse.c	2005-03-09 05:59:08.000000000 -0800
@@ -18,7 +18,7 @@
  * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
  * KIND, either express or implied.
  *
- * $Id: ssluse.c,v 1.129 2005/02/10 07:45:08 bagder Exp $
+ * $Id: ssluse.c,v 1.131 2005/03/04 22:36:56 danf Exp $
  ***************************************************************************/
 
 /*
@@ -103,6 +103,13 @@
 #define HAVE_ERR_ERROR_STRING_N 1
 #endif
 
+/*
+ * Number of bytes to read from the random number seed file. This must be
+ * a finite value (because some entropy "files" like /dev/urandom have
+ * an infinite length), but must be large enough to provide enough
+ * entopy to properly seed OpenSSL's PRNG.
+ */
+#define RAND_LOAD_LENGTH 1024
 
 #ifndef HAVE_USERDATA_IN_PWD_CALLBACK
 static char global_passwd[64];
@@ -169,7 +176,7 @@
     /* let the option override the define */
     nread += RAND_load_file((data->set.ssl.random_file?
                              data->set.ssl.random_file:RANDOM_FILE),
-                            -1); /* -1 to read the entire file */
+                            RAND_LOAD_LENGTH);
     if(seed_enough(nread))
       return nread;
   }
@@ -231,7 +238,7 @@
   RAND_file_name(buf, BUFSIZE);
   if(buf[0]) {
     /* we got a file name to try */
-    nread += RAND_load_file(buf, -1);
+    nread += RAND_load_file(buf, RAND_LOAD_LENGTH);
     if(seed_enough(nread))
       return nread;
   }
