# This file contains the livecheck defaults for using port's master_sites.

set livecheck.type "regex"

if {${livecheck.name} eq "default"} {
    set livecheck.name ${name}
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname ${livecheck.name}
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    if {!$has_master_sites || [llength ${master_sites}] == 0} {
        set livecheck.type "none"
    } else {
        set livecheck.url [lindex ${master_sites} 0]
    }
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "[quotemeta ${livecheck.distname}]-(\\d+(?:\\.\\d+)*)"]
}
