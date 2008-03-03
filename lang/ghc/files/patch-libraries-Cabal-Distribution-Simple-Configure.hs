--- libraries/Cabal/Distribution/Simple/Configure.hs.sav	2008-03-01 17:01:39.000000000 -0500
+++ libraries/Cabal/Distribution/Simple/Configure.hs	2008-03-01 17:04:25.000000000 -0500
@@ -130,7 +130,7 @@
 import qualified System.Info
     ( os, arch )
 import System.IO
-    ( hPutStrLn, stderr )
+    ( hPutStrLn, stderr, openFile, IOMode(..), hGetContents, hClose )
 import Text.PrettyPrint.HughesPJ
     ( comma, punctuate, render, nest, sep )
     
@@ -146,7 +146,9 @@
   let dieMsg = "error reading " ++ filename ++ 
                "; run \"setup configure\" command?\n"
   if (not e) then return $ Left dieMsg else do 
-    str <- readFile filename
+    hdl <- openFile filename ReadMode
+    str <- hGetContents hdl >>= \s -> last s `seq` return s
+    hClose hdl
     case reads str of
       [(bi,_)] -> return $ Right bi
       _        -> return $ Left  dieMsg
