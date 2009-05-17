# $Id$
#
# This file contains the defaults for gnu.

if {$has_homepage && [regexp {^http://www.gnu.org/software/([^/]+)} $homepage _ tag] &&
    ${livecheck.name} eq "default"} {
        set livecheck.name $tag
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
set livecheck.check "regex"
