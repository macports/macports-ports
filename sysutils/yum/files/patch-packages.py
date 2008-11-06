--- yum/packages.py.orig	2008-11-06 11:57:14.000000000 +0100
+++ yum/packages.py	2008-11-06 12:09:20.000000000 +0100
@@ -1121,6 +1121,8 @@ class YumHeaderPackage(YumAvailablePacka
         # - that's what it is
         newflag = flag
         if flag is not None:
+            if not hasattr(rpm, 'RPMSENSE_PREREQ'):
+                return 0
             newflag = flag & rpm.RPMSENSE_PREREQ
             if newflag == rpm.RPMSENSE_PREREQ:
                 return 1
