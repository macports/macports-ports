--- setup.py.orig	2021-01-21 08:42:04
+++ setup.py	2025-03-06 03:44:53
@@ -287,6 +287,8 @@
         ext_modules=[
             Extension('yaml._yaml', ['yaml/_yaml.pyx'],
                 'libyaml', "LibYAML bindings", LIBYAML_CHECK,
+                include_dirs=['__PREFIX__/include'],
+                library_dirs=['__PREFIX__/lib'],
                 libraries=['yaml']),
         ],
 
