--- src/js/js.cxx.orig	Fri Nov 29 17:11:56 2002
+++ src/js/js.cxx	Wed Sep 22 11:16:32 2004
@@ -22,8 +22,6 @@
 
 #include "js.h"
 
-void jsInit () {}
-
 float jsJoystick::fudge_axis ( float value, int axis ) const
 {
   if ( value < center[axis] )
@@ -83,5 +81,6 @@
     for ( int i = 0 ; i < num_axes ; i++ )
       axes[i] = fudge_axis ( raw_axes[i], i ) ;
 }
+
 
 
