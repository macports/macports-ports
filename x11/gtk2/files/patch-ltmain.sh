--- ltmain.sh.orig	Sun Dec  1 13:22:11 2002
+++ ltmain.sh	Sun Dec  1 13:25:03 2002
@@ -4047,10 +4047,10 @@
 
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
 
