--- libraries/hpc/Setup.hs.sav	2007-12-17 16:43:33.000000000 -0500
+++ libraries/hpc/Setup.hs	2007-12-17 16:43:56.000000000 -0500
@@ -3,4 +3,4 @@
 import Distribution.Simple
 
 main :: IO ()
-main = defaultMain
+main = defaultMainWithHooks defaultUserHooks
