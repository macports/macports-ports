--- IO/Dumper.pm.orig	Fri Jan 17 01:27:26 2003
+++ IO/Dumper.pm	Thu May 20 18:24:41 2004
@@ -395,7 +395,7 @@
 sub PDL::IO::Dumper::uudecode_PDL {
     my $lines = shift;
     my $out;
-    my $fname = "/tmp/tmp-$$.fits";
+    my $fname = "tmp-pdl_io_dumper-$$.fits";
     if($PDL::IO::Dumper::uudecode_ok) {
 	open(FITS,"|uudecode");
 	$lines =~ s/^[^\n]*\n/begin 664 $fname\n/o;
@@ -458,9 +458,9 @@
     else { 
       
       ##
-      ## Write FITS file, uuencode it, snarf it up, and clean up /tmp
+      ## Write FITS file, uuencode it, snarf it up, and clean up tmpfiles
       ##
-      my($fname) = "/tmp/$$.fits";
+      my($fname) = "tmp-pdl_io_dumper-$$.fits";
       wfits($_,$fname);
       my(@uulines);
 
