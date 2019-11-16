# add all working Clang compilers to the variable compilers based on ${os.major}

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, and add it to any new dependencies of the
# new version.

# clang 9.0 and older build on 10.6+ (darwin 10)
# clang 7.0 and older build on 10.5+ (darwin 9)
# clang 3.4 and older build on 10.4+ (darwin 8)
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
    lappend compilers macports-clang-3.4
    if {${os.major} < 9} {
        lappend compilers macports-clang-3.3
    }
}
