namespace eval portfetch::mirror_sites { }

global os.platform os.major
set packages_scheme [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]

# Servers that support http.
set portfetch::mirror_sites::sites(macports_archives) "
    ${packages_scheme}://packages.macports.org/:nosubdir
    http://aus.us.packages.macports.org/macports/packages/:nosubdir
    http://cph.dk.packages.macports.org/:nosubdir
    http://fco.it.packages.macports.org/:nosubdir
    http://jnb.za.packages.macports.org/packages/:nosubdir
    http://kmq.jp.packages.macports.org/:nosubdir
    http://lil.fr.packages.macports.org/:nosubdir
    http://nou.nc.packages.macports.org/pub/macports/packages.macports.org/:nosubdir
    http://nue.de.packages.macports.org/:nosubdir
    http://mse.uk.packages.macports.org/sites/packages.macports.org/:nosubdir
    ${packages_scheme}://pek.cn.packages.macports.org/macports/packages/:nosubdir
    http://jog.id.packages.macports.org/macports/packages/:nosubdir
"

# Servers that only support https.
if {${packages_scheme} eq "https"} {
    append portfetch::mirror_sites::sites(macports_archives) "
        https://ywg.ca.packages.macports.org/mirror/macports/packages/:nosubdir
    "
}

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
