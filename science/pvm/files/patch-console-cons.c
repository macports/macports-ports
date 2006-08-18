--- console/cons.c	2001-02-08 00:10:09.000000000 +0100
+++ console/cons.c	2006-08-18 10:28:46.000000000 +0200
@@ -788,7 +788,7 @@
 			last_line = (char *) NULL;
 		}
 
-		matches = completion_matches( text, command_generator );
+		matches = rl_completion_matches( text, command_generator );
 
 	}
 
@@ -797,7 +797,7 @@
 
 		if ( !last_line || strcmp( last_line, rl_line_buffer ) ) {
 
-			matches = completion_matches( text,
+			matches = rl_completion_matches( text,
 				command_help_generator );
 
 			if ( last_line ) free( last_line );
