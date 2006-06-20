--- Setup.hs.sav	2006-06-20 10:54:54.000000000 -0400
+++ Setup.hs	2006-06-20 10:55:06.000000000 -0400
@@ -7,6 +7,7 @@
 -- for the argument types of the `postInst' hook
 import Distribution.Setup
 import Distribution.Simple.LocalBuildInfo
+import Distribution.PackageDescription
 
 main = defaultMainWithHooks defaultUserHooks {postInst = addWrapperAndLib}
 
@@ -16,7 +17,14 @@
 -- * We need to do this via a shell script that has been munged by ./configure,
 --   as Cabal doesn't give us enough info (eg, no package name and version) to
 --   do it all in Haskell.
+-- !FIXME not true anymore since GHC 6.4.2, but if we change that now, we
+--  can't use the installation procedure on earlier GHC's anymore.
 --
-addWrapperAndLib :: Args -> InstallFlags -> LocalBuildInfo -> IO ExitCode
-addWrapperAndLib _ _ _ =
+addWrapperAndLib :: Args 
+		 -> InstallFlags 
+		 -> PackageDescription  -- remove line for GHC 6.4.1 & earlier!
+		 -> LocalBuildInfo 
+		 -> IO ExitCode
+addWrapperAndLib _ _ _ _ =
+              --     ^remove this one underscore for GHC 6.4.1 & earlier!
   system "./postInst.sh"
