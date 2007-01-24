--- Makefile.PL.orig	Sat Oct 18 12:27:13 2003
+++ Makefile.PL	Sat Oct 18 12:28:18 2003
@@ -6,22 +6,23 @@
     import SpeedyMake qw(%write_makefile_common);
 }
 
-print <<END;
-
-Optional mod_speedycgi support.
-
-Mod_speedycgi increases performance under Apache by avoiding the fork/exec
-overhead associated with each request under normal SpeedyCGI.  However, it
-requires a working copy of "apxs" in your path, Apache with mod_so
-support, and additional Apache configuration.
-
-END
-print "Compile mod_speedycgi (default no)? ";
+#print <<END;
+#
+#Optional mod_speedycgi support.
+#
+#Mod_speedycgi increases performance under Apache by avoiding the fork/exec
+#overhead associated with each request under normal SpeedyCGI.  However, it
+#requires a working copy of "apxs" in your path, Apache with mod_so
+#support, and additional Apache configuration.
+#
+#END
+#print "Compile mod_speedycgi (default no)? ";
 
 my @dirs = qw(src speedy_backend speedy);
 my $macro = $write_makefile_common{macro};
 my $apache_module = 0;
-if (<STDIN> =~ /y/i) {
+#if (<STDIN> =~ /y/i) {
+unless ($ENV{WITHOUT_APACHE}) {
     die "ERROR: Command 'apxs -q CC' failed.\n"
 	unless $macro->{APACHE_APXS_WORKS};
     print "Compiling for Apache version $macro->{APACHE_VERSION}\n";
