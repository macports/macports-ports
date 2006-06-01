--- 1check-archive.sh~	2006-05-29 14:56:25.000000000 +0900
+++ 1check-archive.sh	2006-06-01 09:53:44.000000000 +0900
@@ -71,14 +71,14 @@
 
 if test "$1" != "notetex"; then
     if test ! -f $SRC_DIR/tetex-src-$TETEX_VER.tar.gz \
-	 -o ! -f $SRC_DIR/tetex-texmf-$TEXMF_VER.tar.gz; then
+	 -o ! -f $SRC_DIR/tetex-texmf-${TEXMF_VER}po.tar.gz; then
 	cat <<EOF
 
 Please get "tetex-src-$TETEX_VER.tar.gz" and
-           "tetex-texmf-$TEXMF_VER.tar.gz" by following commands.
+           "tetex-texmf-${TEXMF_VER}po.tar.gz" by following commands.
 cd $SRC_DIR
 wget http://www.ring.gr.jp/pub/text/CTAN/systems/unix/teTeX/3.0/distrib/tetex-src-$TETEX_VER.tar.gz
-wget http://www.ring.gr.jp/pub/text/CTAN/systems/unix/teTeX/3.0/distrib/tetex-texmf-$TEXMF_VER.tar.gz
+wget http://www.ring.gr.jp/pub/text/CTAN/systems/unix/teTeX/3.0/distrib/tetex-texmf-${TEXMF_VER}po.tar.gz
 
 EOF
 	exit 1
@@ -88,7 +88,7 @@
 EOF
     fi
     if test -z "$TEXMFDIST"; then $MD5CHECK <<EOF || exit
-11aa15c8d3e28ee7815e0d5fcdf43fd4  $SRC_DIR/tetex-texmf-$TEXMF_VER.tar.gz
+ed9d30d9162d16ac8d5065cde6e0f6fa  $SRC_DIR/tetex-texmf-${TEXMF_VER}po.tar.gz
 EOF
     fi
 fi
