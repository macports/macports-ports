--- runConfigure.sh.old	2006-07-20 14:31:26.000000000 +0900
+++ runConfigure.sh	2006-07-20 14:31:54.000000000 +0900
@@ -8,23 +8,8 @@
 cd Work
 
 # defaults in case we don't find a teTeX installation
-PREFIX=/usr/local/teTeX
-DATADIR=/usr/local/teTeX/share
-
-# try to figure out where the user's TeX is, and complain if we can't find it...
-KPSEWHICH=`which kpsewhich`
-if [ ! -e "${KPSEWHICH}" ]; then
-	echo "### No kpsewhich found -- are you sure you have TeX installed?"
-else
-	PREFIX=`echo ${KPSEWHICH} | sed -e 's!/bin/.*!/!;'`
-	HYPHEN=`kpsewhich hyphen.tex`
-	if [ "${HYPHEN}x" == "x" ]; then
-		echo "### hyphen.tex not found -- are you sure you have teTeX installed?"
-	else
-		DATADIR=`echo ${HYPHEN} | sed -e 's!/texmf.*!/!;'`
-	fi
-fi
-
+PREFIX=__PREFIX
+DATADIR=__PREFIX/share
 
 # run the TeX Live configure script
 echo "### running TeX Live configure script as:"
