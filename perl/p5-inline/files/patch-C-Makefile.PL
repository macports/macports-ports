--- C/Makefile.PL.orig	2007-04-03 11:22:47.000000000 -0700
+++ C/Makefile.PL	2007-04-03 11:33:06.000000000 -0700
@@ -5,6 +5,7 @@
 
 my ($cc, $exe) = @Config{'cc', '_exe'};
 $cc =~ s/\s+-.+$//; #remove possible trailing options
+(undef, undef, $cc) = File::Spec->splitpath($cc); # we only want the compiler filename
 
 my $found = 0;
 my $delim = $^O eq 'MSWin32' ? ';' : ':';
