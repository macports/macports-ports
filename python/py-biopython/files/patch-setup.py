--- setup.py	2007-10-27 09:11:01.000000000 +0200
+++ setup.py	2007-10-28 23:41:55.000000000 +0100
@@ -120,7 +120,7 @@
 
 Would you like to build Bio.KDTree ?"""
 
-    if get_yes_or_no (kdtree_msg, 0):
+    if True:
         NUMPY_PACKAGES.append("Bio.KDTree")
         NUMPY_EXTENSIONS.append(
             CplusplusExtension('Bio.KDTree._CKDTree', 
