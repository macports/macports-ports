--- vobcopy.c.orig	2009-07-22 13:12:11.000000000 -0700
+++ vobcopy.c	2009-07-22 13:15:49.000000000 -0700
@@ -773,7 +773,7 @@
 
   if( longest_title_flag ) /*no title specified (-n ) */
     {
-      titleid = get_longest_title( &dvd );
+      titleid = get_longest_title( dvd );
       fprintf( stderr, _("[Info] longest title %d.\n"), titleid );
     }
 
@@ -1825,7 +1825,7 @@
 	    }
 	  
 	  if( verbosity_level >= 1 && skipped_blocks > 0 )
-	    fprintf( stderr, _("[Warn] Had to skip (couldn't read) %d blocks (before block %d)! \n "), skipped_blocks, offset );
+	    fprintf( stderr, _("[Warn] Had to skip (couldn't read) %d blocks (before block %lld)! \n "), skipped_blocks, offset );
 
 /*TODO: this skipping here writes too few bytes to the output */
 
