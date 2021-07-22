namespace eval portfetch::mirror_sites { }

# Keep these in sync between archive_sites.tcl and mirror_sites.tcl.
# Some servers only support http; others support https while allowing
# http as a fallback; still others only allow https.
# The servers that support https have varying sets of cipher suites
# enabled, which gives them varying minimum macOS version requirements.
# Some servers that support https haven't added the MacPorts hostnames
# to their SSL certificate as Subject Alternative Names so we can't use
# https with them yet.
global os.platform os.major
set fastly      [expr {${os.platform} eq "darwin" && ${os.major} < 13 ? "http" : "https"}]
# cert doesn't have macports.org SANs; admin notified
#set aarnet.au   [expr {${os.platform} eq "darwin" && ${os.major} < 13 ? "http" : "https"}]
set aarnet.au   http
set atl.us      http
set cph.dk      [expr {${os.platform} eq "darwin" && ${os.major} < 13 ? "http" : "https"}]
set cjj.kr      http
# cert doesn't have macports.org SANs; admin notified
#set fco.it      [expr {${os.platform} eq "darwin" && ${os.major} < 13 ? "http" : "https"}]
set fco.it      http
set fra.de      [expr {${os.platform} eq "darwin" && ${os.major} < 13 ? "http" : "https"}]
set jnb.za      [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "" : "https"}]
set jog.id      http
set kmq.jp      [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]
set mse.uk      [expr {${os.platform} eq "darwin" && ${os.major} < 13 ? "http" : "https"}]
set nue.de      [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]
set pek.cn      [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]
# cert doesn't have macports.org SANs; admin notified
#set ykf.ca      [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]
set ykf.ca      http
set ywg.ca      [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]

# Keep the primary packages server first in the list
set portfetch::mirror_sites::sites(macports_archives) [lsearch -all -glob -inline -not "
    ${fastly}://packages.macports.org/:nosubdir
    ${nue.de}://nue.de.packages.macports.org/:nosubdir
    ${atl.us}://atl.us.packages.macports.org/:nosubdir
    ${cph.dk}://cph.dk.packages.macports.org/:nosubdir
    ${fco.it}://fco.it.packages.macports.org/:nosubdir
    ${fra.de}://fra.de.packages.macports.org/:nosubdir
    ${jnb.za}://jnb.za.packages.macports.org/packages/:nosubdir
    ${jog.id}://jog.id.packages.macports.org/macports/packages/:nosubdir
    ${kmq.jp}://kmq.jp.packages.macports.org/:nosubdir
    ${mse.uk}://mse.uk.packages.macports.org/:nosubdir
    ${pek.cn}://pek.cn.packages.macports.org/macports/packages/:nosubdir
    ${ywg.ca}://ywg.ca.packages.macports.org/mirror/macports/packages/:nosubdir
" {:*}]

set portfetch::mirror_sites::archive_type(macports_archives) tbz2
set portfetch::mirror_sites::archive_prefix(macports_archives) /opt/local
set portfetch::mirror_sites::archive_frameworks_dir(macports_archives) /opt/local/Library/Frameworks
set portfetch::mirror_sites::archive_applications_dir(macports_archives) /Applications/MacPorts
if {${os.platform} eq "darwin" && ${os.major} >= 10} {
    set portfetch::mirror_sites::archive_cxx_stdlib(macports_archives) libc++
} else {
    set portfetch::mirror_sites::archive_cxx_stdlib(macports_archives) libstdc++
}
if {${os.platform} eq "darwin" && ${os.major} <= 12} {
    set portfetch::mirror_sites::archive_delete_la_files(macports_archives) no
} else {
    set portfetch::mirror_sites::archive_delete_la_files(macports_archives) yes
}
