# add all working Clang compilers to the variable compilers based on ${os.major}
# (with optional hints for when to use them based on e.g. compiler.cxx_standard)

# When adding a new clang version here, make sure to update the
# clang_dependency PortGroup, and add it to any new dependencies of the
# new version.

# MacPorts >= 2.13 changes the expected return format and sets use_hints
# to indicate it
if {![info exists use_hints]} {
    global os.platform configure.build_arch
    
    # clang is useless on Darwin / PowerPC, let disable it globally
    if {${os.platform} eq "darwin" && ${configure.build_arch} in [list ppc ppc64]} {
        return
    }
    # anonymous proc to filter the compiler list according to the hints
    # (handled by base in 2.13+)
    set filter_proc [list compilers {
        global compiler.cxx_standard configure.build_arch
        lmap c $compilers {
            set excluded 0
            foreach hint [lrange $c 1 end] {
                if {$hint ne {} && ![expr $hint]} {
                    set excluded 1
                    break
                }
            }
            if {$excluded} {
                continue
            }
            lindex $c 0
        }
    }]

    global portconfigure::clang_compilers_cached
    if {[info exists clang_compilers_cached]} {
        set compilers [apply $filter_proc $clang_compilers_cached]
        return
    }
}

# Clang 17+ only available on newer Darwin versions
if {${os.major} >= 17 || ${os.platform} ne "darwin"} {
    # For now limit exposure of clang-18+ to macOS13+ due to issues like
    # https://github.com/macports/macports-ports/pull/21051
    # https://trac.macports.org/ticket/68640
    if {${os.major} >= 22 || ${os.platform} ne "darwin"} {
        # Expose clang-21+ to ports needing the newest standards
        set hint [expr {${os.major} >= 25 || ${os.platform} ne "darwin" ? {} : {${compiler.cxx_standard} >= 2020}}]
        lappend compilers [list macports-clang-22 $hint] \
                          [list macports-clang-21 $hint]
        set hint [expr {${os.platform} ne "darwin" ? {} : {${compiler.cxx_standard} >= 2014}}]
        lappend compilers [list macports-clang-20 $hint] \
                          [list macports-clang-19 $hint]
        # Always allow clang-18 on macOS15+, otherwise if c++11 or newer is required
        set hint [expr {${os.platform} ne "darwin" || ${os.major} >= 24 ? {} : {${compiler.cxx_standard} >= 2011}}]
        lappend compilers [list macports-clang-18 $hint]
    }
    lappend compilers macports-clang-17
}

if {(${os.major} >= 10 && ${os.major} < 25) || ${os.platform} ne "darwin"} {
    # On Darwin10 only use selection here if c++20+ required
    set hint [expr {${os.platform} ne "darwin" || ${os.major} >= 11 ? {} : {${compiler.cxx_standard} >= 2020}}]
    lappend compilers [list macports-clang-16 $hint] \
                      [list macports-clang-15 $hint] \
                      [list macports-clang-14 $hint] \
                      [list macports-clang-13 $hint]
    if {${os.major} < 23 || ${os.platform} ne "darwin"} {
        # https://trac.macports.org/ticket/68257
        # Versions of clang older than clang-13 probably have build issues on
        # macOS14+. Until resolved do not append to fallback list.
        # Unlikely they will ever really be needed here though.
        lappend compilers [list macports-clang-12 $hint]
    }
}

if {${os.platform} eq "darwin"} {
    if {${os.major} <= 23} {
        lappend compilers macports-clang-11
        set hint {${configure.build_arch} ne "arm64"}
        lappend compilers [list macports-clang-10 $hint] \
                          [list macports-clang-9.0 $hint]
    }
    if {${os.major} < 20} {
        lappend compilers macports-clang-8.0 macports-clang-7.0 macports-clang-6.0 macports-clang-5.0
    }
    if {${os.major} < 16} {
        # The Sierra SDK requires a toolchain that supports class properties
        lappend compilers macports-clang-3.7 macports-clang-3.4
    }
}

if {![info exists use_hints]} {
    set clang_compilers_cached $compilers
    set compilers [apply $filter_proc $compilers]
}
