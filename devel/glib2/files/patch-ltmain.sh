--- ltmain.sh.orig	Sun Jun 29 03:28:20 2003
+++ ltmain.sh	Sun Jun 29 03:28:56 2003
@@ -5145,10 +5145,10 @@
 
 # Directory that this library needs to be installed in:
 libdir='$install_libdir'"
-	  if test "$installed" = no && test "$need_relink" = yes; then
-	    $echo >> $output "\
-relink_command=\"$relink_command\""
-	  fi
+#	  if test "$installed" = no && test "$need_relink" = yes; then
+#	    $echo >> $output "\
+#relink_command=\"$relink_command\""
+#	  fi
 	done
       fi
 
