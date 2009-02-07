--- setup.py.orig	2009-02-01 19:01:52.000000000 +0900
+++ setup.py	2009-02-01 19:02:20.000000000 +0900
@@ -332,6 +332,8 @@
         ext_modules=[
             Extension('_yaml', ['ext/_yaml.pyx'],
                 'libyaml', "LibYAML bindings", LIBYAML_CHECK,
+                include_dirs=['__PREFIX__/include'],
+                library_dirs=['__PREFIX__/lib'],
                 libraries=['yaml']),
         ],
 
