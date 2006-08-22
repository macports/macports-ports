--- sys/unix/nethack.sh.orig	2006-08-11 15:25:54.000000000 +0900
+++ sys/unix/nethack.sh	2006-08-11 15:27:39.000000000 +0900
@@ -5,6 +5,7 @@
 export HACKDIR
 HACK=$HACKDIR/nethack
 MAXNROFPLAYERS=20
+NKF="nkf -u -w"
 
 # JP
 # set LC_ALL, NETHACKOPTIONS etc..
@@ -26,6 +27,10 @@
 	export USERFILESEARCHPATH
 fi
 
+if [ "X$LANG" = "Xja_JP.eucJP" ] ; then
+	NKF="nkf -u -e"
+fi
+
 #if [ "X$DISPLAY" ] ; then
 #	xset fp+ $HACKDIR
 #fi
@@ -84,9 +89,9 @@
 cd $HACKDIR
 case $1 in
 	-s*)
-		exec $HACK "$@"
+		exec $HACK "$@" | $NKF
 		;;
 	*)
-		exec $HACK "$@" $MAXNROFPLAYERS
+		exec $HACK "$@" $MAXNROFPLAYERS | $NKF
 		;;
 esac
