--- install.sh.orig	Fri Oct 24 22:52:31 2003
+++ install.sh	Fri Oct 24 22:52:08 2003
@@ -73,17 +73,16 @@
 $usethisperl -p install.pl cowsay > $PREFIX/bin/cowsay
 chmod a+x $PREFIX/bin/cowsay
 ln -s cowsay $PREFIX/bin/cowthink
-mkdir -p $PREFIX/man/man1 || ($mkdir $PREFIX; mkdir $PREFIX/man; mkdir $PREFIX/man/man1)
-$usethisperl -p install.pl cowsay.1 > $PREFIX/man/man1/cowsay.1
-chmod a+r $PREFIX/man/man1/cowsay.1
-ln -s cowsay.1 $PREFIX/man/man1/cowthink.1
-mkdir -p $PREFIX/share/cows || (mkdir $PREFIX; mkdir $PREFIX/share; mkdir $PREFIX/share/cows)
-tar -cf - $filelist | (cd $PREFIX/share && tar -xvf -)
+$usethisperl -p install.pl cowsay.1 > $PREFIX/share/man/man1/cowsay.1
+chmod a+r $PREFIX/share/man/man1/cowsay.1
+ln -s cowsay.1 $PREFIX/share/man/man1/cowthink.1
+mkdir -p $PREFIX/share/cowsay/cows || (mkdir $PREFIX; mkdir $PREFIX/share; mkdir $PREFIX/share/cowsay; mkdir $PREFIX/share/cowsay/cows)
+tar -cf - $filelist | (cd $PREFIX/share/cowsay && tar -xvf -)
 set +x
 
 echo Okay, let us see if the install actually worked.
 
-if [ ! -f $PREFIX/share/cows/default.cow ]; then
+if [ ! -f $PREFIX/share/cowsay/cows/default.cow ]; then
     echo The default cow file did not make it across!
     echo Ooops, it failed...sorry!
     exit 1
