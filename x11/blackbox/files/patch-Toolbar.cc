--- src/Toolbar.cc.org	Wed Jun 22 02:03:40 2005
+++ src/Toolbar.cc	Wed Jun 22 02:04:02 2005
@@ -43,7 +43,7 @@
 long nextTimeout(int resolution) {
   timeval now;
   gettimeofday(&now, 0);
-  return (std::max(1000l, ((resolution - (now.tv_sec % resolution)) * 1000))
+  return (std::max(1000, ((resolution - (now.tv_sec % resolution)) * 1000))
           - (now.tv_usec / 1000));
 }
 
