--- colordiff.pl.org	2006-03-22 18:02:26.000000000 -0800
+++ colordiff.pl	2006-03-22 18:03:26.000000000 -0800
@@ -153,7 +153,7 @@
     }
     # Context diffs are the only flavour having '***'
     # at the start of a line
-    elsif ($record =~ /\*\*\*/) {
+    elsif ($record =~ /^\*\*\*/) {
         $diff_type = 'diffc';
     }
     # Plain diffs have NcN, NdN and NaN etc.
