--- disvf.pl.orig	2006-12-08 02:25:18.000000000 +0900
+++ disvf.pl	2006-12-08 02:25:31.000000000 +0900
@@ -1,4 +1,4 @@
-#! /usr/local/bin/perl
+#! /usr/bin/env perl
 
 if ($#ARGV != 0) {
 	print "usage: perl disvf.pl virtualfont\n";
@@ -48,7 +48,7 @@
 		($cc, $_) = unpack('Ca*', $_);
 		$tfm = &get_num($_, 0);
 	}
-	print  "(CHARACTER D $cc\n";
+	printf "(CHARACTER H %X\n", $cc;
 	printf "   (CHARWD R %f)\n", $tfm/(1<<20);
 	print  "   (MAP\n";
 	read(FILE, $dvi, $pl);
@@ -87,7 +87,7 @@
 				($_, $dvi) = unpack("a$cmd a*", $dvi);
 				$k = &get_num($_, 0);
 			}
-			print  "      (SETCHAR D $k)\n";
+			printf "      (SETCHAR H %X)\n",$k;
 		} elsif ($cmd == 132) {			# set_rule
 			($a, $b, $dvi) = unpack('a4a4a*', $dvi);
 			$a = &get_num($a, 1);
@@ -155,4 +155,4 @@
 			print  "      (SPECIAL $_)\n";
 		}
 	}
-}
\ No newline at end of file
+}
