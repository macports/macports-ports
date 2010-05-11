# $Id$
#
# This file contains the defaults for googlecode.

if {$has_homepage && ${livecheck.name} eq "default"
    && ([regexp {^http://code.google.com/p/([^/]+)} $homepage _ tag]
        || [regexp {^http://(.*).googlecode.com} $homepage _ tag])} {
        set livecheck.name $tag
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://code.google.com/p/${livecheck.name}/downloads/list"
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname [regsub ***=[quotemeta ${livecheck.version}] [quotemeta [file tail [lindex ${distfiles} 0]]] (.*)]
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "location\.href='http://[quotemeta ${livecheck.name}].googlecode.com/files/${livecheck.distname}'"]
}
set livecheck.type "regex"
