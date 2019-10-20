# add all working Clang compilers to the variable compilers based on ${os.major}

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, add it to any new dependencies of the
# new version, and update the blacklisting in the other clang ports.

# no macports clang compilers are available for PowerPC
# macports-clang-9.0 and less are available for darwin10+
# macports-clang-7.0 and less are available for darwin9+
# macports-clang-3.4 and less are available for darwin8+

platform darwin i386 {

    if {${os.major} >= 10} {
        lappend compilers macports-clang-9.0 \
                          macports-clang-8.0
    }

    if {${os.major} >= 9} {
        lappend compilers macports-clang-7.0 \
                          macports-clang-6.0 \
                          macports-clang-5.0
    }

    if {${os.major} < 16} {
    # The Sierra SDK requires a toolchain that supports class properties
        if {${os.major} >= 9} {
            lappend compilers macports-clang-3.7
        }
        if {${os.major} >= 8} {
            lappend compilers macports-clang-3.4
        }
        if {${os.major} == 8} {
            lappend compilers macports-clang-3.3
        }
    }
}
