--- configure.py.orig	2011-05-03 09:10:13.000000000 -0600
+++ configure.py	2011-05-03 09:10:47.000000000 -0600
@@ -949,7 +949,7 @@
                 if sys.platform == "darwin":
                     # We need to work out how to specify the right framework
                     # version.
-                    link = "-framework Python"
+                    link = "%s @@MACPORTS_PYTHON_FRAMEWORK@@" % sipcfg.build_macros().get('LFLAGS', '')
                 elif "--enable-shared" in ducfg.get("CONFIG_ARGS", ""):
                     if glob.glob("%s/lib/libpython%d.%d*" % (ducfg["exec_prefix"], py_major, py_minor)):
                         lib_dir_flag = quote("-L%s/lib" % ducfg["exec_prefix"])
