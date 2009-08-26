--- src/video/cocoa/SDL_cocoawindow.h.orig	2009-07-17 11:26:07.000000000 -0700
+++ src/video/cocoa/SDL_cocoawindow.h	2009-07-17 11:26:14.000000000 -0700
@@ -27,7 +27,7 @@
 typedef struct SDL_WindowData SDL_WindowData;
 
 /* *INDENT-OFF* */
-@interface Cocoa_WindowListener:NSResponder {
+@interface Cocoa_WindowListener:NSResponder <NSWindowDelegate> {
     SDL_WindowData *_data;
 }
 
