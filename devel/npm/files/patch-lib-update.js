--- lib/update.js.orig	2011-09-11 13:03:12.000000000 +0200
+++ lib/update.js	2011-09-11 13:09:44.000000000 +0200
@@ -27,6 +27,14 @@
         , dep = ww[1]
         , want = ww[3]
         , what = dep + "@" + want
+	
+	if (where.match(/@@NPM_PATH_JSREGEX@@/)) {
+           log.error("Trying to update '" + what + "' in '" + where + "'")
+           log.error("which is part of the MacPorts npm base installation.")
+	    log.error("To update npm please run:")
+           log.error("sudo port selfupdate && sudo port upgrade npm\n")
+	    return cb()
+	}
 
       npm.commands.install(where, what, cb)
     }, cb)
