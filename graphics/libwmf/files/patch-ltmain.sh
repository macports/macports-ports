--- ltmain.sh.orig	Wed Dec 11 08:22:34 2002
+++ ltmain.sh	Thu May 15 00:55:01 2003
@@ -4045,10 +4045,10 @@
 
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
 
