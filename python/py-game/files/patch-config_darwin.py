--- config_darwin.py.orig	2005-08-04 17:18:50.000000000 -0700
+++ config_darwin.py	2005-08-04 17:21:29.000000000 -0700
@@ -3,6 +3,12 @@
 import os, sys, string
 from glob import glob
 from distutils.sysconfig import get_python_inc
+localbase = os.environ.get('LOCALBASE', '')
+
+#these get prefixes with '/usr' and '/usr/local' or the $LOCALBASE
+origincdirs = ['/include', '/include/SDL', '/include/SDL11',
+               '/include/smpeg' ]
+origlibdirs = ['/lib']
 
 class Dependency:
     libext = '.dylib'
@@ -72,22 +78,26 @@
             except ImportError:
                 self.found = 0
         if self.found and self.header:
-            fullpath = os.path.join(get_python_inc(0), self.header)
+            if localbase:
+                basepath = get_python_inc(0,prefix=localbase)
+            else:
+                basepath = get_python_inc(0)
+            fullpath = os.path.join(basepath, self.header)
             if not os.path.isfile(fullpath):
                 found = 0
             else:
-                self.inc_dir = os.path.split(fullpath)[0]
+                self.inc_dir = basepath
         if self.found:
             print self.name + '        '[len(self.name):] + ': found', self.ver
         else:
             print self.name + '        '[len(self.name):] + ': not found'
 
 DEPS = [
-    FrameworkDependency('SDL', 'SDL.h', 'libSDL', 'SDL'),
-    FrameworkDependency('FONT', 'SDL_ttf.h', 'libSDL_ttf', 'SDL_ttf'),
-    FrameworkDependency('IMAGE', 'SDL_image.h', 'libSDL_image', 'SDL_image'),
-    FrameworkDependency('MIXER', 'SDL_mixer.h', 'libSDL_mixer', 'SDL_mixer'),
-    FrameworkDependency('SMPEG', 'smpeg.h', 'libsmpeg', 'smpeg'),
+    Dependency('SDL', 'SDL.h', 'libSDL', 'SDL'),
+    Dependency('FONT', 'SDL_ttf.h', 'libSDL_ttf', 'SDL_ttf'),
+    Dependency('IMAGE', 'SDL_image.h', 'libSDL_image', 'SDL_image'),
+    Dependency('MIXER', 'SDL_mixer.h', 'libSDL_mixer', 'SDL_mixer'),
+    Dependency('SMPEG', 'smpeg.h', 'libsmpeg', 'smpeg'),
     DependencyPython('NUMERIC', 'Numeric', 'Numeric/arrayobject.h')
 ]
 
@@ -97,11 +107,22 @@
     global DEPS
 
     print 'Hunting dependencies...'
-    incdirs = []
-    libdirs = []
+    if localbase:
+        incdirs = [localbase+d for d in origincdirs]
+        libdirs = [localbase+d for d in origlibdirs]
+    incdirs += ["/usr"+d for d in origincdirs]
+    libdirs += ["/usr"+d for d in origlibdirs]
+    incdirs += ["/usr/local"+d for d in origincdirs]
+    libdirs += ["/usr/local"+d for d in origlibdirs]
+    for arg in string.split(DEPS[0].cflags):
+        if arg[:2] == '-I':
+            incdirs.append(arg[2:])
+        elif arg[:2] == '-L':
+            libdirs.append(arg[2:])
     newconfig = []
     for d in DEPS:
       d.configure(incdirs, libdirs)
+
     DEPS[0].cflags = '-Ddarwin '+ DEPS[0].cflags
     try:
         import objc
