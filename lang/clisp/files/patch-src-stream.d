--- src/stream.d.orig	Thu Aug 12 22:02:44 2004
+++ src/stream.d	Thu Aug 12 21:43:00 2004
@@ -3221,7 +3221,7 @@
     #endif
     #ifdef UNIX_TERM_TERMIOS
       if (!( TCDRAIN(handle) ==0)) {
-        if (!((errno==ENOTTY)||(errno==EINVAL)))
+        if (!((errno==ENOTTY)||(errno==EINVAL)||(errno=EOPNOTSUPP)))
           { OS_error(); } # no TTY: OK, report other Error
       }
     #endif
