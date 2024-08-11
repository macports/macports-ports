# add all working Clang compilers to the variable compilers based on ${os.major}
# (and temporarily compiler.cxx_standard)

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, and add it to any new dependencies of the
# new version.

global os.platform compiler.cxx_standard

# clang is useless on Darwin / PowerPC, let disable it globally
if {${os.platform} eq "darwin" && [option configure.build_arch] in [list ppc ppc64]} {
    return
}

# Clang 17+ (currently) only available on Darwin11 and newer
if {${os.major} >= 11 || ${os.platform} ne "darwin"} {
    if {${os.major} >= 22 || ${os.platform} ne "darwin"} {
        # For now limit exposure of clang-18+ to macOS13+ due to issues like
        # https://github.com/macports/macports-ports/pull/21051
        # https://trac.macports.org/ticket/68640
        if {${compiler.cxx_standard} >= 2017} {
            # Limit clang 18 to c++17 or newer
            lappend compilers macports-clang-18
        }
    }
    if {${compiler.cxx_standard} >= 2011} {
        # Limit clang 17 to c++11 or newer
        lappend compilers macports-clang-17
    }
}

if {${os.major} >= 10 || ${os.platform} ne "darwin"} {
    # On Darwin10 only use selection here if c++20+ required
    if { ${os.platform} ne "darwin" || ${os.major} >= 11 || ${compiler.cxx_standard} >= 2020 } {
        lappend compilers macports-clang-16 \
                          macports-clang-15 \
                          macports-clang-14
        if {${os.major} < 23 || ${os.platform} ne "darwin"} {
            # https://trac.macports.org/ticket/68257
            # Versions of clang older than clang-14 probably have build issues on
            # macOS14+. Until resolved do not append to fallback list.
            # Unlikely they will ever really be needed here though.
            lappend compilers macports-clang-13 macports-clang-12
        }
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
