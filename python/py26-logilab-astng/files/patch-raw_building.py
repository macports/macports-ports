--- raw_building.py	2009-07-30 09:01:45.000000000 +1200
+++ new/raw_building.py	2009-07-30 09:08:14.000000000 +1200
@@ -124,30 +124,31 @@
             register_arguments(func, arg.elts)
 
 
-def object_build_class(node, member):
+def object_build_class(node, member, localname):
     """create astng for a living class object"""
     basenames = [base.__name__ for base in member.__bases__]
-    return _base_class_object_build(node, member, basenames)
+    return _base_class_object_build(node, member, basenames,
+                                    localname=localname)
 
-def object_build_function(node, member):
+def object_build_function(node, member, localname):
     """create astng for a living function object"""
     args, varargs, varkw, defaults = getargspec(member)
     if varargs is not None:
         args.append(varargs)
     if varkw is not None:
         args.append(varkw)
-    func = build_function(member.__name__, args, defaults,
+    func = build_function(getattr(member, '__name__', None) or localname, args, defaults,
                           member.func_code.co_flags, member.__doc__)
-    node.add_local_node(func)
+    node.add_local_node(func, localname)
 
 def object_build_datadescriptor(node, member, name):
     """create astng for a living data descriptor object"""
     return _base_class_object_build(node, member, [], name)
 
-def object_build_methoddescriptor(node, member):
+def object_build_methoddescriptor(node, member, localname):
     """create astng for a living method descriptor object"""
     # FIXME get arguments ?
-    func = build_function(member.__name__, doc=member.__doc__)
+    func = build_function(getattr(member, '__name__', None) or localname, doc=member.__doc__)
     # set node's arguments to None to notice that we have no information, not
     # and empty argument list
     func.args = nodes.Arguments()
@@ -156,15 +157,16 @@
     func.args.defaults = None
     func.args.vararg = None
     func.args.kwarg = None
-    node.add_local_node(func)
+    node.add_local_node(func, localname)
 
-def _base_class_object_build(node, member, basenames, name=None):
+def _base_class_object_build(node, member, basenames, name=None, localname=None):
     """create astng for a living class object, with a given set of base names
     (e.g. ancestors)
     """
-    klass = build_class(name or member.__name__, basenames, member.__doc__)
+    klass = build_class(getattr(member, '__name__', None) or member.__name__ or localname, 
+                        basenames, member.__doc__)
     klass._newstyle = isinstance(member, type)
-    node.add_local_node(klass)
+    node.add_local_node(klass, localname)
     try:
         # limit the instantiation trick since it's too dangerous
         # (such as infinite test execution...)
