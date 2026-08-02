--- docs/hashlike.rd.orig	2011-04-06 19:35:39 UTC
+++ docs/hashlike.rd
@@ -342,7 +342,6 @@ These are the common methods for ((|BDB:
 --- each(set = nil, bulk = 0, "flags" => 0) { |key, value| ... }
 --- each_pair(set = nil, bulk = 0) { |key, value| ... }
     Iterates over associations.
-
     ((<set>)) ((<bulk>))
 
 --- each_by_prefix(prefix) {|key, value| ... }
@@ -360,7 +359,6 @@ These are the common methods for ((|BDB:
 
 --- each_key(set = nil, bulk = 0) { |key| ... }
     Iterates over keys. 
-
     ((<set>)) ((<bulk>))
 
 --- each_primary(set = nil) { |skey, pkey, pvalue| ... }
@@ -369,7 +367,6 @@ These are the common methods for ((|BDB:
 
 --- each_value(set = nil, bulk = 0) { |value| ... }
     Iterates over values. 
-
     ((<set>)) ((<bulk>))
 
 --- empty?() 
