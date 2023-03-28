# add all working Clang compilers to the variable compilers based on ${os.major}
# (and temporarily compiler.cxx_standard)

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, and add it to any new dependencies of the
# new version.

global os.major os.platform

if {${os.major} >= 11 || ${os.platform} ne "darwin"} {
    lappend compilers macports-clang-15 \
                      macports-clang-14 \
                      macports-clang-13 \
                      macports-clang-12
    # add latest to end of list for a while for testing
    lappend compilers macports-clang-16
}

if {${os.major} >= 10} {
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
