--- ../libjava/libltdl/ltmain.sh.orig	Tue Dec 16 14:48:24 2003
+++ ../libjava/libltdl/ltmain.sh	Wed Dec 22 00:01:47 2004
@@ -5174,10 +5174,10 @@
 
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
 
