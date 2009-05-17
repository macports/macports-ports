# $Id$
#
# This file contains the defaults for sourceforge.

if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    set livecheck.url "http://sourceforge.net/export/rss2_projfiles.php?project=${livecheck.name}"
}
if {${livecheck.distname} eq "default"} {
    set livecheck.distname ${livecheck.name}
}
if {${livecheck.regex} eq ""} {
    set livecheck.regex [list "(?i)<title>[quotemeta ${livecheck.distname}] (.*) released.*</title>"]
}
set livecheck.check "regex"
