# add all working Clang compilers to the variable compilers based on ${os.major}

# does Clang work on all i386 and x86_64 systems?
# according to https://packages.macports.org/clang-7.0/,
#    clang builds back to Mac OS X 10.6
lappend compilers macports-clang-8.0
lappend compilers macports-clang-7.0
lappend compilers macports-clang-6.0
lappend compilers macports-clang-5.0
if {${os.major} < 16} {
    # The Sierra SDK requires a toolchain that supports class properties
    lappend compilers macports-clang-3.7
    lappend compilers macports-clang-3.4
    if {${os.major} < 9} {
	lappend compilers macports-clang-3.3
    }
}
