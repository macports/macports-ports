--- Makefile.PL.orig	2015-10-30 15:37:20.000000000 -0700
+++ Makefile.PL	2015-10-30 15:38:56.000000000 -0700
@@ -7,6 +7,10 @@
 } else {
 	$cc = $Config{'cc'};
 }
+my $cflags = '';
+if (defined($ENV{'CFLAGS'})) {
+       $cflags = $ENV{'CFLAGS'};
+}
 my $libs = '';
 
 unless (conftest("char *x = gettext(\"foo\");", "gettext", 0)) {
@@ -35,6 +39,8 @@
     NAME => "Locale::gettext",
     LIBS => ($libs eq '') ? [] : [$libs],
     VERSION_FROM => 'gettext.pm', 
+    CC => $cc,
+    LD => $cc,
     META_MERGE => {
         resources => {
             repository => 'https://github.com/vandry/Perl-Locale-gettext',
