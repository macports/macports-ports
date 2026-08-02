--- jabberd/log.cc.orig	2007-07-20 13:56:59 UTC
+++ jabberd/log.cc
@@ -83,21 +83,22 @@ static char *debug_log_timestamp(void) {
  * @return 1 if it should be logged, 0 if not
  */
 static inline int _debug_log_zonefilter(char const* zone) {
-    char *pos, c = '\0';
+    const char *pos;
+    char *tmp;
+    int ret = 1;
     if(zone != NULL && debug__zones != NULL)
     {
 	pos = strchr(zone,'.');
         if(pos != NULL)
         {
-            c = *pos;
-            *pos = '\0'; /* chop */
+            tmp = strndup(zone, pos - zone);
         }
-        if(xhash_get(debug__zones,zone) == NULL)
-            return 0;
+        if(xhash_get(debug__zones, (pos ? tmp : zone)) == NULL)
+            ret = 0;
         if(pos != NULL)
-            *pos = c; /* restore */
+            free(tmp);
     }
-    return 1;
+    return ret;
 }
 
 /**
