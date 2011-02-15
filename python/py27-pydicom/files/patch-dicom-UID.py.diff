--- dicom/UID.py.orig	2011-01-27 12:24:59.000000000 -0600
+++ dicom/UID.py	2011-01-27 12:25:37.000000000 -0600
@@ -77,9 +77,9 @@
         
     def __eq__(self, other):
         """Override string equality so either name or UID number match passes"""
-        if str.__eq__(self, other):
+        if str.__eq__(self, other) is True: # 'is True' needed (issue 96)
             return True
-        if str.__eq__(self.name, other):
+        if str.__eq__(self.name, other) is True: # 'is True' needed (issue 96)
             return True
         return False
 
