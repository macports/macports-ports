--- ../ltmain.sh.orig	Sat Feb  7 18:37:27 2004
+++ ../ltmain.sh	Wed Dec 22 00:01:36 2004
@@ -4472,10 +4472,10 @@
 
 # Directory that this library needs to be installed in:
 libdir='$install_libdir'"
-	  if test "$installed" = no && test $need_relink = yes; then
-	    $echo >> $output "\
-relink_command=\"$relink_command\""
-	  fi
+#	  if test "$installed" = no && test $need_relink = yes; then
+#	    $echo >> $output "\
+#relink_command=\"$relink_command\""
+#	  fi
 	done
       fi
 
