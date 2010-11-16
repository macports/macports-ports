# $Id$
#
# This file contains the defaults for sourceforge.

if {${livecheck.name} eq "default"} {
    if {$has_homepage && [regexp {^http://([^.]+)\.(?:sf|sourceforge)\.net\y} $homepage _ tag]} {
        set livecheck.name $tag
    } elseif {$has_homepage && [regexp {^http://(?:sf|sourceforge)\.net/projects/([^/]+)\y} $homepage _ tag]} {
        set livecheck.name $tag
    } else {
        set livecheck.name ${name}
    }
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://sourceforge.net/api/file/index/project-name/${livecheck.name}/rss"
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname ${livecheck.name}
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "/[quotemeta ${livecheck.distname}]/(\[a-zA-Z0-9.\]+\\.\[a-zA-Z0-9.\]+)/"]
}
set livecheck.type "regex"
