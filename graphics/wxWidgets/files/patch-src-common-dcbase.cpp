--- src/common/dcbase.cpp	Sun Sep 19 17:05:53 2004
+++ dcbase.cpp	Thu Nov 11 12:09:39 2004
@@ -316,6 +316,10 @@
     double           x1, y1, x2, y2;
 
     wxList::compatibility_iterator node = points->GetFirst();
+    if (node == NULL)
+        // empty list
+        return;
+    
     p = (wxPoint *)node->GetData();
 
     x1 = p->x;
