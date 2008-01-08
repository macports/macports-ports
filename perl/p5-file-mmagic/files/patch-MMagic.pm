--- MMagic.pm.orig	2006-05-22 22:55:27.000000000 -0700
+++ MMagic.pm	2007-09-10 10:57:21.000000000 -0700
@@ -764,6 +764,11 @@
     # this saves time otherwise wasted parsing unused subtests.
     if (@$item == 3){
         my $tmp = readMagicLine(@$item);
+	if (!defined($tmp)) {
+		# $tmp could be undef if we ran into troubles while reading
+		#  the entry.
+		return;
+	}
         @$item = @$tmp;
     }
 
