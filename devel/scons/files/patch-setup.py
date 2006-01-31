--- setup.py.orig	2005-09-08 07:15:23.000000000 -0600
+++ setup.py	2006-01-31 01:23:57.000000000 -0700
@@ -330,7 +330,7 @@
             if is_win32:
                 dir = 'Doc'
             else:
-                dir = os.path.join('man', 'man1')
+                dir = os.path.join('share', 'man', 'man1')
             self.data_files = [(dir, ["scons.1", "sconsign.1"])]
             man_dir = os.path.join(self.install_dir, dir)
             msg = "Installed SCons man pages into %s" % man_dir
@@ -351,7 +351,7 @@
                           "SCons.Sig",
                           "SCons.Tool"],
     'package_dir'      : {'' : 'engine'},
-    'data_files'       : [('man/man1', ["scons.1", "sconsign.1"])],
+    'data_files'       : [('share/man/man1', ["scons.1", "sconsign.1"])],
     'scripts'          : ['script/scons',
                           'script/sconsign',
                           'script/scons.bat'],
