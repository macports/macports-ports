--- make/lib/SDL/Build/Darwin.pm.orig	2008-05-03 13:58:14.000000000 -0700
+++ make/lib/SDL/Build/Darwin.pm	2008-05-03 14:00:52.000000000 -0700
@@ -5,28 +5,25 @@
 sub fetch_includes
 {
 	return (
-	'/usr/local/include/SDL'   => '/usr/local/lib',
+	"$ENV{'PREFIX'}/include"   => "$ENV{'PREFIX'}/lib",
+	"$ENV{'PREFIX'}/include/SDL" => "$ENV{'PREFIX'}/lib",
 	'/usr/local/include'       => '/usr/local/lib',
-	'/usr/local/include/smpeg' => '/usr/local/lib',
-	'/usr/include/SDL'         => '/usr/lib',
 	'/usr/include'             => '/usr/lib',
-	'/usr/include/smpeg'       => '/usr/lib',
-	'/usr/local/include/GL'    => '/usr/local/lib',
-	'/usr/local/include/gl'    => '/usr/local/lib',
-	'/usr/include/GL'          => '/usr/lib', 
-	'/usr/include/gl'          => '/usr/lib', 
 
-	'/System/Library/Frameworks/SDL_mixer.framework/Headers'     => '../../lib',
-	'/System/Library/Frameworks/SDL_image.framework/Headers'     => '../../lib',
-	'/System/Library/Frameworks/SDL_ttf.framework/Headers'       => '../../lib',
-	'/System/Library/Frameworks/libogg.framework/Headers'        => '../../lib',
-	'/System/Library/Frameworks/libvorbis.framework/Headers'     => '../../lib',
-	'/System/Library/Frameworks/libvorbisfile.framework/Headers' => '../../lib',
-	'/System/Library/Frameworks/libvorbisenc.framework/Headers'  => '../../lib',
-	'../../include'                                              => '../../lib',
+	'../../include'                                       => '../../lib',
 	'/System/Library/Frameworks/OpenGL.framework/Headers'        =>
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
