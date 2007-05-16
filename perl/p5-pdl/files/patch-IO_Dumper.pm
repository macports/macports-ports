--- IO/Dumper.pm.org	2006-03-14 15:19:11.000000000 -0800
+++ IO/Dumper.pm	2007-05-16 13:32:37.000000000 -0700
@@ -404,7 +404,7 @@
 #
 sub _make_tmpname () {
     # should we use File::Spec routines to create the file name?
-    return $PDL::Config{TEMPDIR} . "/tmp-$$.fits";
+    return $PDL::Config{TEMPDIR} . "/tmp/tmp-$$.fits";
 }
 
 # For uudecode_PDL:
