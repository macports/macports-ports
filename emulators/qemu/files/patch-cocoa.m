--- cocoa.m.orig	2009-07-17 10:56:22.000000000 +1000
+++ cocoa.m	2009-11-22 20:29:06.000000000 +1100
@@ -438,7 +438,7 @@ int cocoa_keycode_to_qemu(int keycode)
         [self grabMouse];
         [self setContentDimensions];
 // test if host support "enterFullScreenMode:withOptions" at compiletime
-#if (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4)
+#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
         if ([NSView respondsToSelector:@selector(enterFullScreenMode:withOptions:)]) { // test if "enterFullScreenMode:withOptions" is supported on host at runtime
             [self enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithBool:NO], NSFullScreenModeAllScreens,
@@ -454,7 +454,7 @@ int cocoa_keycode_to_qemu(int keycode)
             [fullScreenWindow setHasShadow:NO];
             [fullScreenWindow setContentView:self];
             [fullScreenWindow makeKeyAndOrderFront:self];
-#if (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4)
+#if defined(MAC_OS_X_VERSION_10_5) && (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
         }
 #endif
     }
