# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup         haskell_cabal 1.0
#
# This PortGroup configures the build to use the Haskell Cabal tool. It
# modifies the defaults for a number of variables, so your Portfile should take
# care not to accidentally overwrite them.
#
# The PortGroup will automatically add the required build dependencies for
# port:cabal.
#
# The configure, build, destroot and test phases are set up (although the test
# phase is not enabled automatically). A default livecheck is configured to
# hackage.haskell.org using ${name}.
#
# This PortGroup offers the following options:
#
# haskell_cabal.bin
#   The cabal binary. Defaults to ${prefix}/bin/cabal.
#
# haskell_cabal.cabal_root
#   The root path for cabal. Defaults to ${workpath}/.home/.cabal .

proc haskell_cabal.add_dependencies {} {
    global name
    if { ${name} ne "cabal" } {
        depends_build-append \
            port:cabal \
            port:ghc
    }
}
port::register_callback haskell_cabal.add_dependencies

options haskell_cabal.cabal_root
default haskell_cabal.cabal_root {${workpath}/.home/.cabal}

post-extract {
    xinstall -m 0755 -d [option haskell_cabal.cabal_root]
    set cabal_config_fd [open ${haskell_cabal.cabal_root}/config w+]
    set cabal_versions [regexp -all -inline {[0-9.]+} [exec ${haskell_cabal.bin} --version]]
    set cabal_install_version [lindex ${cabal_versions} 0]
    set cabal_library_version [lindex ${cabal_versions} end]
    foreach line [list \
                      "-- This is the configuration file for the 'cabal' command line tool." \
                      "--" \
                      "-- The available configuration options are listed below." \
                      "-- Some of them have default values listed." \
                      "--" \
                      "-- Lines (like this one) beginning with '--' are comments." \
                      "-- Be careful with spaces and indentation because they are" \
                      "-- used to indicate layout for nested sections." \
                      "--" \
                      "-- This config file was generated using the following versions" \
                      "-- of Cabal and cabal-install:" \
                      "-- Cabal library version: ${cabal_library_version}" \
                      "-- cabal-install version: ${cabal_install_version}" \
                      "" \
                      "" \
                      "-- cabal default configuration settings (MacPorts modified):" \
                      "repository hackage.haskell.org" \
                      "  url: https://hackage.haskell.org/" \
                      "  secure: True" \
                      "" \
                      "remote-repo-cache: ${haskell_cabal.cabal_root}/packages" \
                      "world-file: ${haskell_cabal.cabal_root}/world" \
                      "extra-prog-path: ${haskell_cabal.cabal_root}/bin" \
                      "build-summary: ${haskell_cabal.cabal_root}/logs/build.log" \
                      "remote-build-reporting: none" \
                      "jobs: \$ncpus" \
                      "documentation: True" \
                      "doc-index-file: \$htmldir/html/${name}/index.html" \
                      "relocatable: True" \
                      "install-method: copy" \
                      "installdir: ${prefix}/bin" \
                      "" \
                      "install-dirs global" \
                      "  prefix: ${prefix}" \
                      "  bindir: ${prefix}/bin" \
                      "  libdir: ${prefix}/lib" \
                      "  libsubdir: ${name}" \
                      "  dynlibdir: ${prefix}/lib" \
                      "  libexecdir: ${prefix}/libexec" \
                      "  libexecsubdir: ${name}" \
                      "  datadir: ${prefix}/share/${name}" \
                      "  docdir: ${prefix}/share/doc/${name}" \
                      "  htmldir: ${prefix}/share/doc/${name}" \
                      "  haddockdir: \$htmldir" \
                      "  sysconfdir: ${prefix}/etc/${name}" \
                      "" \
                      "program-locations" \
                      "  gcc-location: ${configure.cc}" \
                     ] {
        puts ${cabal_config_fd} ${line}
    }
    close ${cabal_config_fd}
}

# cabal builds x86_64 binaries on both arm64 and x86_64 architectures
supported_archs     arm64 x86_64

# libHSbase shipped with GHC links against system libiconv, which provides the
# 'iconv' symbol, but not the 'libiconv' symbol. Because the compilation
# process statically links libHSbase.a, we must have /usr/lib in the library
# search path first :/
compiler.library_path
compiler.cpath

options haskell_cabal.bin haskell_cabal.env

default haskell_cabal.bin ${prefix}/bin/cabal

default haskell_cabal.env \
    {CABAL_CONFIG=[option haskell_cabal.cabal_root]/config}

pre-configure {
    system -W ${worksrcpath} \
        "env ${haskell_cabal.env} ${haskell_cabal.bin} new-update"
}

default configure.cmd       {${haskell_cabal.bin}}
default configure.pre_args  {}
default configure.args      {new-configure}
default configure.env       {${haskell_cabal.env}}

