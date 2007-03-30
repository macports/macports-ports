--- setup.py.orig	2007-02-12 19:55:03.000000000 -0800
+++ setup.py	2007-03-29 17:36:09.000000000 -0700
@@ -336,7 +336,7 @@
             if is_win32:
                 dir = 'Doc'
             else:
-                dir = os.path.join('man', 'man1')
+                dir = os.path.join('share', 'man', 'man1')
             self.data_files = [(dir, man_pages)]
             man_dir = os.path.join(self.install_dir, dir)
             msg = "Installed SCons man pages into %s" % man_dir
