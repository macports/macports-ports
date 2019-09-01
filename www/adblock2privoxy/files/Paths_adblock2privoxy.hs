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
module Paths_adblock2privoxy (
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
version = Version [2,0,1] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "@PREFIX@/bin"
libdir     = "@PREFIX@/lib/adblock2privoxy"
dynlibdir  = "@PREFIX@/lib/adblock2privoxy"
datadir    = "@PREFIX@/share/adblock2privoxy"
libexecdir = "@PREFIX@/lib/adblock2privoxy"
sysconfdir = "@PREFIX@/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "adblock2privoxy_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "adblock2privoxy_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "adblock2privoxy_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "adblock2privoxy_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "adblock2privoxy_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "adblock2privoxy_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
