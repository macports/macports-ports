--- abbrev.c.orig	Fri Mar  8 02:34:41 1996
+++ abbrev.c	Wed Dec 20 05:19:33 2000
@@ -274,7 +274,16 @@
 		"jabbXXXXXX"
 #endif
 		);
+#ifndef NO_MKSTEMP
+	{
+		int fd = mkstemp(tname);
+		if ( fd == -1 )
+			err( 1, "can't create temp file %s", tname );
+		close( fd );
+	}
+#else
 	(void) mktemp(tname);
+#endif
 	save_abbrevs(tname);
 	setfname(ebuf, tname);
 	read_file(tname, NO);
