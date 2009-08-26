--- src/video/cocoa/SDL_cocoakeyboard.m.orig	2009-07-16 17:28:25.000000000 -0700
+++ src/video/cocoa/SDL_cocoakeyboard.m	2009-07-16 17:33:36.000000000 -0700
@@ -351,14 +351,14 @@
 static void
 UpdateKeymap(SDL_VideoData *data)
 {
-    KeyboardLayoutRef key_layout;
+    TISInputSourceRef key_layout;
     const void *chr_data;
     int i;
     SDL_scancode scancode;
     SDLKey keymap[SDL_NUM_SCANCODES];
 
     /* See if the keymap needs to be updated */
-    KLGetCurrentKeyboardLayout(&key_layout);
+    key_layout = TISCopyCurrentKeyboardLayoutInputSource();
     if (key_layout == data->key_layout) {
         return;
     }
@@ -367,7 +367,7 @@
     SDL_GetDefaultKeymap(keymap);
 
     /* Try Unicode data first (preferred as of Mac OS X 10.5) */
-    KLGetKeyboardLayoutProperty(key_layout, kKLuchrData, &chr_data);
+    chr_data = TISGetInputSourceProperty(key_layout, kTISPropertyUnicodeKeyLayoutData);
     if (chr_data) {
         UInt32 keyboard_type = LMGetKbdType();
         OSStatus err;
@@ -400,6 +400,7 @@
         return;
     }
 
+#if 0
     /* Fall back to older style key map data */
     KLGetKeyboardLayoutProperty(key_layout, kKLKCHRData, &chr_data);
     if (chr_data) {
@@ -449,6 +450,7 @@
         SDL_SetKeymap(data->keyboard, 0, keymap, SDL_NUM_SCANCODES);
         return;
     }
+#endif
 }
 
 void
