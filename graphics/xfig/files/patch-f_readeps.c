--- f_readeps.c.orig	2005-10-31 18:40:38.000000000 +0100
+++ f_readeps.c	2010-11-16 11:58:03.000000000 +0100
@@ -305,8 +305,8 @@
 	gscom[0] = '\0';
     }
     sprintf(&gscom[strlen(gscom)],
-	    "%s -r72x72 -dSAFER -sDEVICE=%s -g%dx%d -sOutputFile=%s -q - > %s 2>&1",
-	    appres.ghostscript, driver, wid, ht, pixnam, errnam);
+	    "%s -r72x72 -dNOSAFER -sDEVICE=%s -g%dx%d -sOutputFile=%s -c '<</PermitFileReading[(%s)]>> setuserparams .locksafe' -q - > %s 2>&1",
+	    appres.ghostscript, driver, wid, ht, pixnam, psnam, errnam);
     if (appres.DEBUG)
 	fprintf(stderr,"calling: %s\n",gscom);
     if ((gsfile = popen(gscom, "w")) == 0) {
