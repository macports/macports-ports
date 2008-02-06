--- ./smart/backends/deb/base.py.orig	2007-10-05 14:53:17.000000000 +0200
+++ ./smart/backends/deb/base.py	2008-01-28 13:26:33.000000000 +0100
@@ -27,6 +27,7 @@ from smart.cache import *
 import fnmatch
 import string
 import os, re
+import sys
 
 __all__ = ["DebPackage", "DebProvides", "DebNameProvides", "DebPreRequires",
            "DebRequires", "DebUpgrades", "DebConflicts", "DebOrRequires",
@@ -54,6 +55,9 @@ def getArchitecture():
         return arch
 
 DEBARCH = sysconf.get("deb-arch", getArchitecture())
+platform = sys.platform
+if platform != "linux2":
+    DEBARCH = "%s-%s" % (platform, DEBARCH)
 
 class DebPackage(Package):
 
