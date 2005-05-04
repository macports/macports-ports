--- ghc/rts/GC.c.sav	2005-04-30 14:17:17.000000000 -0400
+++ ghc/rts/GC.c	2005-04-30 14:18:05.000000000 -0400
@@ -80,7 +80,7 @@
  * We build up a static object list while collecting generations 0..N,
  * which is then appended to the static object list of generation N+1.
  */
-static StgClosure* static_objects;      // live static objects
+StgClosure* static_objects; 	        // live static objects
 StgClosure* scavenged_static_objects;   // static objects scavenged so far
 
 /* N is the oldest generation being collected, where the generations
