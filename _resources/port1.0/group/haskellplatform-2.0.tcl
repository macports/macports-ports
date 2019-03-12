# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup                 haskell-platform 2.0
# haskellplatform.setup     haskell_package version [register_scripts]
# where haskell_package is the name of the package (eg, digest), version is
# the version for it. This automatically defines version, categories,
# homepage, master_sites, distname, and depends_build as appropriate, and
# sets up the configure, build, destroot, and post-activate stages.
# register_scripts can be used to deactivate package registration with
# haskell's package database and might be needed for non-library parts of the
# haskell platform. Set it to "no" to achieve this; defaults to "yes".
#
# This uses the haskell 1.0 PortGroup internally.

PortGroup       haskell 1.0

proc haskellplatform.setup {package version {register_scripts "yes"}} {
    haskell.setup   ${package} ${version} ghc ${register_scripts} haskell-platform
}
