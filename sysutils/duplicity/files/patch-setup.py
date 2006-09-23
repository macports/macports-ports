--- setup.py.orig	2006-09-23 10:16:16.000000000 -0700
+++ setup.py	2006-09-23 10:17:08.000000000 -0700
@@ -19,7 +19,9 @@
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
