--- aclocal.m4-orig	Thu Oct 17 22:39:47 2002
+++ aclocal.m4	Wed Feb 26 14:56:35 2003
@@ -1708,7 +1708,7 @@
     ;;
 
   darwin* | rhapsody*)
-    allow_undefined_flag='-undefined suppress'
+    allow_undefined_flag='-flat_namespace -undefined suppress'
     # FIXME: Relying on posixy $() will cause problems for
     #        cross-compilation, but unfortunately the echo tests do not
     #        yet detect zsh echo's removal of \ escapes.
