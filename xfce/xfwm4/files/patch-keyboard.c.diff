--- src/keyboard.c.orig	2007-09-22 13:32:29.000000000 +0200
+++ src/keyboard.c	2007-09-22 13:51:01.000000000 +0200
@@ -255,6 +255,7 @@
     int max_keycode;
 
     AltMask = 0;
+    int ModeMask = 0;
     MetaMask = 0;
     NumLockMask = 0;
     ScrollLockMask = 0;
@@ -303,9 +304,17 @@
                 {
                     AltMask |= (1 << ( i / modmap->max_keypermod));
                 }
+                else if (syms[j] == XK_Mode_switch)
+                {
+                    ModeMask |= (1 << ( i / modmap->max_keypermod));
+                }
             }
         }
     }
+     
+    if (AltMask == 0) /* if we don't have any alt keys, use the option keys */
+        AltMask = ModeMask;
+    
     KeyMask =
         ControlMask | ShiftMask | AltMask | MetaMask | SuperMask | HyperMask;
 
