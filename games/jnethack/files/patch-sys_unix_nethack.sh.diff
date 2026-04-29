--- sys/unix/nethack.sh.orig	2006-08-24 23:23:30.000000000 +0900
+++ sys/unix/nethack.sh	2006-08-24 23:24:35.000000000 +0900
@@ -5,6 +5,7 @@
 export HACKDIR
 HACK=$HACKDIR/nethack
 MAXNROFPLAYERS=20
+COCOT="__PREFIX__/bin/cocot -t UTF-8 -p EUC-JP"
 
 # JP
 # set LC_ALL, NETHACKOPTIONS etc..
@@ -26,6 +27,10 @@
 	export USERFILESEARCHPATH
 fi
 
+if [ "X$LANG" = "Xja_JP.eucJP" ] ; then
+	COCOT=""
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
+		exec $COCOT $HACK "$@"
 		;;
 	*)
-		exec $HACK "$@" $MAXNROFPLAYERS
+		exec $COCOT $HACK "$@" $MAXNROFPLAYERS
 		;;
 esac
