--- src/stream.d.sav	2005-07-12 08:39:34.000000000 -0400
+++ src/stream.d	2005-07-12 08:58:02.000000000 -0400
@@ -3214,6 +3214,9 @@
           #ifdef UNIX_CYGWIN32 /* for win95 and xterm/rxvt */
           if ((errno != EBADF) && (errno != EACCES))
           #endif
+          #ifdef UNIX_DARWIN
+          if ((errno!=EOPNOTSUPP) && (errno!=ENODEV))
+          #endif
           if (!(errno==EINVAL))
             { OS_error(); }
         #endif
@@ -3267,6 +3270,9 @@
         #ifdef UNIX_CYGWIN32 /* for win95 and xterm/rxvt */
         if ((errno != EBADF) && (errno != EACCES))
         #endif
+        #ifdef UNIX_DARWIN
+        if ((errno!=EOPNOTSUPP) && (errno!=ENODEV))
+        #endif
         if (!(errno==EINVAL))
           OS_error();
       #endif
