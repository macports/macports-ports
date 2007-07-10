--- translate.py.orig	2003-10-09 00:48:48.000000000 +0200
+++ translate.py	2007-06-20 16:24:00.000000000 +0200
@@ -246,6 +246,11 @@
     if (len (arch) == 4 and arch[0] == 'i' and arch[2:4] == "86"):
         arch = "i386"
 
+    if arch == "Power Macintosh":
+        arch = "ppc"
+    if arch == "powerpc":
+        arch = "ppc"
+
     if arch == "sparc64":
         arch = "sparc"
 
