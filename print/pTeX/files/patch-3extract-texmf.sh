--- 3extract-texmf.sh~	2006-04-15 16:25:16.000000000 +0900
+++ 3extract-texmf.sh	2006-06-01 09:51:36.000000000 +0900
@@ -22,7 +22,7 @@
 ## start
 if test -z "$TEXMFDIST"; then
     shouldnotexist $TEXMF-dist
-    tarx $SRC_DIR/tetex-texmf-$TEXMF_VER.tar.gz $TEXMF-dist
+    tarx $SRC_DIR/tetex-texmf-${TEXMF_VER}po.tar.gz $TEXMF-dist
 # for RPM (don't depend on 'eval')
     chmod -x $TEXMF-dist/scripts/*/*.pl || exit
 fi
