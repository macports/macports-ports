# add all working Clang compilers to the variable compilers based on ${os.major}
# (and temporarily compiler.cxx_standard)

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, and add it to any new dependencies of the
# new version.

global os.platform

# clang is useless on Darwin / PowerPC, let disable it globally
if {${os.platform} eq "darwin" && [option configure.build_arch] in [list ppc ppc64]} {
    return
}

if {${os.major} >= 11 || ${os.platform} ne "darwin"} {
    if {[option compiler.cxx_standard] >= 2014 && ${os.major} >= 22} {
        # For now limit exposure of clang-17 to ports needing c++14 or newer
        # and only on macOS13 or newer due to issues like
        # https://github.com/macports/macports-ports/pull/21051
        # https://trac.macports.org/ticket/68640
        lappend compilers macports-clang-17
    }
    lappend compilers macports-clang-16 \
                      macports-clang-15 \
                      macports-clang-14
    if {${os.major} < 23 || ${os.platform} ne "darwin"} {
        # https://trac.macports.org/ticket/68257
        # Versions of clang older than clang-14 probably have build issues on
        # macOS14+. Until resolved do not append to fallback list.
        lappend compilers macports-clang-13 \
                          macports-clang-12
    }
}

if {${os.platform} eq "darwin"} {

    if {${os.major} >= 9} {
        lappend compilers macports-clang-11
        if {[option build_arch] ne "arm64"} {
            lappend compilers macports-clang-10 macports-clang-9.0
            if {${os.major} < 20} {
                lappend compilers macports-clang-8.0
            }
        }
    }

    if {${os.major} >= 9 && ${os.major} < 20} {
        lappend compilers macports-clang-7.0 \
            macports-clang-6.0 \
            macports-clang-5.0
    }

    if {${os.major} < 16} {
        # The Sierra SDK requires a toolchain that supports class properties
        if {${os.major} >= 9} {
            lappend compilers macports-clang-3.7
        }
        lappend compilers macports-clang-3.4
        if {${os.major} < 9} {
            lappend compilers macports-clang-3.3
        }
    }

}
