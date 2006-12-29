--- happy/tests/bogus-token.y.sav	2006-12-28 23:02:09.000000000 -0500
+++ happy/tests/bogus-token.y	2006-12-28 23:02:40.000000000 -0500
@@ -1,6 +1,6 @@
 {
 module Main where
-import Exception
+import Control.Exception
 }
 
 %tokentype { Token }
@@ -16,7 +16,7 @@
 data Token = A | B
 
 test1 = parse [B]
-main =  do Exception.tryJust errorCalls (print test1 >> fail "Test failed.")
+main =  do Control.Exception.tryJust errorCalls (print test1 >> fail "Test failed.")
            putStrLn "Test worked"
 
 happyError = error "parse error"
