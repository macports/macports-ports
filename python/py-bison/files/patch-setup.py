--- setup.py	2004-04-24 04:05:41.000000000 +0200
+++ setup.py	2005-11-05 20:06:06.000000000 +0100
@@ -24,6 +24,11 @@
     extra_link_args = []
     bison2pyscript = 'utils/bison2py'
     bisondynlibModule = "src/c/bisondynlib-linux.c"
+elif sys.platform == 'darwin':
+    libs = []
+    extra_link_args = []
+    bison2pyscript = 'utils/bison2py'
+    bisondynlibModule = "src/c/bisondynlib-linux.c"
 else:
     print "Sorry, your platform is presently unsupported"
     sys.exit(1)
