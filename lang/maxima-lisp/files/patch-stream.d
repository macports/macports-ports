--- src/stream.d.sav	Mon Feb 10 10:50:38 2003
+++ src/stream.d	Mon Feb 10 10:51:12 2003
@@ -3181,7 +3181,7 @@
       #endif
       #ifdef UNIX_TERM_TERMIOS
       if (!( TCDRAIN(handle) ==0)) {
-        if (!((errno==ENOTTY)||(errno==EINVAL)))
+        if (!((errno==ENOTTY)||(errno==EINVAL)||(errno==EOPNOTSUPP)))
           { OS_error(); } # no TTY: OK, report other Error
       }
       #endif
