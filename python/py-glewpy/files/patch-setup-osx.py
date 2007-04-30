--- setup-osx.py	2006-04-25 00:34:28.000000000 +0200
+++ setup-osx.py.new	2007-04-15 21:49:20.000000000 +0200
@@ -1,6 +1,9 @@
 from distutils.core import setup
 from distutils.extension import Extension
 from Pyrex.Distutils import build_ext
+
+glew_include_dirs=['/opt/local/include']
+
 setup(
   name = "glewpy",
   version = '0.7.4',
@@ -16,31 +19,31 @@
                             'examples/oneshot.py',
                             'examples/logo2.jpg']},
   ext_modules=[
-    Extension('glew', ['src/glew.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.threedfx', ['src/gl/threedfx.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.apple', ['src/gl/apple.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.arb', ['src/gl/arb.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.ati', ['src/gl/ati.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.atix', ['src/gl/atix.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.ext', ['src/gl/ext.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.gl', ['src/gl/gl.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.hp', ['src/gl/hp.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.ibm', ['src/gl/ibm.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.ingr', ['src/gl/ingr.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.intel', ['src/gl/intel.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.ktx', ['src/gl/ktx.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.mesa', ['src/gl/mesa.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.nv', ['src/gl/nv.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.oml', ['src/gl/oml.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.pgi', ['src/gl/pgi.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.rend', ['src/gl/rend.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.s3', ['src/gl/s3.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.sgis', ['src/gl/sgis.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.sgix', ['src/gl/sgix.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.sgi', ['src/gl/sgi.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.sunx', ['src/gl/sunx.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.sun', ['src/gl/sun.pyx'], extra_link_args = ['-framework', 'OpenGL']),
-    Extension('gl.win', ['src/gl/win.pyx'], extra_link_args = ['-framework', 'OpenGL'])
+    Extension('glew', ['src/glew.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.threedfx', ['src/gl/threedfx.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.apple', ['src/gl/apple.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.arb', ['src/gl/arb.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.ati', ['src/gl/ati.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.atix', ['src/gl/atix.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.ext', ['src/gl/ext.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.gl', ['src/gl/gl.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.hp', ['src/gl/hp.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.ibm', ['src/gl/ibm.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.ingr', ['src/gl/ingr.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.intel', ['src/gl/intel.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.ktx', ['src/gl/ktx.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.mesa', ['src/gl/mesa.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.nv', ['src/gl/nv.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.oml', ['src/gl/oml.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.pgi', ['src/gl/pgi.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.rend', ['src/gl/rend.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.s3', ['src/gl/s3.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.sgis', ['src/gl/sgis.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.sgix', ['src/gl/sgix.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.sgi', ['src/gl/sgi.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.sunx', ['src/gl/sunx.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.sun', ['src/gl/sun.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL']),
+    Extension('gl.win', ['src/gl/win.pyx'], include_dirs=glew_include_dirs, extra_link_args = ['-framework', 'OpenGL'])
     ],
   cmdclass = {'build_ext': build_ext}
 )
