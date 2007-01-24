--- src/mod_speedycgi2.c.orig	Tue Oct  7 13:03:48 2003
+++ src/mod_speedycgi2.c	Sun Jan 23 20:42:43 2005
@@ -92,9 +92,14 @@
  */
 
 #include "speedy.h"
+#include "apr_version.h"
 
 extern char **environ;
 
+#if APR_MAJOR_VERSION >= 1
+#define	apr_filename_of_pathname	apr_filepath_name_get
+#endif
+
 module AP_MODULE_DECLARE_DATA speedycgi_module;
 static request_rec *global_r;
 #if APR_HAS_THREADS
@@ -340,7 +345,14 @@
     const char *buf;
     apr_size_t len;
     apr_status_t rv;
+#if APR_MAJOR_VERSION < 1
     APR_BRIGADE_FOREACH(e, bb) {
+#else
+    for (e = APR_BRIGADE_FIRST(bb);
+	 e != APR_BRIGADE_SENTINEL(bb);
+	 e = APR_BUCKET_NEXT(e))
+    {
+#endif
         if (APR_BUCKET_IS_EOS(e)) {
             break;
         }
@@ -465,7 +477,14 @@
             return rv;
         }
 
-        APR_BRIGADE_FOREACH(bucket, bb) {
+#if APR_MAJOR_VERSION < 1
+	APR_BRIGADE_FOREACH(bucket, bb) {
+#else
+	for (bucket = APR_BRIGADE_FIRST(bb);
+	     bucket != APR_BRIGADE_SENTINEL(bb);
+	     bucket = APR_BUCKET_NEXT(bucket))
+	{
+#endif
             const char *data;
             apr_size_t len;
 
