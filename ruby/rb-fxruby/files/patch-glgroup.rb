--- lib/fox/glgroup.rb	Wed Jun 18 10:26:15 2003
+++ ../FXRuby-1.0.27-patched/lib/fox/glgroup.rb	Fri Jan  2 16:48:55 2004
@@ -1,6 +1,6 @@
 require 'fox'
 begin
-  require 'opengl'
+#  require 'opengl'
 rescue LoadError
   # Can't use FXGLGroup since it depends on Ruby/OpenGL
 end
