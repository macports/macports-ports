--- ltmain.sh.orig	Tue Jan 28 11:19:07 2003
+++ ltmain.sh	Sun Feb 29 17:49:23 2004
@@ -4700,10 +4700,10 @@
 
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
 
