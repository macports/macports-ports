--- src/SpeedyMake.pl.orig	Sun Mar 30 08:17:01 2003
+++ src/SpeedyMake.pl	Sun Mar 30 08:18:59 2003
@@ -214,6 +214,7 @@
     join(' ',
 	"-DSPEEDY_PROGNAME=\\\"" . $class->my_name_full . "\\\"",
 	"-DSPEEDY_VERSION=\\\"\$(VERSION)\\\"",
+	"-DIAMSUID",
 	'-DSPEEDY_' . ($class->am_frontend ? 'FRONTEND' : 'BACKEND'),
     );
 }
