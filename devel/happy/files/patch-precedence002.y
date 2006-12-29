--- happy/tests/precedence002.y.sav	2006-12-28 22:59:03.000000000 -0500
+++ happy/tests/precedence002.y	2006-12-28 22:59:29.000000000 -0500
@@ -3,7 +3,7 @@
 {
 module Main where
 import IO
-import Exception
+import Control.Exception
 }
 
 %name parse
