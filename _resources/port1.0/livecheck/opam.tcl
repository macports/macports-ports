# This file contains the livecheck defaults for opam (OCaml Package Manager).

if {${livecheck.name} eq "default"} {
	# Strip 'ocaml-' prefix by default
    livecheck.name [regsub {^(?:ocaml-)?(.*)} ${subport} {\1}]
}
if {!$has_homepage || ${livecheck.url} eq ${homepage}} {
    livecheck.url \
            https://opam.ocaml.org/packages/${livecheck.name}/
}
if {${livecheck.regex} eq ""} {
	livecheck.regex {<span class="package-version">([^<]+)</span>[[:space:]]*\(latest\)}
}
set livecheck.type "regexm"
