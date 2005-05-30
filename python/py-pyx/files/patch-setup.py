--- setup.py	2004-05-12 10:13:55.000000000 +0200
+++ setup.py	2005-05-30 21:16:37.000000000 +0200
@@ -53,7 +53,7 @@
                              "pyx/lfs/foils30pt.lfs",
                              "contrib/pyx.def"]),
               # /etc is taken relative to "setup.py install --root=..."
-              ("/etc", ["pyxrc"])]
+              ("etc", ["pyxrc"])]
 
 #
 # pyx_build_py
@@ -80,9 +80,9 @@
             # using the pyx_install_data instance
             install_data = self.distribution.command_obj["install_data"]
             f = open(outfile, "w")
-            f.write("lfsdir = %r\n" % install_data.pyx_lfsdir)
-            f.write("sharedir = %r\n" % install_data.pyx_sharedir)
-            f.write("pyxrc = %r\n" % install_data.pyx_pyxrc)
+            f.write("lfsdir = %r\n" % "__PREFIX__/share/pyx")
+            f.write("sharedir = %r\n" % "__PREFIX__/share/pyx")
+            f.write("pyxrc = %r\n" % "__PREFIX__/etc")
             f.close()
         else:
             return build_py.build_module(self, module, module_file, package)
