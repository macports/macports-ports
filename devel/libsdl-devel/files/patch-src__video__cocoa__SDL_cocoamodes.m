--- src/video/cocoa/SDL_cocoamodes.m.orig	2009-07-16 16:46:13.000000000 -0700
+++ src/video/cocoa/SDL_cocoamodes.m	2009-07-16 16:46:22.000000000 -0700
@@ -23,24 +23,6 @@
 
 #include "SDL_cocoavideo.h"
 
-/* 
-    Add methods to get at private members of NSScreen. 
-    Since there is a bug in Apple's screen switching code
-    that does not update this variable when switching
-    to fullscreen, we'll set it manually (but only for the
-    main screen).
-*/
-@interface NSScreen (NSScreenAccess)
-- (void) setFrame:(NSRect)frame;
-@end
-
-@implementation NSScreen (NSScreenAccess)
-- (void) setFrame:(NSRect)frame;
-{
-    _frame = frame;
-}
-@end
-
 static void
 CG_SetError(const char *prefix, CGDisplayErr result)
 {
@@ -248,15 +230,6 @@
         CGReleaseDisplayFadeReservation(fade_token);
     }
 
-    /* 
-        There is a bug in Cocoa where NSScreen doesn't synchronize
-        with CGDirectDisplay, so the main screen's frame is wrong.
-        As a result, coordinate translation produces incorrect results.
-        We can hack around this bug by setting the screen rect
-        ourselves. This hack should be removed if/when the bug is fixed.
-    */
-    [[NSScreen mainScreen] setFrame:NSMakeRect(0,0,mode->w,mode->h)]; 
-
     return 0;
 
     /* Since the blanking window covers *all* windows (even force quit) correct recovery is crucial */
