--- libraries/Cabal/Distribution/Simple/GHC.hs.sav	2006-11-01 11:27:49.000000000 -0500
+++ libraries/Cabal/Distribution/Simple/GHC.hs	2006-11-01 11:38:09.000000000 -0500
@@ -414,6 +414,11 @@
 installIncludeFiles verbose pkg_descr@PackageDescription{library=Just l} libdir
  = do
    createDirectoryIfMissing True incdir
+
+   -- Hack to make cabal work with packaging systems
+   -- that expect to be able to delete empty directories:
+   writeFile (incdir `joinFileName` ".cabalTurd") ""
+
    incs <- mapM (findInc relincdirs) (installIncludes lbi)
    sequence_ [ copyFileVerbose verbose path (incdir `joinFileName` f)
 	     | (f,path) <- incs ]
