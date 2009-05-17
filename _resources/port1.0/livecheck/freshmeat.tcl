# $Id$
#
# This file contains the defaults for freshmeat.

if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://freshmeat.net/projects/${livecheck.name}/releases.atom"
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "(?i)<title>${livecheck.name} (.*)</title>"]
}
set livecheck.check "regex"
