# $Id$
#
# This file contains the defaults for gnome.

if {${livecheck.name} eq "default"} {
    set livecheck.name ${name}
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://ftp.gnome.org/pub/gnome/${livecheck.name}/"
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "\"LATEST-IS-(.*)\""]
}
set livecheck.type "regex"
