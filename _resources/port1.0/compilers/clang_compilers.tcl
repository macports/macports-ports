# add all working Clang compilers to the variable compilers based on ${os.major}
# (and temporarily compiler.cxx_standard)

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, and add it to any new dependencies of the
# new version.

# clang 11  and older build on 10.6+  (darwin 10)
# clang 7.0 and older build on 10.5+  (darwin 9)
# clang 3.4 and older build on 10.4+  (darwin 8)
# Clang 11 and newer only on Apple Silicon
# Clang 9.0 and newer only on 11+ (Darwin 20)

global os.major os.platform

if {${os.major} >= 11 || ${os.platform} ne "darwin"} {
    # For now, limit to ports requiring c++14 or newer to reduce exposure
    # to the newest compiler. To be relaxed at some later date.
    if {[option compiler.cxx_standard] >= 2014} {
        lappend compilers macports-clang-15
    }
    lappend compilers macports-clang-14 \
                      macports-clang-13 \
                      macports-clang-12
    # clang 16 only available (for now) on 10.10 and newer
    # add to end of list for a while for testing
    if {${os.major} >= 14} {
        lappend compilers macports-clang-16
    }
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
