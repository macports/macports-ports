--- Lib/SimpleXMLRPCServer.py	Mon Oct  4 01:21:44 2004
+++ Lib/SimpleXMLRPCServer.py	Fri Feb  4 00:50:29 2005
@@ -106,14 +106,22 @@
 import sys
 import os
 
-def resolve_dotted_attribute(obj, attr):
+def resolve_dotted_attribute(obj, attr, allow_dotted_names=True):
     """resolve_dotted_attribute(a, 'b.c.d') => a.b.c.d
 
     Resolves a dotted attribute name to an object.  Raises
     an AttributeError if any attribute in the chain starts with a '_'.
+
+    If the optional allow_dotted_names argument is false, dots are not
+    supported and this function operates similar to getattr(obj, attr).
     """
 
-    for i in attr.split('.'):
+    if allow_dotted_names:
+        attrs = attr.split('.')
+    else:
+        attrs = [attr]
+
+    for i in attrs:
         if i.startswith('_'):
             raise AttributeError(
                 'attempt to access private attribute "%s"' % i
@@ -155,7 +163,7 @@
         self.funcs = {}
         self.instance = None
 
-    def register_instance(self, instance):
+    def register_instance(self, instance, allow_dotted_names=False):
         """Registers an instance to respond to XML-RPC requests.
 
         Only one instance can be installed at a time.
@@ -173,9 +181,23 @@
 
         If a registered function matches a XML-RPC request, then it
         will be called instead of the registered instance.
+
+        If the optional allow_dotted_names argument is true and the
+        instance does not have a _dispatch method, method names
+        containing dots are supported and resolved, as long as none of
+        the name segments start with an '_'.
+
+            *** SECURITY WARNING: ***
+
+            Enabling the allow_dotted_names options allows intruders
+            to access your module's global variables and may allow
+            intruders to execute arbitrary code on your machine.  Only
+            use this option on a secure, closed network.
+
         """
 
         self.instance = instance
+        self.allow_dotted_names = allow_dotted_names
 
     def register_function(self, function, name = None):
         """Registers a function to respond to XML-RPC requests.
@@ -294,7 +316,8 @@
                 try:
                     method = resolve_dotted_attribute(
                                 self.instance,
-                                method_name
+                                method_name,
+                                self.allow_dotted_names
                                 )
                 except AttributeError:
                     pass
@@ -373,7 +396,8 @@
                     try:
                         func = resolve_dotted_attribute(
                             self.instance,
-                            method
+                            method,
+                            self.allow_dotted_names
                             )
                     except AttributeError:
                         pass
