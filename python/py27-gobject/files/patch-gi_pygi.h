--- gi/pygi.h.orig	2010-11-09 20:22:40.000000000 -0600
+++ gi/pygi.h	2010-11-09 20:23:09.000000000 -0600
@@ -152,7 +152,7 @@
 pygi_get_property_value (PyGObject *instance,
                          const gchar *attr_name)
 {
-    return -1;
+    return NULL;
 }
 
 static inline gint
