# add all working GCC compilers to the variable compilers based on ${os.major}

# https://trac.macports.org/ticket/57135
# https://trac.macports.org/ticket/61636

global os.major os.arch

if { ${os.major} >= 10 } {
    lappend compilers macports-gcc-11 macports-gcc-10
}

if { ${os.arch} ne "arm" } {
    if { ${os.major} >= 10 } {
        lappend compilers macports-gcc-9 macports-gcc-8
    }
    if { ${os.major} < 20 } {
        lappend compilers macports-gcc-7 macports-gcc-6 macports-gcc-5
    }
}

if { ${os.major} >= 11 } {
    lappend compilers macports-gcc-devel
}
