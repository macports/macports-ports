--- PIL/Image.py.orig	Wed May  7 06:59:10 2003
+++ PIL/Image.py	Wed May  7 07:00:16 2003
@@ -1715,7 +1715,7 @@
         format = "BMP"
         if not command:
             command = "start"
-    elif os.environ.get("OSTYPE") == "darwin":
+    elif sys.platform == "darwin":
         format = "JPEG"
         if not command:
             command = "open -a /Applications/Preview.app"
@@ -1741,7 +1741,7 @@
     if os.name == "nt":
         os.system("%s %s" % (command, file))
         # FIXME: this leaves temporary files around...
-    elif os.environ.get("OSTYPE") == "darwin":
+    elif sys.platform == "darwin":
         # on darwin open returns immediately resulting in the temp
         # file removal while app is opening
         os.system("(%s %s; sleep 20; rm -f %s)&" % (command, file, file))
