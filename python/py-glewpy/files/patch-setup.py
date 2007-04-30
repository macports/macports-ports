--- setup.py	2006-04-25 00:34:28.000000000 +0200
+++ setup.py.new	2007-04-15 23:21:45.000000000 +0200
@@ -13,9 +13,12 @@
               'pgi', 'rend', 's3', 'sgis', 'sgix', 'sgi', 'sunx',
               'sun', 'win']
 
-glew_extensions = [Extension('glew', ['src/glew.pyx'], libraries=libs)]
+glew_extensions = [Extension('glew', ['src/glew.pyx'], 
+                             include_dirs=['/opt/local/include'], 
+                             libraries=libs)]
 gl_extensions = [Extension('gl.%s' % g,
                            ['src/gl/%s.pyx' % g],
+                           include_dirs=['/opt/local/include'],
                            libraries=libs) for g in gl_modules]
 
 all_extensions = []
