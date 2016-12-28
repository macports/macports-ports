# This file contains the defaults for gnu.

if {${livecheck.name} eq "default"} {
    if {$has_homepage && [regexp {^http://www.gnu.org/software/([^/]+)} $homepage _ tag]} {
        set livecheck.name $tag
    } else {
        set livecheck.name ${name}
    }
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://ftp.gnu.org/gnu/${livecheck.name}/?C=M&O=D"
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname ${livecheck.name}
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "[quotemeta ${livecheck.distname}]-(\\d+(?:\\.\\d+)*)"]
}
set livecheck.type "regex"
