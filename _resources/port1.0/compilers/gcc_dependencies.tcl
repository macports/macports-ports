# set library dependencies of  GCC compilers to the variable libgccs based on gcc_version

# compiler links against libraries in libgcc\d* and/or libgcc-devel
if {[vercmp ${gcc_version} 4.6] < 0} {
    set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc7 port:libgcc6 port:libgcc45"
} elseif {[vercmp ${gcc_version} 7] < 0} {
    set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc7 port:libgcc6"
} elseif {[vercmp ${gcc_version} 8] < 0} {
    set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc7"
} else {
    set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc"
}
