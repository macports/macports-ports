--- configure.py.orig	2009-07-15 01:37:10.000000000 +1200
+++ configure.py	2009-07-19 18:28:19.000000000 +1200
@@ -840,7 +840,7 @@
                 if sys.platform == "darwin":
                     # We need to work out how to specify the right framework
                     # version.
-                    link = "-framework Python"
+                    link = "%s @@MACPORTS_PYTHON_FRAMEWORK@@" % sipcfg.build_macros().get('LFLAGS', '')
                 elif ("--enable-shared" in ducfg.get("CONFIG_ARGS", "") and
                       glob.glob("%s/lib/libpython%d.%d*" % (ducfg["exec_prefix"], py_major, py_minor))):
                     lib_dir_flag = quote("-L%s/lib" % ducfg["exec_prefix"])
