--- happy/src/LALR.lhs.sav	2006-12-28 21:26:32.000000000 -0500
+++ happy/src/LALR.lhs	2006-12-28 21:27:36.000000000 -0500
@@ -21,7 +21,7 @@
 
 > import Control.Monad.ST
 > import Data.Array.ST
-> import Data.Array hiding (bounds)
+> import Data.Array
 > import Data.List (nub)
 
 #elif defined(__GLASGOW_HASKELL__)
