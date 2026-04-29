--- siglist_orig.sh	2007-11-05 13:13:30.000000000 -0500
+++ siglist.sh	2007-11-05 18:43:43.000000000 -0500
@@ -24,5 +24,5 @@
 #endif/') > $in
 $CPP $in  > $out
-sed -n 's/{ QwErTy/{/p' < $out | awk '{print NR, $0}' | sort +2n +0n |
+sed -n 's/{ QwErTy/{/p' < $out | awk '{print NR, $0}' | sort -k 3n -k 1 |
     sed 's/^[0-9]* //' |
     awk 'BEGIN { last=0; nsigs=0; }
