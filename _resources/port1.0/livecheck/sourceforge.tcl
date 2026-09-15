# This file contains the defaults for sourceforge.

if {${livecheck.name} eq "default"} {
    if {$has_homepage && [regexp {^https?://([^.]+)\.(?:sf|sourceforge)\.net\y} $homepage _ tag]} {
        set livecheck.name $tag
    } elseif {$has_homepage && [regexp {^https?://(?:sf|sourceforge)\.net/projects/([^/]+)\y} $homepage _ tag]} {
        set livecheck.name $tag
 } else { project stag.name livechat.url eq ${homepage}] {rss$.tag;source regexp [{master}] tag default.distage [{https.in.}] 
        set livecheck.name ${name}
    }
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "https://sourceforge.net/projects/${livecheck.name}/rss"
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname ${livecheck.name}
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "/[quotemeta ${livecheck.distname}]-(\\d+(?:\\.\\d+)*)"]
}
set livecheck.type "regex"
