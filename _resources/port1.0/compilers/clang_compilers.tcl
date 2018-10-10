# add all working Clang compilers to the variable compilers based on ${os.major}

# does Clang work on all i386 and x86_64 systems?
# according to https://packages.macports.org/clang-7.0/,
#    clang builds back to Mac OS X 10.6
lappend compilers macports-clang-7.0
lappend compilers macports-clang-6.0
lappend compilers macports-clang-5.0
if {${os.major} < 18} {
    # see https://github.com/macports/macports-ports/commit/d387f4e4a47b298b1775ea8bf61772e2c2e6cd8b
    lappend compilers macports-clang-4.0
    if {${os.major} < 17} {
	# The High Sierra SDK requires a toolchain that can apply nullability to uuid_t
	lappend compilers macports-clang-3.9
	if {${os.major} < 16} {
	    # The Sierra SDK requires a toolchain that supports class properties
	    lappend compilers macports-clang-3.7
	    lappend compilers macports-clang-3.4
	    if {${os.major} < 9} {
		lappend compilers macports-clang-3.3
	    }
	}
    }
}
