# $Id$
#
# This file contains the defaults for freshmeat.

if {${livecheck.name} eq "default"} {
    set livecheck.name ${name}
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname ${livecheck.name}
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://freshmeat.net/projects/${livecheck.name}/releases.atom"
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "(?i)<title>[quotemeta ${livecheck.distname}] (.*)</title>"]
}
set livecheck.type "regex"
