--- config_unix.py	Mon Oct  7 01:04:58 2002
+++ ../../config_unix.py	Tue Dec 28 12:15:36 2004
@@ -106,7 +106,7 @@
     
     vorbis_include_dir = vorbis_prefix + '/include'
     vorbis_lib_dir = vorbis_prefix + '/lib'
-    vorbis_libs = 'vorbis vorbisfile vorbisenc'
+    vorbis_libs = 'vorbis vorbisfile vorbisenc ogg'
 
     msg_checking('for Vorbis')
 
