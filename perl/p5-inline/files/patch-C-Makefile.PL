--- C/Makefile.PL.orig	2010-01-27 03:03:44.000000000 -0800
+++ C/Makefile.PL	2010-09-29 09:48:46.000000000 -0700
@@ -5,7 +5,7 @@
 
 my ($cc, $exe) = @Config{'cc', '_exe'};
 $cc =~ s/\s+-.+$//; #remove possible trailing options
-my $comp = (split /\./, $cc)[0];
+my $comp = $cc;
 
 my $found = 0;
 my $delim = $Config::Config{path_sep};
