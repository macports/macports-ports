diff -uNbr aclocal.m4 libxslt-1.0.18-new/aclocal.m4
--- aclocal.m4	Mon May 27 17:31:20 2002
+++ libxslt-1.0.18-new/aclocal.m4	Thu Jun  6 22:49:06 2002
@@ -1635,7 +1635,7 @@
     ;;
 
   darwin* | rhapsody*)
-    allow_undefined_flag='-undefined suppress'
+    allow_undefined_flag='-undefined suppress -flat_namespace'
     # FIXME: Relying on posixy $() will cause problems for
     #        cross-compilation, but unfortunately the echo tests do not
     #        yet detect zsh echo's removal of \ escapes.
