--- include/bzfSDL.h.orig	2009-07-16 17:02:56.000000000 -0700
+++ include/bzfSDL.h	2009-07-16 17:03:23.000000000 -0700
@@ -19,7 +19,6 @@
 #  ifdef HAVE_SDL_SDL_H
 #    include <SDL/SDL.h>
 #    include <SDL/SDL_thread.h>
-#    include <SDL/SDL_getenv.h>
 #  else // autotools adds an SDL-specific include path
 #    include "SDL.h"
 #    include "SDL_thread.h"
