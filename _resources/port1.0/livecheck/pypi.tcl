# $Id$
#
# This file contains the livecheck defaults for PyPI.

if {${livecheck.name} eq "default"} {
    if {[exists python.rootname]} {
        livecheck.name [option python.rootname]
    } else {
        livecheck.name ${name}
    }
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    livecheck.url \
            https://pypi.python.org/pypi?:action=doap&name=${livecheck.name}
}
if {${livecheck.regex} eq ""} {
    livecheck.regex {<revision>(.+)</revision>}
}
set livecheck.type "regex"
