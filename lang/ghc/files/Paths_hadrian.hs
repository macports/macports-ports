{- Cabal data-files hardcoded path in binary fix.

This file replaces the Paths_*.hs automatically created by cabal.

See:
* https://github.com/commercialhaskell/stack/issues/848
* https://github.com/commercialhaskell/stack/issues/4857
* https://github.com/haskell/cabal/issues/462
* https://github.com/haskell/cabal/issues/3586

-}

{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_hadrian (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "@PREFIX@/bin"
libdir     = "@PREFIX@/lib/@NAME@"
dynlibdir  = "@PREFIX@/lib/@NAME@"
datadir    = "@PREFIX@/share/@NAME@"
libexecdir = "@PREFIX@/lib/@NAME@"
sysconfdir = "@PREFIX@/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "hadrian_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "hadrian_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "hadrian_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "hadrian_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "hadrian_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "hadrian_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
