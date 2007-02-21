--- c2hs/c/CLexer.hs.sav	2007-02-19 06:07:54.000000000 -0500
+++ c2hs/c/CLexer.hs	2007-02-19 06:08:25.000000000 -0500
@@ -13,7 +13,7 @@
 import Idents    (Ident, lexemeToIdent, identToLexeme)
 
 import Data.Set  (Set)
-import qualified Data.Set as Set (mkSet, addToSet, elementOf)
+import qualified Data.Set as Set (fromList, insert, member)
 
 
 #if __GLASGOW_HASKELL__ >= 603
@@ -413,7 +413,7 @@
   name <- getNewName
   tdefs <- getTypedefs
   let ident = lexemeToIdent pos cs name
-  if ident `Set.elementOf` tdefs
+  if ident `Set.member` tdefs
     then return (CTokTyIdent pos ident)
     else return (CTokIdent   pos ident)
 
@@ -526,7 +526,7 @@
 	  alex_inp = input,
 	  alex_last = interr "CLexer.execParser: Touched undefined token!",
 	  alex_names = names,
-	  alex_tdefs = Set.mkSet builtins
+	  alex_tdefs = Set.fromList builtins
         }
 
 {-# INLINE returnP #-}
@@ -571,7 +571,7 @@
 
 addTypedef :: Ident -> P ()
 addTypedef ident = (P $ \s@PState{alex_tdefs=tdefs} ->
-                             POk s{alex_tdefs = tdefs `Set.addToSet` ident} ())
+                             POk s{alex_tdefs = ident `Set.insert` tdefs} ())
 
 getInput :: P AlexInput
 getInput = P $ \s@PState{alex_pos=p, alex_inp=i} -> POk s (p,i)
