--- admin/ltmain.sh.orig	Thu Feb  5 15:52:10 2004
+++ admin/ltmain.sh	Thu Feb  5 16:49:16 2004
@@ -1845,6 +1845,8 @@
 	  alldeplibs=yes
 	  continue
 	  ;;
+	-framework) continue ;;
+	[A-Za-z]*) continue ;;
 	esac # case $deplib
 	if test "$found" = yes || test -f "$lib"; then :
 	else
