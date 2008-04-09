--- hints/darwin.sh.orig	Tue May 25 14:52:21 2004
+++ hints/darwin.sh	Tue Jan 25 20:40:55 2005
@@ -224,6 +224,10 @@
 # really need ODBM_FIle, though, so let's just hint ODBM away.
 i_dbm=undef;
 
+# When the bind9 port is installed, its libbind includes dups from
+# /usr/lib/libdl, so remove libbind
+libswanted=`echo $libswanted | sed 's/ bind / /'`
+
 ##
 # Build process
 ##
