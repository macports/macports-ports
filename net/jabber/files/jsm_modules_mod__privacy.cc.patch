--- jsm/modules/mod_privacy.cc.orig	2007-04-07 19:43:18 UTC
+++ jsm/modules/mod_privacy.cc
@@ -1165,7 +1165,7 @@ static mreturn mod_privacy_out_iq_set_li
 	list_items++;
     }
 
-    if (new_items <= 0) {
+    if (new_items == NULL) {
 	log_debug2(ZONE, LOGT_EXECFLOW, "This is a deletion request");
     }
 
