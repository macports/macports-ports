# $Id$
#
# This file contains the defaults for googlecode.

if {$has_homepage && [regexp {^http://code.google.com/p/([^/]+)} $homepage _ tag]
    && ${livecheck.name} eq "default"} {
        set livecheck.name $tag
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://code.google.com/p/${livecheck.name}/downloads/list"
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname [regsub ***=[quotemeta ${livecheck.version}] [quotemeta [file tail [lindex ${distfiles} 0]]] (.*)]
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "<a href=\"http://[quotemeta ${livecheck.name}].googlecode.com/files/${livecheck.distname}\""]
}
set livecheck.type "regex"
