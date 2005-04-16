--- svector.h.orig	2005-04-16 16:10:16.000000000 -0400
+++ svector.h	2005-04-16 16:12:20.000000000 -0400
@@ -101,7 +101,7 @@
  * Override the implementation of the above template for the string
  * type parameter. The initialization to nil works different here.
  */
-inline svector<string>::svector<string>(unsigned size)
+template <> inline svector<string>::svector(unsigned size)
 : nitems_(size), items_(new string[size])
 {
 }
