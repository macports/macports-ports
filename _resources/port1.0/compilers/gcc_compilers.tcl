# add all working GCC compilers to the variable compilers based on ${os.major}

# https://trac.macports.org/ticket/57135
# https://trac.macports.org/ticket/61636

# GCC 15 and GCC 14 on all systems
lappend compilers macports-gcc-15 macports-gcc-14

# GCC 11 to GCC 13 on OSX10.6+
if {${os.major} >= 10 || [option os.platform] ne "darwin"} {
    lappend compilers macports-gcc-13 macports-gcc-12 macports-gcc-11
}

# GCC 10 on all systems
lappend compilers macports-gcc-10

# GCC 8 and 9 and older on OSX 10.6 to 10.10
# GCC 7 or older on OSX 10.6 or older
# https://trac.macports.org/ticket/65472
if {${os.major} < 15} {
    if {${os.major} >= 10} {
        lappend compilers macports-gcc-9 macports-gcc-8
    }
    lappend compilers macports-gcc-7 macports-gcc-6 macports-gcc-5
}

if {${os.major} >= 10} {
    lappend compilers macports-gcc-devel
}
