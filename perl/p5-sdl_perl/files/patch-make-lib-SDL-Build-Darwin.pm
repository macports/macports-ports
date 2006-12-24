--- make/lib/SDL/Build/Darwin.pm.orig	2006-11-19 21:47:14.000000000 -0800
+++ make/lib/SDL/Build/Darwin.pm	2006-11-19 21:48:58.000000000 -0800
@@ -16,17 +16,30 @@
 	'/usr/include/GL'          => '/usr/lib', 
 	'/usr/include/gl'          => '/usr/lib', 
 
-	'/System/Library/Frameworks/SDL_mixer.framework/Headers'     => '../../lib',
-	'/System/Library/Frameworks/SDL_image.framework/Headers'     => '../../lib',
-	'/System/Library/Frameworks/SDL_ttf.framework/Headers'       => '../../lib',
-	'/System/Library/Frameworks/libogg.framework/Headers'        => '../../lib',
-	'/System/Library/Frameworks/libvorbis.framework/Headers'     => '../../lib',
-	'/System/Library/Frameworks/libvorbisfile.framework/Headers' => '../../lib',
-	'/System/Library/Frameworks/libvorbisenc.framework/Headers'  => '../../lib',
-	'../../include'                                              => '../../lib',
-	'/System/Library/Frameworks/OpenGL.framework/Headers'        =>
+	'/Library/Frameworks/SDL.framework/Headers'	      => '../../lib',
+	'/Library/Frameworks/SDL_mixer.framework/Headers'     => '../../lib',
+	'/Library/Frameworks/SDL_image.framework/Headers'     => '../../lib',
+	'/Library/Frameworks/SDL_net.framework/Headers'       => '../../lib',
+	'/Library/Frameworks/SDL_ttf.framework/Headers'       => '../../lib',
+	'/Library/Frameworks/SDL_gfx.framework/Headers'       => '../../lib',
+	'/Library/Frameworks/libogg.framework/Headers'        => '../../lib',
+	'/Library/Frameworks/libvorbis.framework/Headers'     => '../../lib',
+	'/Frameworks/libvorbisfile.framework/Headers'	      => '../../lib',
+	'/Library/Frameworks/libvorbisenc.framework/Headers'  => '../../lib',
+	'../../include'                                       => '../../lib',
+	'/System/Library/Frameworks/OpenGL.framework/Headers' =>
 		'/System/Library/Frameworks/OpenGL.framework/Libraries',
 	);
 }
 
+sub build_defines
+{
+	my $self = shift;
+	my $defines = $self->SUPER::build_defines(@_);
+
+	push @{$defines->{SDL}}, "-Ddarwin", "-DMACOSX";
+
+	return $defines;
+}
+
 1;
