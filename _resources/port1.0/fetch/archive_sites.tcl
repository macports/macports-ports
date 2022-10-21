namespace eval portfetch::mirror_sites { }

# Keep these in sync between archive_sites.tcl and mirror_sites.tcl.
# Some servers only support http; others support https while allowing
# http as a fallback; still others only allow https.
# As of the September 30, 2021 expiration of DST Root CA X3, the set of
# macOS versions able to use the bundled libcurl to access our servers
# that use Let's Encrypt certificates is drastically reduced.
# Some servers that support https haven't added the MacPorts hostnames
# to their SSL certificate as Subject Alternative Names so we can't use
# https with them yet.
global os.platform os.major
set letsencrypt_https_or_http   [expr {${os.platform} ne "darwin" || ${os.major} == 16 || ${os.major} > 18 ? "https" : "http"}]
set letsencrypt_https_only      [expr {${os.platform} ne "darwin" || ${os.major} == 16 || ${os.major} > 18 ? "https" : ""}]
set fastly      ${letsencrypt_https_or_http}
# cert doesn't have macports.org SANs; admin notified
#set aarnet.au   ${letsencrypt_https_or_http}
set aarnet.au   http
set atl.us      http
set cph.dk      ${letsencrypt_https_or_http}
set cjj.kr      http
set ema.uk      ${letsencrypt_https_or_http}
# cert doesn't have macports.org SANs; admin notified
#set fco.it      ${letsencrypt_https_or_http}
set fco.it      http
set fra.de      ${letsencrypt_https_or_http}
set jnb.za      ${letsencrypt_https_only}
set jog.id      http
set kmq.jp      ${letsencrypt_https_or_http}
set mse.uk      ${letsencrypt_https_or_http}
set nue.de      ${letsencrypt_https_or_http}
set pek.cn      ${letsencrypt_https_or_http}
# cert doesn't have macports.org SANs; admin notified
#set ykf.ca      ${letsencrypt_https_or_http}
set ykf.ca      http
set ywg.ca      ${letsencrypt_https_or_http}

# Keep the primary packages server first in the list
set portfetch::mirror_sites::sites(macports_archives) [lsearch -all -glob -inline -not "
    ${fastly}://packages.macports.org/:nosubdir
    ${nue.de}://nue.de.packages.macports.org/:nosubdir
    ${atl.us}://atl.us.packages.macports.org/:nosubdir
    ${cph.dk}://cph.dk.packages.macports.org/:nosubdir
    ${ema.uk}://ema.uk.packages.macports.org/:nosubdir
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
