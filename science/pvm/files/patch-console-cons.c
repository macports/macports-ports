--- console/cons.c.orig	2007-04-19 18:14:46.000000000 -0500
+++ console/cons.c	2009-11-15 02:07:52.000000000 -0600
@@ -792,7 +792,7 @@
 			last_line = (char *) NULL;
 		}
 
-		matches = (char **) completion_matches( text, command_generator );
+		matches = (char **) rl_completion_matches( text, command_generator );
 
 	}
 
@@ -801,7 +801,7 @@
 
 		if ( !last_line || strcmp( last_line, rl_line_buffer ) ) {
 
-			matches = (char **) completion_matches( text,
+			matches = (char **) rl_completion_matches( text,
 				command_help_generator );
 
 			if ( last_line ) free( last_line );
