--- gettext-1.05/Makefile.PL.orig	2005-01-31 10:30:22.000000000 +1100
+++ gettext-1.05/Makefile.PL	2012-10-03 15:45:12.000000000 +1000
@@ -7,6 +7,10 @@
 } else {
 	$cc = $Config{'cc'};
 }
+my $cflags = '';
+if (defined($ENV{'CFLAGS'})) {
+	$cflags = $ENV{'CFLAGS'};
+}
 my $libs = '';
 
 unless (conftest("char *x = gettext(\"foo\");", "gettext", 0)) {
@@ -35,6 +39,8 @@
     NAME => "Locale::gettext",
     LIBS => ($libs eq '') ? [] : [$libs],
     VERSION_FROM => 'gettext.pm', 
+    CC => $cc,
+    LD => $cc,
 );
 
 sub conftest {
@@ -50,7 +56,7 @@
 	close TEST;
 	open(SAVE, ">&STDERR");
 	open(STDERR, ">/dev/null");
-	system($cc . " -o conftest " . $libs . " conftest.c");
+	system($cc . " " . $cflags  . " -o conftest " . $libs . " conftest.c");
 	my $exitstatus = $?;
 	open(STDERR, ">&SAVE");
 	if ($exitstatus != 0) {
