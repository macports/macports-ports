--- builder.py	Mon Jul 20 20:40:15 2009 +0200
+++ new/builder.py	Wed Jul 29 13:44:09 2009 +0200
@@ -173,13 +173,13 @@
                 if member.func_code.co_filename != getattr(self._module, '__file__', None):
                     attach_dummy_node(node, name, member)
                     continue
-                object_build_function(node, member)
+                object_build_function(node, member, name)
             elif isbuiltin(member):
                 # verify this is not an imported member
                 if self._member_module(member) != self._module.__name__:
                     imported_member(node, member, name)
                     continue
-                object_build_methoddescriptor(node, member)
+                object_build_methoddescriptor(node, member, name)
             elif isclass(member):
                 # verify this is not an imported class
                 if self._member_module(member) != self._module.__name__:
@@ -190,12 +190,12 @@
                     if not class_node in node.locals.get(name, ()):
                         node.add_local_node(class_node, name)
                 else:
-                    class_node = object_build_class(node, member)
+                    class_node = object_build_class(node, member, name)
                     # recursion
                     self.object_build(class_node, member)
             elif ismethoddescriptor(member):
                 assert isinstance(member, object)
-                object_build_methoddescriptor(node, member)
+                object_build_methoddescriptor(node, member, name)
             elif isdatadescriptor(member):
                 assert isinstance(member, object)
                 object_build_datadescriptor(node, member, name)
