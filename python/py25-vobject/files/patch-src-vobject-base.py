Index: src/vobject/base.py
===================================================================
--- src/vobject/base.py	(revision 147)
+++ src/vobject/base.py	(working copy)
@@ -1,5 +1,6 @@
 """vobject module for reading vCard and vCalendar files."""
 
+import copy
 import re
 import sys
 import logging
@@ -56,6 +57,12 @@
         self.parentBehavior = None
         self.isNative = False
     
+    def copy(self, copyit):
+        self.group = copyit.group
+        self.behavior = copyit.behavior
+        self.parentBehavior = copyit.parentBehavior
+        self.isNative = copyit.isNative
+        
     def validate(self, *args, **kwds):
         """Call the behavior's validate method, or return True."""
         if self.behavior:
@@ -250,6 +257,21 @@
         if qp:
             self.value = str(self.value).decode('quoted-printable')
 
+    @classmethod
+    def duplicate(clz, copyit):
+        newcopy = clz('', {}, '')
+        newcopy.copy(copyit)
+        return newcopy
+
+    def copy(self, copyit):
+        super(ContentLine, self).copy(copyit)
+        self.name = copyit.name
+        self.value = copy.copy(copyit.value)
+        self.encoded = self.encoded
+        self.params = copy.copy(copyit.params)
+        self.singletonparams = copy.copy(copyit.singletonparams)
+        self.lineNumber = copyit.lineNumber
+        
     def __eq__(self, other):
         try:
             return (self.name == other.name) and (self.params == other.params) and (self.value == other.value)
@@ -361,6 +383,27 @@
         
         self.autoBehavior()
 
+    @classmethod
+    def duplicate(clz, copyit):
+        newcopy = clz()
+        newcopy.copy(copyit)
+        return newcopy
+
+    def copy(self, copyit):
+        super(Component, self).copy(copyit)
+        
+        # deep copy of contents
+        self.contents = {}
+        for key, lvalue in copyit.contents.items():
+            newvalue = []
+            for value in lvalue:
+                newitem = value.duplicate(value)
+                newvalue.append(newitem)
+            self.contents[key] = newvalue
+
+        self.name = copyit.name
+        self.useBegin = copyit.useBegin
+         
     def setProfile(self, name):
         """Assign a PROFILE to this unnamed component.
         
