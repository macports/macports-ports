--- setup.py.org	2006-08-28 13:44:44.000000000 -0700
+++ setup.py	2006-08-28 13:44:58.000000000 -0700
@@ -22,7 +22,7 @@
 
 def mysql_config(what):
     from os import popen
-    f = popen("mysql_config --%s" % what)
+    f = popen("mysql_config5 --%s" % what)
     data = f.read().strip().split()
     if f.close(): data = []
     return data
