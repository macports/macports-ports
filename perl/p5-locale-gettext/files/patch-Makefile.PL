--- Makefile.PL.orig	2015-09-18 12:06:07.000000000 -0500
+++ Makefile.PL	2018-10-30 15:03:00.000000000 -0500
@@ -7,6 +7,18 @@
 } else {
 	$cc = $Config{'cc'};
 }
+my $cflags = '';
+if (defined($ENV{'CFLAGS'})) {
+	$cflags = $ENV{'CFLAGS'};
+}
+my $cppflags = '';
+if (defined($ENV{'CPPFLAGS'})) {
+	$cppflags = $ENV{'CPPFLAGS'};
+}
+my $ldflags = '';
+if (defined($ENV{'LDFLAGS'})) {
+	$ldflags = $ENV{'LDFLAGS'};
+}
 my $libs = '';
 
 unless (conftest("char *x = gettext(\"foo\");", "gettext", 0)) {
@@ -35,6 +47,8 @@
     NAME => "Locale::gettext",
     LIBS => ($libs eq '') ? [] : [$libs],
     VERSION_FROM => 'gettext.pm', 
+    CC => $cc,
+    LD => $cc,
     META_MERGE => {
         resources => {
             repository => 'https://github.com/vandry/Perl-Locale-gettext',
@@ -59,7 +73,7 @@
 	close TEST;
 	open(SAVE, ">&STDERR");
 	open(STDERR, ">/dev/null");
-	system($cc . " -o conftest " . " conftest.c " . $libs);
+	system($cc . " -o conftest " . " conftest.c " . $cflags . " " . $cppflags . " " . $ldflags . " " . $libs);
 	my $exitstatus = $?;
 	open(STDERR, ">&SAVE");
 	if ($exitstatus != 0) {
