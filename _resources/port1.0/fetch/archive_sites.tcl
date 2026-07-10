namespace eval ::portfetch::mirror_sites {

variable sites

# Keep these in sync between archive_sites.tcl and mirror_sites.tcl.
# Some servers only support http; others support https while allowing
# http as a fallback; still others only allow https.
# As of the September 30, 2021 expiration of DST Root CA X3, the set of
# macOS versions able to use the bundled libcurl to access our servers
# that use Let's Encrypt certificates is drastically reduced.
# Some servers that support https haven't added the MacPorts hostnames
# to their SSL certificate as Subject Alternative Names so we can't use
# https with them yet.
namespace upvar :: os.platform os.platform
namespace upvar :: os.major os.major
variable letsencrypt_https_or_http   [expr {${os.platform} ne "darwin" || ${os.major} == 16 || ${os.major} > 18 ? "https" : "http"}]
variable letsencrypt_https_only      [expr {${os.platform} ne "darwin" || ${os.major} == 16 || ${os.major} > 18 ? "https" : ""}]
variable fastly      ${letsencrypt_https_or_http}
# cert doesn't have macports.org SANs; admin notified
#variable aarnet.au   ${letsencrypt_https_or_http}
variable aarnet.au   http
variable atl.us      http
variable bos.us      ${letsencrypt_https_or_http}
variable cph.dk      ${letsencrypt_https_or_http}
variable cjj.kr      http
# cert doesn't have macports.org SANs; admin notified
#variable fco.it      ${letsencrypt_https_or_http}
variable fco.it      http
variable fra.de      ${letsencrypt_https_or_http}
variable jog.id      http
variable kmq.jp      ${letsencrypt_https_or_http}
variable mse.uk      ${letsencrypt_https_or_http}
variable nue.de      ${letsencrypt_https_or_http}
variable pek.cn      ${letsencrypt_https_or_http}
variable vie.at      ${letsencrypt_https_or_http}
# cert doesn't have macports.org SANs; admin notified
#variable ykf.ca      ${letsencrypt_https_or_http}
variable ykf.ca      http
variable fcix.net    http
variable sjtu.edu.cn ${letsencrypt_https_only}

# Keep the primary packages server first in the list
set sites(macports_archives) [lsearch -all -glob -inline -not "
    ${fastly}://packages.macports.org/:nosubdir
    ${nue.de}://nue.de.packages.macports.org/:nosubdir
    ${fcix.net}://mirror.fcix.net/macports/packages/:nosubdir
    ${aarnet.au}://aarnet.au.packages.macports.org/macports-archives/:nosubdir
    ${atl.us}://atl.us.packages.macports.org/:nosubdir
    ${bos.us}://bos.us.packages.macports.org/:nosubdir
    ${cph.dk}://cph.dk.packages.macports.org/:nosubdir
    ${fco.it}://fco.it.packages.macports.org/:nosubdir
    ${fra.de}://fra.de.packages.macports.org/:nosubdir
    ${jog.id}://jog.id.packages.macports.org/macports/packages/:nosubdir
    ${kmq.jp}://kmq.jp.packages.macports.org/:nosubdir
    ${mse.uk}://mse.uk.packages.macports.org/:nosubdir
    ${pek.cn}://pek.cn.packages.macports.org/macports/packages/:nosubdir
    ${sjtu.edu.cn}://mirror.sjtu.edu.cn/macports/packages/:nosubdir
    ${vie.at}://vie.at.packages.macports.org/:nosubdir
" {:*}]

variable archive_type
set archive_type(macports_archives) tbz2
variable archive_prefix
set archive_prefix(macports_archives) /opt/local
variable archive_frameworks_dir
set archive_frameworks_dir(macports_archives) /opt/local/Library/Frameworks
variable archive_applications_dir
set archive_applications_dir(macports_archives) /Applications/MacPorts
variable archive_cxx_stdlib
if {${os.platform} eq "darwin" && ${os.major} >= 10} {
    set archive_cxx_stdlib(macports_archives) libc++
} else {
    set archive_cxx_stdlib(macports_archives) libstdc++
}
variable archive_delete_la_files
if {${os.platform} eq "darwin" && ${os.major} <= 12} {
    set archive_delete_la_files(macports_archives) no
} else {
    set archive_delete_la_files(macports_archives) yes
}
variable archive_sigtype
set archive_sigtype(macports_archives) rmd160
variable archive_pubkey
set archive_pubkey(macports_archives) /opt/local/share/macports/macports-pubkey.pem

}
