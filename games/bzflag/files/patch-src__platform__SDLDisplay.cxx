--- src/platform/SDLDisplay.cxx.orig	2009-07-16 17:11:21.000000000 -0700
+++ src/platform/SDLDisplay.cxx	2009-07-16 17:13:27.000000000 -0700
@@ -314,7 +314,7 @@
 {
   Uint16 unicode = sdlEvent.key.keysym.unicode;
   SDLKey sym     = sdlEvent.key.keysym.sym;
-  SDLMod mod     = sdlEvent.key.keysym.mod;
+  Uint16 mod     = sdlEvent.key.keysym.mod;
 
   key.ascii = 0;
   switch (sym) {
@@ -483,7 +483,7 @@
 	return false;
       key.ascii = unicode & 0x7F;
     } else {
-      if ((sym >= SDLK_FIRST) && (sym <= SDLK_DELETE))
+      if ((sym >= SDLK_UNKNOWN) && (sym <= SDLK_DELETE))
 	key.ascii = sym;
       else if ((sym >= SDLK_KP0) && (sym <= SDLK_KP9))
 	key.ascii = sym - 208; // translate to normal number
