# add all working GCC compilers to the variable compilers based on ${os.major}

# see https://trac.macports.org/ticket/57135
if { ${os.major} >= 11 } {
    lappend compilers macports-gcc-9
}
if { ${os.major} >= 10 } {
    lappend compilers macports-gcc-8
}
lappend compilers macports-gcc-7 \
                  macports-gcc-6 \
                  macports-gcc-5
