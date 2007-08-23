--- setup.py.orig	2007-08-20 11:19:25.000000000 -0400
+++ setup.py	2007-08-20 14:32:36.000000000 -0400
@@ -31,7 +31,9 @@
 	  package_dir = {"duplicity": "src"},
 	  ext_modules = [Extension("duplicity._librsync",
 							   ["_librsyncmodule.c"],
-							   libraries=["rsync"])],
+							   libraries=["rsync"],
+                               include_dirs=["@PREFIX@/include"],
+                               library_dirs=["@PREFIX@/lib"])],
 	  scripts = ['rdiffdir', 'duplicity'],
 	  data_files = [('share/man/man1', ['duplicity.1', 'rdiffdir.1']),
 					('share/doc/duplicity-%s' % version_string,
