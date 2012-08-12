--- setup.py.orig	2012-08-05 10:38:32.000000000 -0500
+++ setup.py	2012-08-12 12:33:04.000000000 -0500
@@ -354,7 +354,7 @@
             if is_win32:
                 dir = 'Doc'
             else:
-                dir = os.path.join('man', 'man1')
+                dir = os.path.join('share', 'man', 'man1')
             self.data_files = [(dir, man_pages)]
             man_dir = os.path.join(self.install_dir, dir)
             msg = "Installed SCons man pages into %s" % man_dir
