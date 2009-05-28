# $Id$
#
# This file contains the defaults for gnome.

if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://ftp.gnome.org/pub/gnome/${livecheck.name}"
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "\"LATEST-IS-(.*)\""]
}
set livecheck.type "regex"
