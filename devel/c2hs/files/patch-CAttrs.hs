--- c2hs/c/CAttrs.hs.sav	Tue May 11 10:36:59 2004
+++ c2hs/c/CAttrs.hs	Tue May 11 10:37:08 2004
@@ -144,7 +144,7 @@
 --
 leaveObjRangeC    :: AttrC -> AttrC
 leaveObjRangeC ac  = ac {
-		       defObjsAC = fst . leaveRange . defObjsAC $ ac,
+		       defObjsAC = fst . leaveRange . defObjsAC $ ac
 		     }
 
 -- add another definitions to the object name space (EXPORTED)
