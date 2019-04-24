# add all working GCC compilers to the variable compilers based on ${os.major}

if { ${os.major} >= 10 } {
    # see https://trac.macports.org/ticket/57135
    lappend compilers macports-gcc-8
}
lappend compilers macports-gcc-7
lappend compilers macports-gcc-6
lappend compilers macports-gcc-5
