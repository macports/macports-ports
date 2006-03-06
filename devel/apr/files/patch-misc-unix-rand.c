--- misc/unix/rand.c.dist	2005-05-05 10:44:04.000000000 -0400
+++ misc/unix/rand.c	2006-03-06 10:00:30.000000000 -0500
@@ -35,24 +35,31 @@
 #if APR_HAVE_SYS_UN_H
 #include <sys/un.h>
 #endif
-#ifdef HAVE_UUID_UUID_H
-#include <uuid/uuid.h>
-#endif
-#ifdef HAVE_UUID_H
+#if defined(HAVE_UUID_H)
 #include <uuid.h>
+#elif defined(HAVE_SYS_UUID_H)
+#include <sys/uuid.h>
+#elif defined(HAVE_UUID_UUID_H)
+#include <uuid/uuid.h>
 #endif
 
 #ifndef SHUT_RDWR
 #define SHUT_RDWR 2
 #endif
 
+#if APR_HAS_OS_UUID
+
 #if defined(HAVE_UUID_CREATE)
 
 APR_DECLARE(apr_status_t) apr_os_uuid_get(unsigned char *uuid_data)
 {
+    uint32_t rv;
     uuid_t g;
 
-    uuid_create(&g, NULL);
+    uuid_create(&g, &rv);
+
+    if (rv != uuid_s_ok)
+        return APR_EGENERAL;
 
     memcpy(uuid_data, &g, sizeof(uuid_t));
 
@@ -73,6 +80,8 @@
 }
 #endif 
 
+#endif /* APR_HAS_OS_UUID */
+
 #if APR_HAS_RANDOM
 
 APR_DECLARE(apr_status_t) apr_generate_random_bytes(unsigned char *buf, 
