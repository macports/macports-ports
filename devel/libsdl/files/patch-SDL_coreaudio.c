--- src/audio/macosx/SDL_coreaudio.c.orig	2007-07-05 12:34:39.000000000 -0700
+++ src/audio/macosx/SDL_coreaudio.c	2007-07-05 12:35:25.000000000 -0700
@@ -22,6 +22,7 @@
 #include "SDL_config.h"
 
 #include <AudioUnit/AudioUnit.h>
+#include <AudioUnit/AUNTComponent.h>
 
 #include "SDL_audio.h"
 #include "../SDL_audio_c.h"
