--- PortalTransforms/transforms/office_uno.py.orig	Mon Mar 15 15:01:49 2004
+++ PortalTransforms/transforms/office_uno.py	Mon Mar 15 15:06:05 2004
@@ -7,11 +7,11 @@
     def __init__(self, name, data):
         """Initialization: create tmp work directory and copy the
         document into a file"""
-            commandtransform.__init__(self, name)
-            name = self.name()
-            if not name.endswith('.doc'):
-                name = name + ".doc"
-            self.tmpdir, self.fullname = self.initialize_tmpdir(data, filename=name)
+        commandtransform.__init__(self, name)
+        name = self.name()
+        if not name.endswith('.doc'):
+            name = name + ".doc"
+        self.tmpdir, self.fullname = self.initialize_tmpdir(data, filename=name)
 
     def convert(self):
         "Convert the document"
