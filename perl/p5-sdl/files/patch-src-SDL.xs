--- src/SDL.xs.orig	2006-11-27 05:58:47.000000000 -0800
+++ src/SDL.xs	2006-11-27 05:59:10.000000000 -0800
@@ -71,6 +71,29 @@
 
 #include "defines.h"
 
+#ifdef MACOSX
+#include <CoreServices/CoreServices.h>
+
+void CPSEnableForegroundOperation(ProcessSerialNumber* psn);
+void NSApplicationLoad();
+void SDL_macosx_init(void) {
+    Boolean sameProc;
+    ProcessSerialNumber myProc, frProc;
+    if (GetFrontProcess(&frProc) == noErr)
+        if (GetCurrentProcess(&myProc) == noErr)
+            if (SameProcess(&frProc, &myProc, &sameProc) == noErr && sameProc == 0) {
+                /*
+                NSLog(@"creating bad autorelease pool");
+                [[NSAutoreleasePool alloc] init];
+                */
+                NSApplicationLoad();
+                CPSEnableForegroundOperation(&myProc);
+            }
+}
+void SDL_macosx_quit(void) {
+}
+#endif // MACOSX
+
 Uint32 
 sdl_perl_timer_callback ( Uint32 interval, void* param )
 {
@@ -3902,7 +3925,7 @@
      RETVAL
 
 int
-GFXFilledpieColor ( dst, x, y, rad, start, end, color )
+GFXFilledPieColor ( dst, x, y, rad, start, end, color )
     SDL_Surface* dst;
     Sint16 x;
     Sint16 y;
@@ -3911,12 +3934,12 @@
     Sint16 end;
     Uint32 color;
 CODE:
-     RETVAL = filledpieColor( dst, x, y, rad, start, end, color );
+     RETVAL = filledPieColor( dst, x, y, rad, start, end, color );
 OUTPUT:
      RETVAL
 
 int
-GFXFilledpieRGBA ( dst, x, y, rad, start, end, r, g, b, a )
+GFXFilledPieRGBA ( dst, x, y, rad, start, end, r, g, b, a )
     SDL_Surface* dst;
     Sint16 x;
     Sint16 y;
@@ -3928,7 +3951,7 @@
     Uint8 b;
     Uint8 a;
 CODE:
-     RETVAL = filledpieRGBA( dst, x, y, rad, start, end, r, g, b, a );
+     RETVAL = filledPieRGBA( dst, x, y, rad, start, end, r, g, b, a );
 OUTPUT:
      RETVAL
 