default build.cmd           {${haskell_cabal.bin}}
default build.target        {new-build}
default build.env           {${haskell_cabal.env}}

default destroot.env        {${haskell_cabal.env}}

default test.cmd            {${haskell_cabal.bin}}
default test.target         {new-test}
default test.env            {${haskell_cabal.env}}

# destroot: Avoid recompilation with a call to new-install

destroot {
    # install binary
    set cabal_build ${worksrcpath}/dist-newstyle/build
    fs-traverse f ${cabal_build} {
        if { [file isdirectory ${f}]
            && [file tail ${f}] eq "${name}-${version}" } {
            set cabal_build ${f}
            break
        }
    }
    fs-traverse f ${cabal_build} {
        if { [file isfile ${f}]
            && [file executable ${f}]
            && [file tail ${f}] eq "${name}"
            && [file tail [file dirname ${f}]] eq "${name}" } {
            xinstall -m 0755 ${f} ${destroot}${prefix}/bin/${name}
        }
    }

    # install documentation
    if { [file isdirectory ${cabal_build}/doc] } {
        xinstall -d ${destroot}${prefix}/share/doc/${name}
        fs-traverse f_or_d ${cabal_build}/doc {
            set subpath [strsed ${f_or_d} "s|${cabal_build}/doc||"]
            if { ${subpath} ne "" } {
                if { [file isdirectory ${f_or_d}] } {
                    xinstall -d \
                        ${destroot}${prefix}/share/doc/${name}${subpath}
                } elseif { [file isfile ${f_or_d}] } {
                    xinstall -m 0644 ${f_or_d} \
                        ${destroot}${prefix}/share/doc/${name}${subpath}
                }
            }
        }
    }

    # install cabal data-files
    if { [file exists ${worksrcpath}/data]
        && [file isdirectory ${worksrcpath}/data] } {
        xinstall -d ${destroot}${prefix}/share/${name}
        foreach f_or_d [glob -nocomplain ${worksrcpath}/data/*] {
            if { [file isfile ${f_or_d}] } {
                xinstall -m 0644 ${f_or_d} ${destroot}${prefix}/share/${name}
            } elseif { [file isdirectory ${f_or_d}] } {
                copy ${f_or_d} ${destroot}${prefix}/share/${name}
            }
        }
    }
}

default livecheck.type      {regex}
default livecheck.url       {https://hackage.haskell.org/package/${name}}
default livecheck.regex     {"/package/[quotemeta ${name}]-\\\[^/\\\]+/[quotemeta ${name}]-(\\\[^\\\"\\\]+)[quotemeta ${extract.suffix}]"}


# Default cabal configuration file with available options

# -- This is the configuration file for the 'cabal' command line tool.
# --
# -- The available configuration options are listed below.
# -- Some of them have default values listed.
# --
# -- Lines (like this one) beginning with '--' are comments.
# -- Be careful with spaces and indentation because they are
# -- used to indicate layout for nested sections.
# --
# -- This config file was generated using the following versions
# -- of Cabal and cabal-install:
# -- Cabal library version: 3.4.0.0
# -- cabal-install version: 3.4.0.0
# 
# 
# repository hackage.haskell.org
#   url: http://hackage.haskell.org/
#   -- secure: True
#   -- root-keys:
#   -- key-threshold: 3
# 
# -- default-user-config:
# -- ignore-expiry: False
# -- http-transport:
# -- nix: False
# -- local-no-index-repo:
# remote-repo-cache: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/packages
# -- logs-dir: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/logs
# world-file: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/world
# -- store-dir:
# -- active-repositories:
# -- verbose: 1
# -- compiler: ghc
# -- cabal-file:
# -- with-compiler:
# -- with-hc-pkg:
# -- program-prefix: 
# -- program-suffix: 
# -- library-vanilla: True
# -- library-profiling:
# -- shared:
# -- static:
# -- executable-dynamic: False
# -- executable-static: False
# -- profiling:
# -- executable-profiling:
# -- profiling-detail:
# -- library-profiling-detail:
# -- optimization: True
# -- debug-info: False
# -- library-for-ghci:
# -- split-sections: False
# -- split-objs: False
# -- executable-stripping:
# -- library-stripping:
# -- configure-option:
# -- user-install: True
# -- package-db:
# -- flags:
# -- extra-include-dirs:
# -- deterministic:
# -- cid:
# -- extra-lib-dirs:
# -- extra-framework-dirs:
# extra-prog-path: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/bin
# -- instantiate-with:
# -- tests: False
# -- coverage: False
# -- library-coverage:
# -- exact-configuration: False
# -- benchmarks: False
# -- relocatable: False
# -- response-files:
# -- allow-depending-on-private-libs:
# -- cabal-lib-version:
# -- constraint:
# -- preference:
# -- solver: modular
# -- allow-older: False
# -- allow-newer: False
# -- write-ghc-environment-files:
# -- documentation: False
# -- doc-index-file: $datadir/doc/$arch-$os-$compiler/index.html
# -- target-package-db:
# -- max-backjumps: 4000
# -- reorder-goals: False
# -- count-conflicts: True
# -- fine-grained-conflicts: True
# -- minimize-conflict-set: False
# -- independent-goals: False
# -- shadow-installed-packages: False
# -- strong-flags: False
# -- allow-boot-library-installs: False
# -- reject-unconstrained-dependencies: none
# -- reinstall: False
# -- avoid-reinstalls: False
# -- force-reinstalls: False
# -- upgrade-dependencies: False
# -- index-state:
# -- root-cmd:
# -- symlink-bindir:
# build-summary: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/logs/build.log
# -- build-log:
# remote-build-reporting: none
# -- report-planning-failure: False
# -- per-component: True
# -- one-shot: False
# -- run-tests:
# jobs: $ncpus
# -- keep-going: False
# -- offline: False
# -- lib: False
# -- package-env:
# -- overwrite-policy:
# -- install-method:
# installdir: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal/bin
# -- username:
# -- password:
# -- password-command:
# -- builddir:
# 
# haddock
#   -- keep-temp-files: False
#   -- hoogle: False
#   -- html: False
#   -- html-location:
#   -- executables: False
#   -- tests: False
#   -- benchmarks: False
#   -- foreign-libraries: False
#   -- all:
#   -- internal: False
#   -- css:
#   -- hyperlink-source: False
#   -- quickjump: False
#   -- hscolour-css:
#   -- contents-location:
# 
# init
#   -- interactive: False
#   -- cabal-version: 2.4
#   -- license:
#   -- tests:
#   -- test-dir:
#   -- language: Haskell2010
#   -- application-dir: app
#   -- source-dir: src
# 
# install-dirs user
#   -- prefix: /opt/local/var/macports/build/_opt_local_ports_textproc_pandoc/pandoc/work/.home/.cabal
#   -- bindir: $prefix/bin
#   -- libdir: $prefix/lib
#   -- libsubdir: $abi/$libname
#   -- dynlibdir: $libdir/$abi
#   -- libexecdir: $prefix/libexec
#   -- libexecsubdir: $abi/$pkgid
#   -- datadir: $prefix/share
#   -- datasubdir: $abi/$pkgid
#   -- docdir: $datadir/doc/$abi/$pkgid
#   -- htmldir: $docdir/html
#   -- haddockdir: $htmldir
#   -- sysconfdir: $prefix/etc
# 
# install-dirs global
#   -- prefix: /usr/local
#   -- bindir: $prefix/bin
#   -- libdir: $prefix/lib
#   -- libsubdir: $abi/$libname
#   -- dynlibdir: $libdir/$abi
#   -- libexecdir: $prefix/libexec
#   -- libexecsubdir: $abi/$pkgid
#   -- datadir: $prefix/share
#   -- datasubdir: $abi/$pkgid
#   -- docdir: $datadir/doc/$abi/$pkgid
#   -- htmldir: $docdir/html
#   -- haddockdir: $htmldir
#   -- sysconfdir: $prefix/etc
# 
# program-locations
#   -- alex-location:
#   -- ar-location:
#   -- c2hs-location:
#   -- cpphs-location:
#   -- doctest-location:
#   -- gcc-location:
#   -- ghc-location:
#   -- ghc-pkg-location:
#   -- ghcjs-location:
#   -- ghcjs-pkg-location:
#   -- greencard-location:
#   -- haddock-location:
#   -- happy-location:
#   -- haskell-suite-location:
#   -- haskell-suite-pkg-location:
#   -- hmake-location:
#   -- hpc-location:
#   -- hsc2hs-location:
#   -- hscolour-location:
#   -- jhc-location:
#   -- ld-location:
#   -- pkg-config-location:
#   -- runghc-location:
#   -- strip-location:
#   -- tar-location:
#   -- uhc-location:
# 
# program-default-options
#   -- alex-options:
#   -- ar-options:
#   -- c2hs-options:
#   -- cpphs-options:
#   -- doctest-options:
#   -- gcc-options:
#   -- ghc-options:
#   -- ghc-pkg-options:
#   -- ghcjs-options:
#   -- ghcjs-pkg-options:
#   -- greencard-options:
#   -- haddock-options:
#   -- happy-options:
#   -- haskell-suite-options:
#   -- haskell-suite-pkg-options:
#   -- hmake-options:
#   -- hpc-options:
#   -- hsc2hs-options:
#   -- hscolour-options:
#   -- jhc-options:
#   -- ld-options:
#   -- pkg-config-options:
#   -- runghc-options:
#   -- strip-options:
#   -- tar-options:
#   -- uhc-options:
