--- c_stuff/Makefile.PL.orig	2006-10-19 22:46:35.000000000 +0200
+++ c_stuff/Makefile.PL	2006-12-23 11:55:13.000000000 +0100
@@ -78,5 +78,6 @@
     'OBJECT'       => 'fb_c_stuff.o',
     'INC'          => chomp_(`sdl-config --cflags`) . ' ' . chomp_(`pkg-config SDL_Pango --cflags`) . ' -I.',
     'OPTIMIZE'     => '-O2 -Wall',
+    'CCFLAGS'       => '-fnested-functions',
     'MAKEFILE'     => 'Makefile_c',
 );
