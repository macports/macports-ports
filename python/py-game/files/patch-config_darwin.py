--- config_darwin.py	2003-10-18 07:36:51.000000000 +0200
+++ config_darwin.py	2005-06-15 09:37:47.000000000 +0200
@@ -87,7 +87,7 @@
     FrameworkDependency('FONT', 'SDL_ttf.h', 'libSDL_ttf', 'SDL_ttf'),
     FrameworkDependency('IMAGE', 'SDL_image.h', 'libSDL_image', 'SDL_image'),
     FrameworkDependency('MIXER', 'SDL_mixer.h', 'libSDL_mixer', 'SDL_mixer'),
-    FrameworkDependency('SMPEG', 'smpeg.h', 'libsmpeg', 'smpeg'),
+    Dependency('SMPEG', 'smpeg.h', 'libsmpeg', 'smpeg'),
     DependencyPython('NUMERIC', 'Numeric', 'Numeric/arrayobject.h')
 ]
 
@@ -97,8 +97,8 @@
     global DEPS
 
     print 'Hunting dependencies...'
-    incdirs = []
-    libdirs = []
+    incdirs = ['__PREFIX__/include/smpeg']
+    libdirs = ['__PREFIX__/lib']
     newconfig = []
     for d in DEPS:
       d.configure(incdirs, libdirs)
