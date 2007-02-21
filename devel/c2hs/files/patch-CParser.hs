--- c2hs/c/CParser.hs.sav	2007-02-19 06:17:04.000000000 -0500
+++ c2hs/c/CParser.hs	2007-02-19 06:18:17.000000000 -0500
@@ -5,7 +5,7 @@
 import Maybe      (catMaybes)
 
 import Common     (Position, Pos(..), nopos)
-import Data.Set	  (Set, mkSet, union, elementOf)
+import Data.Set	  (Set, fromList, union, member)
 import Utils      (Tag(tag))
 import UNames     (Name, NameSupply, names)
 import Idents     (Ident)
