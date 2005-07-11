--- volume_io/Prog_utils/time.c	2004-10-04 21:19:22.000000000 +0100
+++ volume_io/Prog_utils/time.c 2005-07-03 23:33:44.000000000 +0100
@@ -56,7 +56,7 @@
     if( !initialized )
     {
         initialized = TRUE;
-        clock_ticks_per_second = (Real) CLK_TCK;
+        clock_ticks_per_second = (Real) sysconf ( _SC_CLK_TCK );
     }
 
     return( clock_ticks_per_second );
