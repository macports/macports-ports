--- src/toextract.h.orig	2018-07-19 16:05:27.000000000 +0700
+++ src/toextract.h	2018-07-19 16:05:18.000000000 +0700
@@ -782,13 +782,13 @@
         }
         /** Implement sort order based only on Order field.
          */
-        bool operator <(const columnInfo &inf)
+        bool operator <(const columnInfo &inf) const
         {
             return Order < inf.Order;
         }
         /** Implement sort order based only on Order field.
          */
-        bool operator ==(const columnInfo &inf)
+        bool operator ==(const columnInfo &inf) const
         {
             return Order == inf.Order;
         }
