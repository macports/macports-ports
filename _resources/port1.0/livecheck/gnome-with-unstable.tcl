# This file contains the defaults for gnome.

if {${livecheck.name} eq "default"} {
    set livecheck.name ${name}
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://ftp.gnome.org/pub/GNOME/sources/${livecheck.name}/cache.json"
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex {LATEST-IS-(\\d+\\.\\d*[0-9](?:\\.\\d+)*)}
}
set livecheck.type "regex"
