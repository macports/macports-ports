--- proc.c.orig	Sat Mar  9 06:46:40 1996
+++ proc.c	Wed Dec 20 05:20:13 2000
@@ -827,8 +827,14 @@
 		int	ph;
 
 		swritef(pnbuf, sizeof(pnbuf), "%s/%s", TmpDir, "jpXXXXXX");
+#ifndef NO_MKSTEMP
+		pipename = pnbuf;
+		ph = mkstemp( pipename );
+#else
 		pipename = mktemp(pnbuf);
-		if ((ph = creat(pipename, S_IWRITE|S_IREAD)) < 0)
+		ph = creat(pipename, S_IWRITE|S_IREAD);
+#endif
+		if (ph == -1)
 			complain("cannot make pipe for filter: %s", strerror(errno));
 		close(1);
 		close(2);
@@ -923,7 +929,18 @@
 	jmp_buf	sav_jmp;
 
 	swritef(tnambuf, sizeof(tnambuf), "%s/%s", TmpDir, "jfXXXXXX");
+#ifndef NO_MKSTEMP
+	{
+		int fd = mkstemp(tnambuf);
+		if ( fd == -1 )
+			complain( "can't create temp file %s: %s",
+				  tnambuf, strerror(errno) );
+		close( fd );
+		tname = tnambuf;
+	}
+#else
 	tname = mktemp(tnambuf);
+#endif
 	fp = open_file(tname, iobuff, F_WRITE, YES);
 	push_env(sav_jmp);
 	if (setjmp(mainjmp) == 0) {
