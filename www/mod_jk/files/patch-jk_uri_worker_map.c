--- common/jk_uri_worker_map.c.orig	2005-01-22 08:56:17.000000000 -0800
+++ common/jk_uri_worker_map.c	2005-01-22 08:56:28.000000000 -0800
@@ -510,7 +510,7 @@
     return (s - str);
 }
 
-static int uri_worker_map_close(jk_uri_worker_map_t *uw_map, jk_logger_t *l)
+int uri_worker_map_close(jk_uri_worker_map_t *uw_map, jk_logger_t *l)
 {
     JK_TRACE_ENTER(l);
 
@@ -526,7 +526,7 @@
     return JK_FALSE;
 }
 
-static void jk_no2slash(char *name)
+void jk_no2slash(char *name)
 {
     char *d, *s;
 
