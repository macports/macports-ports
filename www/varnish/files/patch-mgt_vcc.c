Index: bin/varnishd/mgt_vcc.c
===================================================================
--- bin/varnishd/mgt_vcc.c	(revision 1503)
+++ bin/varnishd/mgt_vcc.c	(working copy)
@@ -164,7 +164,7 @@
 	/* Attempt to open a pipe to the system C-compiler */
 	sprintf(buf,
 	    "ln -f %s /tmp/_.c ;"		/* XXX: for debugging */
-	    "exec cc -fpic -shared -Wl,-x -o %s -x c - < %s 2>&1",
+	    "exec cc -dynamiclib -Wl,-flat_namespace,-undefined,suppress -o %s -x c - < %s 2>&1",
 	    sf, of, sf);
 
 	fo = popen(buf, "r");
