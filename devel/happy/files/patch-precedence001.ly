--- happy/tests/precedence001.ly.sav	2006-12-28 22:48:09.000000000 -0500
+++ happy/tests/precedence001.ly	2006-12-28 22:55:34.000000000 -0500
@@ -3,7 +3,7 @@
 > {
 > module Main where
 > import IO
-> import Exception
+> import Control.Exception
 > }
 > 
 > %name parse
@@ -54,8 +54,8 @@
 generated with GHC extensions, -gac.)
 
 > main = do
->   Exception.tryJust errorCalls (print test1 >> fail "Test failed.") 
->   Exception.tryJust errorCalls (print test2 >> fail "Test failed.") 
->   Exception.tryJust errorCalls (print test3 >> fail "Test failed.")
+>   Control.Exception.tryJust errorCalls (print test1 >> fail "Test failed.") 
+>   Control.Exception.tryJust errorCalls (print test2 >> fail "Test failed.") 
+>   Control.Exception.tryJust errorCalls (print test3 >> fail "Test failed.")
 
 > }
