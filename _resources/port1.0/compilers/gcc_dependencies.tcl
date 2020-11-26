# set library dependencies of  GCC compilers to the variable libgccs based on gcc_version

# compiler links against libraries in libgcc\d* and/or libgcc-devel
if {[vercmp ${gcc_version} 4.6] < 0} {
    set libgccs "path:share/doc/libgcc/README:libgcc port:libgcc45"
} elseif {[vercmp ${gcc_version} 7] < 0} {
    set libgccs "path:share/doc/libgcc/README:libgcc port:libgcc6"
} else {
    set libgccs "path:share/doc/libgcc/README:libgcc port:libgcc${gcc_version}"
}
