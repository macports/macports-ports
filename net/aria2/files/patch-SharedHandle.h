--- src/SharedHandle.h.bak	2007-02-12 03:51:25.000000000 -0500
+++ src/SharedHandle.h	2007-02-12 03:51:45.000000000 -0500
@@ -76,13 +76,15 @@
   RefCount* ucount;
 
   void releaseReference() {
-    if(--ucount->strongRefCount == 0) {
-      delete obj;
-      obj = 0;
-    }
-    if(--ucount->totalRefCount == 0) {
-      delete ucount;
-      ucount = 0;
+    if(ucount != 0) {
+      if(--ucount->strongRefCount == 0) {
+        delete obj;
+        obj = 0;
+      }
+      if(--ucount->totalRefCount == 0) {
+        delete ucount;
+        ucount = 0;
+      }
     }
   }
 
