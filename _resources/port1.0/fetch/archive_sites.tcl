namespace eval portfetch::mirror_sites { }

global os.platform os.major
set packages_scheme [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]

set portfetch::mirror_sites::sites(macports_archives) "
    ${packages_scheme}://packages.macports.org/:nosubdir
    http://fco.it.packages.macports.org/mirrors/macports-packages/:nosubdir
    http://her.gr.packages.macports.org/:nosubdir
    http://jnb.za.packages.macports.org/packages/:nosubdir
    http://kmq.jp.packages.macports.org/:nosubdir
    http://lil.fr.packages.macports.org/:nosubdir
    http://nou.nc.packages.macports.org/pub/macports/packages.macports.org/:nosubdir
    http://nue.de.packages.macports.org/:nosubdir
    http://mse.uk.packages.macports.org/sites/packages.macports.org/:nosubdir
    http://osl.no.packages.macports.org/:nosubdir
    ${packages_scheme}://pek.cn.packages.macports.org/macports/packages/:nosubdir
    http://sea.us.packages.macports.org/macports/packages/:nosubdir
    http://jog.id.packages.macports.org/macports/packages/:nosubdir
    http://ywg.ca.packages.macports.org/mirror/macports/packages/:nosubdir
"

set portfetch::mirror_sites::archive_type(macports_archives) tbz2
set portfetch::mirror_sites::archive_prefix(macports_archives) /opt/local
set portfetch::mirror_sites::archive_frameworks_dir(macports_archives) /opt/local/Library/Frameworks
set portfetch::mirror_sites::archive_applications_dir(macports_archives) /Applications/MacPorts
