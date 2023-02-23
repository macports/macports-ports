# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup provides support for building R packages.
#
# Usage:
# PortGroup         R 1.0

PortGroup           active_variants 1.1
PortGroup           compiler_blacklist_versions 1.0
PortGroup           compilers 1.0

# For packages from CRAN and Bioconductor R.author can be set to anything;
# it is desirable however to use GitHub/GitLab author in this field, if available.
options             R.domain R.author R.package R.tag_prefix R.tag_suffix

proc R.setup {domain author package version {R_tag_prefix ""} {R_tag_suffix ""}} {
    global          R.domain R.author R.package R.tag_prefix R.tag_suffix
    R.domain        ${domain}
    R.author        ${author}
    R.package       ${package}
    version         ${version}

    switch ${R.domain} {
        github {
            uplevel "PortGroup github 1.0"
            github.setup ${R.author} ${R.package} ${version} ${R_tag_prefix} ${R_tag_suffix}
        }
        gitlab {
            uplevel "PortGroup gitlab 1.0"
            gitlab.setup ${R.author} ${R.package} ${version} ${R_tag_prefix} ${R_tag_suffix}
        }
        cran {
            homepage        https://cran.r-project.org/package=${R.package}
            master_sites    https://cran.r-project.org/src/contrib \
                            https://cran.r-project.org/src/contrib/Archive/${R.package}
            distname        ${R.package}_${version}
            worksrcdir      ${R.package}
            livecheck.type  regex
            livecheck.regex [quotemeta ${R.package}]_(\[0-9.\]+).tar.gz
        }
        bioconductor {
            homepage        https://bioconductor.org/packages/${R.package}
            master_sites    https://www.bioconductor.org/packages/release/bioc/src/contrib/
            distname        ${R.package}_${version}
            worksrcdir      ${R.package}
            livecheck.type  regex
            livecheck.regex [quotemeta ${R.package}]_(\[0-9.\]+).tar.gz
        }
    }
}

option_proc R.package R.set_package
proc R.set_package {opt action args} {
    global          R.package
    if {$action eq "set"} {
        name        R-${R.package}
    }
}

default categories          "R science"

# For w/e reason universal is presently disabled for R in Macports.
default universal_variant   no

compiler.cxx_standard       2011

# Avoid Apple clangs:
compiler.blacklist-append   {clang}

port::register_callback R.add_dependencies

proc R.add_dependencies {} {
    global              configure.compiler
    if {[string match macports-clang-* ${configure.compiler}]} {
        set clang_v [
            string range ${configure.compiler} [
                string length macports-clang-
            ] end
        ]
        depends_build-delete \
                        port:clang-${clang_v}
        depends_build-append \
                        port:clang-${clang_v}
    } elseif {[string match macports-gcc-* ${configure.compiler}]} {
        set gcc_v [
            string range ${configure.compiler} [
                string length macports-gcc-
            ] end
        ]
        depends_build-delete \
                        port:gcc${gcc_v}
        depends_build-append \
                        port:gcc${gcc_v}
    }
    depends_build-append \
                        port:R
    depends_run-append  port:R
}
# R installs few basic packages as recommended, and those are needed for some other packages.
require_active_variants R recommended

# General fixes for PPC:
global build_arch os.platform
if {${os.platform} eq "darwin" && (${build_arch} in [list ppc ppc64])} {
    # Avoid multiple malloc errors. See: https://github.com/iains/darwin-toolchains-start-here/discussions/20
    configure.env-append \
                    DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
    configure.cmd-prepend \
                    DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
    destroot.env-append \
                    DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
    destroot.cmd-prepend \
                    DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
    # With supported_archs set to noarch, Macports wants Clang on 10.6, even when build is for PPC.
    # Fix this nonsense, until Clang is fixed.
    compiler.blacklist-append *clang*
}

global prefix frameworks_dir
# Please update R version here:
set Rversion        4.2.2
set branch          [join [lrange [split ${Rversion} .] 0 1] .]
set packages        ${frameworks_dir}/R.framework/Versions/${branch}/Resources/library
set suffix          .tar.gz
set r.cmd           ${prefix}/bin/R

# Get rid of unrecognized args:
configure.pre_args-delete \
                    --prefix=${prefix}
# Oddly, build does not build binaries but merely produces a tarball.
# It does by default try to produce documentation, however, which introduces extra dependencies.
configure.cmd       ${r.cmd} CMD build .

configure.post_args --no-manual --no-build-vignettes

# We build in destroot.
build { }

global package version
pre-destroot {
    xinstall -d -m 0755 ${destroot}${packages}
    move ${worksrcpath}/${R.package}_${version}${suffix} ${destroot}${packages}
}

destroot.cmd        ${r.cmd} CMD INSTALL .

destroot.post_args --library=${destroot}${packages}
destroot.target

post-destroot {
    delete ${destroot}${packages}/${R.package}_${version}${suffix}
}

# Default can be changed once the majority of packages implement testing:
default test.run    no

test {
    system -W ${worksrcpath} "${r.cmd} CMD check ./${R.package}_${version}${suffix}"
}
