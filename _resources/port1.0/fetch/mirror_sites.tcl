# List of master site classes for use in Portfiles.
# Most of these were originally taken from FreeBSD.
#
# Appending :nosubdir as a tag to a mirror means that
# the portfetch target will NOT append a subdirectory to
# the mirror site.
#
# Please keep this list sorted.

namespace eval portfetch::mirror_sites { }

set portfetch::mirror_sites::sites(afterstep) {
    ftp://ftp.afterstep.org/
    ftp://ftp.kddlabs.co.jp/X11/AfterStep/
}

set portfetch::mirror_sites::sites(apache) {
    http://mirror.aarnet.edu.au/pub/apache/
    http://archive.apache.org/dist/
    http://www.apache.org/dist/
    http://mirror.cc.columbia.edu/pub/software/apache/
    http://mirror.facebook.net/apache/
    http://www.gtlib.gatech.edu/pub/apache/
    http://mirrors.ibiblio.org/apache/
    ftp://ftp.infoscience.co.jp/pub/net/apache/dist/
    http://mirror.internode.on.net/pub/apache/
    http://apache.is.co.za/
    http://www.mirrorservice.org/sites/ftp.apache.org/
    http://apache.multidist.com/
    http://apache.pesat.net.id/
    http://apache.mirror.rafal.ca/
}

# Equivalent to "perl_cpan"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(cpan) {
    http://mirror.aarnet.edu.au/pub/CPAN/modules/by-module/
    ftp://ftp.auckland.ac.nz/pub/perl/CPAN/modules/by-module/
    http://ftp.carnet.hr/pub/CPAN/modules/by-module/
    http://mirror.cogentco.com/pub/CPAN/modules/by-module/
    http://mirror.cc.columbia.edu/pub/software/cpan/modules/by-module/
    ftp://ftp.cpan.org/pub/CPAN/modules/by-module/
    http://cpan.mirror.euserv.net/modules/by-module/
    ftp://ftp.funet.fi/pub/languages/perl/CPAN/modules/by-module/
    http://mirrors.ibiblio.org/CPAN/modules/by-module/
    http://mirror.internode.on.net/pub/cpan/modules/by-module/
    ftp://ftp.is.co.za/programming/perl/modules/by-module/
    ftp://ftp.kddlabs.co.jp/lang/perl/CPAN/modules/by-module/
    http://www.mirrorservice.org/sites/cpan.perl.org/CPAN/modules/by-module/
    ftp://xyz.csail.mit.edu/pub/CPAN/modules/by-module/
    http://mirrors.mit.edu/CPAN/modules/by-module/
    http://mirror.ox.ac.uk/sites/www.cpan.org/modules/by-module/
    ftp://ftp.sunet.se/pub/lang/perl/CPAN/modules/by-module/
    http://mirror.uoregon.edu/CPAN/modules/by-module/
    http://mirror.uta.edu/CPAN/modules/by-module/
    http://cpan.cs.utah.edu/modules/by-module/
    http://ftp.wayne.edu/CPAN/modules/by-module/
}

# Equivalent to "tex_ctan"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(ctan) {
    http://mirror.aarnet.edu.au/pub/CTAN/
    http://mirror.cc.columbia.edu/pub/software/ctan/
    ftp://ftp.dante.de/tex-archive/
    ftp://ftp.funet.fi/pub/TeX/CTAN/
    http://mirrors.ibiblio.org/CTAN/
    http://mirror.internode.on.net/pub/ctan/
    ftp://ftp.kddlabs.co.jp/CTAN/
    ftp://mirror.macomnet.net/pub/CTAN/
    ftp://xyz.csail.mit.edu/pub/CTAN/
    http://mirrors.mit.edu/CTAN/
    http://ftp.sun.ac.za/ftp/CTAN/
    ftp://ftp.tex.ac.uk/tex-archive/
    ftp://ctan.tug.org/tex-archive/
    ftp://ctan.unsw.edu.au/tex-archive/
    http://ctan.math.utah.edu/ctan/tex-archive/
    http://ftp.inf.utfsm.cl/pub/tex-archive/
}

# Note that mirror_sites aren't intelligent enough to handle how this should
# work automatically (which is, append first letter of port name, then
# port name) so just use a basic form here and fake it in ports that need
# to use this.
set portfetch::mirror_sites::sites(debian) {
    http://ftp.au.debian.org/debian/pool/main/:nosubdir
    http://ftp.wa.au.debian.org/debian/pool/main/:nosubdir
    http://ftp.bg.debian.org/debian/pool/main/:nosubdir
    http://ftp.cl.debian.org/debian/pool/main/:nosubdir
    http://ftp.cz.debian.org/debian/pool/main/:nosubdir
    http://ftp.de.debian.org/debian/pool/main/:nosubdir
    http://ftp2.de.debian.org/debian/pool/main/:nosubdir
    http://ftp.ee.debian.org/debian/pool/main/:nosubdir
    http://ftp.es.debian.org/debian/pool/main/:nosubdir
    http://ftp.fi.debian.org/debian/pool/main/:nosubdir
    http://ftp.fr.debian.org/debian/pool/main/:nosubdir
    http://ftp.hk.debian.org/debian/pool/main/:nosubdir
    http://ftp.hr.debian.org/debian/pool/main/:nosubdir
    http://ftp.hu.debian.org/debian/pool/main/:nosubdir
    http://ftp.ie.debian.org/debian/pool/main/:nosubdir
    http://ftp.is.debian.org/debian/pool/main/:nosubdir
    http://ftp.it.debian.org/debian/pool/main/:nosubdir
    http://ftp.jp.debian.org/debian/pool/main/:nosubdir
    http://ftp.nl.debian.org/debian/pool/main/:nosubdir
    http://ftp.no.debian.org/debian/pool/main/:nosubdir
    http://ftp.pl.debian.org/debian/pool/main/:nosubdir
    http://ftp.ru.debian.org/debian/pool/main/:nosubdir
    http://ftp.se.debian.org/debian/pool/main/:nosubdir
    http://ftp.si.debian.org/debian/pool/main/:nosubdir
    http://ftp.sk.debian.org/debian/pool/main/:nosubdir
    http://ftp.uk.debian.org/debian/pool/main/:nosubdir
    http://ftp.us.debian.org/debian/pool/main/:nosubdir
}

set portfetch::mirror_sites::sites(fink) {
    http://distfiles.ber.de.eu.finkmirrors.net/:nosubdir
    http://distfiles.hel.fi.eu.finkmirrors.net/:nosubdir
    http://distfiles.dub.ie.eu.finkmirrors.net/:nosubdir
    http://distfiles.hnd.jp.asi.finkmirrors.net/:nosubdir
    http://distfiles.master.finkmirrors.net/:nosubdir
    http://distfiles.sjc.ca.us.finkmirrors.net/:nosubdir
    http://www.mirrorservice.org/sites/master.us.finkmirrors.net/distfiles/:nosubdir
}

# FreeBSD switched to a Geo-IP-based load-balanced distcache.
# Note that FreeBSD's pkg(8) utility does not just stupidly
# download via HTTP, but issues DNS queries to fetch
# SRV records and compute the "best" available server
# given some weighting criteria.
# It probably doesn't matter a bunch, though, and plain
# DNS lookups and HTTP requests are fine.
set portfetch::mirror_sites::sites(freebsd) {
    http://distcache.FreeBSD.org/ports-distfiles/:nosubdir
}

# https://api.gentoo.org/mirrors/distfiles.xml appears to be valid now
# Does not work: curl -s http://www.gentoo.org/main/en/mirrors2.xml | sed -n '/(http)\|(ftp)/s/.*"\([^"]*\)".*/    \1\/distfiles\/:nosubdir/p' | sed s@//distfiles@/distfiles@g
set portfetch::mirror_sites::sites(gentoo) {
    http://cosmos.illinois.edu/pub/gentoo/distfiles/:nosubdir
    http://files.gentoo.gr/distfiles/:nosubdir
    http://ftp-stud.hs-esslingen.de/pub/Mirrors/gentoo/distfiles/:nosubdir
    http://ftp.daum.net/gentoo/distfiles/:nosubdir
    http://ftp.dei.uc.pt/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.fi.muni.cz/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.halifax.rwth-aachen.de/gentoo/distfiles/:nosubdir
    http://ftp.heanet.ie/pub/gentoo/distfiles/:nosubdir
    http://ftp.iij.ad.jp/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.jaist.ac.jp/pub/Linux/Gentoo/distfiles/:nosubdir
    http://ftp.kaist.ac.kr/pub/gentoo/distfiles/:nosubdir
    http://ftp.lanet.kr/pub/gentoo/distfiles/:nosubdir
    http://ftp.linux.org.tr/gentoo/distfiles/:nosubdir
    http://ftp.ntua.gr/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.rnl.tecnico.ulisboa.pt/pub/gentoo/gentoo-distfiles/distfiles/:nosubdir
    http://ftp.romnet.org/gentoo/distfiles/:nosubdir
    http://ftp.snt.utwente.nl/pub/os/linux/gentoo/distfiles/:nosubdir
    http://ftp.swin.edu.au/gentoo/distfiles/:nosubdir
    http://ftp.twaren.net/Linux/Gentoo/distfiles/:nosubdir
    http://ftp.uni-erlangen.de/pub/mirrors/gentoo/distfiles/:nosubdir
    http://ftp.vectranet.pl/gentoo/distfiles/:nosubdir
    http://gd.tuwien.ac.at/opsys/linux/gentoo/distfiles/:nosubdir
    http://gentoo-euetib.upc.es/mirror/gentoo/distfiles/:nosubdir
    http://gentoo.aditsu.net:8000/distfiles/:nosubdir
    http://gentoo.bloodhost.ru/distfiles/:nosubdir
    http://gentoo.c3sl.ufpr.br/distfiles/:nosubdir
    http://gentoo.cs.uni.edu/distfiles/:nosubdir
    http://gentoo.gossamerhost.com/distfiles/:nosubdir
    http://gentoo.inode.at/distfiles/:nosubdir
    http://gentoo.iteam.net.ua/distfiles/:nosubdir
    http://gentoo.mirror.web4u.cz/distfiles/:nosubdir
    http://gentoo.mirrors.easynews.com/linux/gentoo/distfiles/:nosubdir
    http://gentoo.mirrors.ovh.net/gentoo-distfiles/distfiles/:nosubdir
    http://gentoo.mirrors.pair.com/distfiles/:nosubdir
    http://gentoo.mirrors.tds.net/gentoo/distfiles/:nosubdir
    http://gentoo.mirrors.tera-byte.com/distfiles/:nosubdir
    http://gentoo.modulix.net/gentoo/distfiles/:nosubdir
    http://gentoo.netnitco.net/distfiles/:nosubdir
    http://gentoo.osuosl.org/distfiles/:nosubdir
    http://gentoo.prz.rzeszow.pl/distfiles/:nosubdir
    http://gentoo.supp.name/distfiles/:nosubdir
    http://gentoo.wheel.sk/distfiles/:nosubdir
    http://linux.rz.ruhr-uni-bochum.de/download/gentoo-mirror/distfiles/:nosubdir
    http://lug.mtu.edu/gentoo//distfiles/:nosubdir
    http://mirror.bytemark.co.uk/gentoo/distfiles/:nosubdir
    http://mirror.csclub.uwaterloo.ca/gentoo-distfiles/distfiles/:nosubdir
    http://mirror.dkm.cz/gentoo/distfiles/:nosubdir
    http://mirror.eu.oneandone.net/linux/distributions/gentoo/gentoo/distfiles/:nosubdir
    http://mirror.iawnet.sandia.gov/gentoo/distfiles/:nosubdir
    http://mirror.isoc.org.il/pub/gentoo/distfiles/:nosubdir
    http://mirror.leaseweb.com/gentoo/distfiles/:nosubdir
    http://mirror.lug.udel.edu/pub/gentoo/distfiles/:nosubdir
    http://mirror.mdfnet.se/gentoo/distfiles/:nosubdir
    http://mirror.neolabs.kz/gentoo/pub/distfiles/:nosubdir
    http://mirror.netcologne.de/gentoo/distfiles/:nosubdir
    http://mirror.qubenet.net/mirror/gentoo/distfiles/:nosubdir
    http://mirror.switch.ch/ftp/mirror/gentoo/distfiles/:nosubdir
    http://mirror.usu.edu/mirrors/gentoo/distfiles/:nosubdir
    http://mirror.yandex.ru/gentoo-distfiles/distfiles/:nosubdir
    http://mirrors.163.com/gentoo/distfiles/:nosubdir
    http://mirrors.evowise.com/gentoo/distfiles/:nosubdir
    http://mirrors.rit.edu/gentoo/distfiles/:nosubdir
    http://mirrors.soeasyto.com/distfiles.gentoo.org/distfiles/:nosubdir
    http://mirrors.telepoint.bg/gentoo/distfiles/:nosubdir
    http://mirrors.xmu.edu.cn/gentoo/distfiles/:nosubdir
    http://mirrors.xservers.ro/gentoo/distfiles/:nosubdir
    http://trumpetti.atm.tut.fi/gentoo/distfiles/:nosubdir
    http://tux.rainside.sk/gentoo/distfiles/:nosubdir
    http://www.gtlib.gatech.edu/pub/gentoo/distfiles/:nosubdir
    http://www.las.ic.unicamp.br/pub/gentoo/distfiles/:nosubdir
    http://www.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/:nosubdir
}

set portfetch::mirror_sites::sites(gimp) {
    http://artfiles.org/gimp.org/pub/
    http://gimp.cp-dev.com/
    http://download.gimp.org/pub/
    http://ftp.gtk.org/pub/
    http://ftp.gwdg.de/pub/grafik/
    http://gimp.mirrors.hoobly.com/pub/
    http://mirror.ibcp.fr/pub/
    ftp://sunsite.icm.edu.pl/pub/graphics/
    ftp://ftp.is.co.za/mirror/ftp.gimp.org/
    http://www.mirrorservice.org/sites/ftp.gimp.org/pub/
    http://piotrkosoft.net/pub/mirrors/ftp.gimp.org/pub/gimp/pub/
    http://www.ring.gr.jp/pub/graphics/
    http://ftp.sunet.se/pub/gimp/
    ftp://ftp.tpnet.pl/pub/graphics/
    http://mirror.umd.edu/gimp/
    http://ftp.iut-bm.univ-fcomte.fr/
    http://ftp.cc.uoc.gr/mirrors/
    http://mirrors.fe.up.pt/mirrors/ftp.gimp.org/pub/
    http://ftp.snt.utwente.nl/pub/software/gimp/
}

set portfetch::mirror_sites::sites(gnome) {
    http://artfiles.org/gnome.org/
    http://ftp.belnet.be/ftp.gnome.org/
    http://ftp.cse.buffalo.edu/pub/Gnome/
    http://mirror.cc.columbia.edu/pub/software/gnome/
    http://ftp.fau.de/gnome/
    http://ftp2.uk.freebsd.org/sites/ftp.gnome.org/pub/GNOME/
    http://www.gtlib.gatech.edu/pub/gnome/
    http://ftp.gnome.org/pub/GNOME/
    http://ftp.heanet.ie/mirrors/ftp.gnome.org/
    http://mirror.internode.on.net/pub/gnome/
    http://ftp.is.co.za/mirror/ftp.gnome.org/
    ftp://ftp.kddlabs.co.jp/pub/GNOME/
    http://mirror.oss.maxcdn.com/gnome/
    http://www.mirrorservice.org/sites/ftp.gnome.org/pub/GNOME/
    https://muug.ca/mirror/gnome/
    http://mirror.nbtelecom.com.br/gnome/
    http://ftp1.nluug.nl/windowing/gnome/
    http://ftp2.nluug.nl/windowing/gnome/
    http://fr2.rpmfind.net/linux/gnome.org/
    http://ftp.rpmfind.net/linux/gnome.org/
    http://ftp.sunet.se/pub/X11/GNOME/
    http://mirror.umd.edu/gnome/
    http://ftp.acc.umu.se/pub/GNOME/
    http://mirrors.ustc.edu.cn/gnome/
    http://ftp.nara.wide.ad.jp/pub/X11/GNOME/
}

set portfetch::mirror_sites::sites(gnu) {
    http://mirror.cc.columbia.edu/pub/software/gnu/
    http://mirror.facebook.net/gnu/
    ftp://ftp.funet.fi/pub/gnu/prep/
    http://ftp.gnu.org/gnu/
    ftp://ftp.gnu.org/old-gnu/
    ftp://ftp.informatik.hu-berlin.de/pub/gnu/gnu/
    http://mirrors.ibiblio.org/gnu/ftp/gnu/
    http://mirror.internode.on.net/pub/gnu/
    ftp://ftp.kddlabs.co.jp/pub/gnu/gnu/
    ftp://ftp.kddlabs.co.jp/pub/gnu/old-gnu/
    ftp://ftp.lip6.fr/pub/gnu/
    http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/
    ftp://ftp.unicamp.br/pub/gnu/
}

set portfetch::mirror_sites::sites(gnupg) {
    http://mirror.cc.columbia.edu/pub/software/gnupg/
    http://ftp.freenet.de/pub/ftp.gnupg.org/gcrypt/
    ftp://ftp.gnupg.org/gcrypt/
    ftp://ftp.jyu.fi/pub/crypt/gcrypt/
    http://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/
    http://www.ring.gr.jp/pub/net/gnupg/
    ftp://gd.tuwien.ac.at/privacy/gnupg/
}

set portfetch::mirror_sites::sites(gnustep) {
    http://ftpmain.gnustep.org/pub/gnustep/
}

set portfetch::mirror_sites::sites(googlecode) {
    https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${name}/
}

set portfetch::mirror_sites::sites(isc) {
    http://ftp.arcane-networks.fr/pub/mirrors/ftp.isc.org/isc/
    ftp://ftp.ciril.fr/pub/isc/
    ftp://ftp.freenet.de/pub/ftp.isc.org/isc/
    ftp://ftp.fsn.hu/pub/isc/
    ftp://ftp.funet.fi/pub/mirrors/ftp.isc.org/isc/
    ftp://ftp.iij.ad.jp/pub/network/isc/
    http://mirror.internode.on.net/pub/isc/
    ftp://ftp.isc.org/isc/
    http://ftp.kaist.ac.kr/pub/isc/
    ftp://ftp.metu.edu.tr/pub/mirrors/ftp.isc.org/
    http://www.mirrorservice.org/sites/ftp.isc.org/isc/
    ftp://ftp.nominum.com/pub/isc/
    ftp://ftp.ntua.gr/pub/net/isc/isc/
    ftp://ftp.ripe.net/mirrors/sites/ftp.isc.org/isc/
    ftp://ftp.sunet.se/pub/network/isc/
    ftp://ftp.task.gda.pl/mirror/ftp.isc.org/isc/
    ftp://gd.tuwien.ac.at/infosys/servers/isc/
}

set portfetch::mirror_sites::sites(kde) {
    http://mirror.aarnet.edu.au/pub/KDE/
    http://mirror.cc.columbia.edu/pub/software/kde/
    http://mirror.facebook.net/kde/
    http://ftp.gtlib.gatech.edu/pub/kde/
    http://kde.mirrors.hoobly.com/
    http://mirror.internode.on.net/pub/kde/
    http://mirrors.isc.org/pub/kde/
    http://ftp.kddlabs.co.jp/pub/X11/kde/
    ftp://ftp.kde.org/pub/kde/
    http://www.mirrorservice.org/sites/ftp.kde.org/pub/kde/
    http://mirrors.mit.edu/kde/
    ftp://ftp.solnet.ch/mirror/KDE/
    http://kde.mirrors.tds.net/pub/kde/
    http://gd.tuwien.ac.at/kde/
}

set portfetch::mirror_sites::sites(macports) {
    https://svn.macports.org/repository/macports/distfiles/
}

global os.platform os.major
set distfiles_scheme [expr {${os.platform} eq "darwin" && ${os.major} < 10 ? "http" : "https"}]

set portfetch::mirror_sites::sites(macports_distfiles) "
    ${distfiles_scheme}://distfiles.macports.org/:mirror
    http://aarnet.au.distfiles.macports.org/pub/macports/distfiles/:mirror
    http://cjj.kr.distfiles.macports.org/:mirror
    http://fco.it.distfiles.macports.org/mirrors/macports-distfiles/:mirror
    http://her.gr.distfiles.macports.org/:mirror
    http://jnb.za.distfiles.macports.org/distfiles/:mirror
    http://jog.id.distfiles.macports.org/macports/distfiles/:mirror
    http://kmq.jp.distfiles.macports.org/:mirror
    http://lil.fr.distfiles.macports.org/:mirror
    http://mse.uk.distfiles.macports.org/sites/distfiles.macports.org/:mirror
    http://nou.nc.distfiles.macports.org/pub/macports/distfiles.macports.org/:mirror
    http://nue.de.distfiles.macports.org/:mirror
    http://osl.no.distfiles.macports.org/:mirror
    ${distfiles_scheme}://pek.cn.distfiles.macports.org/macports/distfiles/:mirror
    http://sea.us.distfiles.macports.org/macports/distfiles/:mirror
    http://ykf.ca.distfiles.macports.org/MacPorts/mpdistfiles/:mirror
    http://ywg.ca.distfiles.macports.org/mirror/macports/distfiles/:mirror
"

# To update this list use:
# $ curl -s http://dev.mysql.com/downloads/mirrors.html | grep -E '>HTTP<' | sed -e 's,.*href="\(.*\)">.*,    \1/Downloads/:nosubdir,g' -e 's,//Downloads/:nosubdir,/Downloads/:nosubdir,g' | sort -u
# To remove bad mirrors look at this inexpensive output:
# $ for port in mysql{5,51,55,56} ; do echo "port: ${port}" ; for mirror in $(port distfiles $port | grep -v macports | grep -E "^ *(http|ftp)://") ; do echo $mirror ; curl -sI $mirror | grep -E "(^213|Content-Length)" | sed -e '/Content-Length/ s/.*: //' -e '/213/ s/.* //' ; done ; done
set portfetch::mirror_sites::sites(mysql) {
    http://artfiles.org/mysql/Downloads/:nosubdir
    http://ftp.arnes.si/mysql/Downloads/:nosubdir
    http://ftp.gwdg.de/pub/misc/mysql/Downloads/:nosubdir
    http://ftp.heanet.ie/mirrors/www.mysql.com/Downloads/:nosubdir
    http://ftp.iij.ad.jp/pub/db/mysql/Downloads/:nosubdir
    http://ftp.jaist.ac.jp/pub/mysql/Downloads/:nosubdir
    http://ftp.ntua.gr/pub/databases/mysql/Downloads/:nosubdir
    http://ftp.sunet.se/pub/unix/databases/relational/mysql/Downloads/:nosubdir
    http://gd.tuwien.ac.at/db/mysql/Downloads/:nosubdir
    http://linorg.usp.br/mysql/Downloads/:nosubdir
    http://mirror.csclub.uwaterloo.ca/mysql/Downloads/:nosubdir
    http://mirror.leaseweb.com/mysql/Downloads/:nosubdir
    http://mirror.switch.ch/ftp/mirror/mysql/Downloads/:nosubdir
    http://mirror.trouble-free.net/mysql_mirror/Downloads/:nosubdir
    http://mirrors.dedipower.com/www.mysql.com/Downloads/:nosubdir
    http://mirrors.dotsrc.org/mysql/Downloads/:nosubdir
    http://mirrors.ircam.fr/pub/mysql/Downloads/:nosubdir
    http://mirrors.ukfast.co.uk/sites/ftp.mysql.com/Downloads/:nosubdir
    http://mirrors.xservers.ro/mysql/Downloads/:nosubdir
    http://mysql.he.net/Downloads/:nosubdir
    http://mysql.infocom.ua/Downloads/:nosubdir
    http://mysql.inspire.net.nz/Downloads/:nosubdir
    http://mysql.linux.cz/Downloads/:nosubdir
    http://mysql.mirror.ac.za/Downloads/:nosubdir
    http://mysql.mirror.kangaroot.net/Downloads/:nosubdir
    http://mysql.mirrors.arminco.com/Downloads/:nosubdir
    http://mysql.mirrors.crysys.hit.bme.hu/Downloads/:nosubdir
    http://mysql.mirrors.hoobly.com/Downloads/:nosubdir
    http://mysql.mirrors.ovh.net/ftp.mysql.com/Downloads/:nosubdir
    http://mysql.mirrors.pair.com/Downloads/:nosubdir
    http://mysql.spd.co.il/Downloads/:nosubdir
    http://na.mirror.garr.it/mirrors/MySQL/Downloads/:nosubdir
    http://sunsite.icm.edu.pl/mysql/Downloads/:nosubdir
    http://www.linorg.usp.br/mysql/Downloads/:nosubdir
    http://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/:nosubdir
}

set portfetch::mirror_sites::sites(netbsd) {
    http://ftp.NetBSD.org/pub/NetBSD/
    http://ftp7.de.NetBSD.org/pub/ftp.netbsd.org/pub/NetBSD/
    http://ftp.fr.NetBSD.org/pub/NetBSD/
    ftp://ftp7.jp.NetBSD.org/pub/NetBSD/
    ftp://ftp.ru.NetBSD.org/pub/NetBSD/
    ftp://ftp.tw.NetBSD.org/pub/NetBSD/
    ftp://ftp.uk.NetBSD.org/pub/NetBSD/
    ftp://ftp7.us.NetBSD.org/pub/NetBSD/
}

# Equivalent to "savannah"; neither name takes precedence over the other.
# https://download-mirror.savannah.gnu.org/releases/00_MIRRORS.txt
set portfetch::mirror_sites::sites(nongnu) {
    http://mirror.csclub.uwaterloo.ca/nongnu/
    ftp://mirror.csclub.uwaterloo.ca/nongnu/
    http://babyname.tips/mirrors/nongnu/
    http://mirror.netcologne.de/savannah/
    ftp://mirror.netcologne.de/savannah/
    http://ftp.cc.uoc.gr/mirrors/nongnu.org/
    ftp://ftp.cc.uoc.gr/mirrors/nongnu.org/
    http://mirror.infotronik.hu/mirrors/pub/gnusavannah/
    http://mirror1.hostiran.ir/gnu/gnu-savannah/
    http://download-mirror.savannah.gnu.org/releases/
    http://nongnu.askapache.com/
    http://savannah.c3sl.ufpr.br/
    ftp://savannah.c3sl.ufpr.br/savannah-nongnu/
    http://mirror.lihnidos.org/GNU/savannah/
    http://mirrors.up.pt/pub/nongnu/
    https://mirrors.up.pt/pub/nongnu/
    ftp://mirrors.up.pt/pub/nongnu/
    http://nongnu.uib.no/
    ftp://nongnu.uib.no/pub/nongnu/
    http://mirror.rackdc.com/savannah/
    http://ftp.igh.cnrs.fr/pub/nongnu/
    ftp://ftp.igh.cnrs.fr/pub/nongnu/
    http://savannah.spinellicreations.com/
    ftp://spinellicreations.com/gnu_dot_org_savannah_mirror/
    http://gnu.mirrors.pair.com/savannah/savannah/
    http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/
    ftp://ftp.mirrorservice.org/sites/download.savannah.gnu.org/releases/
    http://savannah-nongnu-org.ip-connect.vn.ua/
    ftp://savannah-nongnu-org.ip-connect.vn.ua/mirror/savannah.nongnu.org/
    http://mirror.cedia.org.ec/nongnu/
    ftp://mirror.cedia.org.ec/nongnu/
    ftp://ftp.yzu.edu.tw/nongnu/
    http://ftp.yzu.edu.tw/nongnu/
    http://mirror6.layerjet.com/nongnu/
    http://mirror.easyname.at/nongnu/
    ftp://mirror.easyname.at/nongnu/
    http://mirror2.klaus-uwe.me/nongnu/
    ftp://mirror2.klaus-uwe.me/nongnu/
    http://ftp.acc.umu.se/mirror/gnu.org/savannah/
    http://www.namesdir.com/mirrors/nongnu/
}

# https://www.openbsd.org/ftp.html
set portfetch::mirror_sites::sites(openbsd) {
    https://mirror.leaseweb.com/pub/OpenBSD/
    https://mirror.aarnet.edu.au/pub/OpenBSD/
    https://ftp2.eu.openbsd.org/pub/OpenBSD/
    https://openbsd.c3sl.ufpr.br/pub/OpenBSD/
    https://openbsd.ipacct.com/pub/OpenBSD/
    https://ftp.OpenBSD.org/pub/OpenBSD/
    https://openbsd.cs.toronto.edu/pub/OpenBSD/
    https://openbsd.delfic.org/pub/OpenBSD/
    https://openbsd.mirror.netelligent.ca/pub/OpenBSD/
    https://mirrors.ucr.ac.cr/pub/OpenBSD/
    https://mirrors.dotsrc.org/pub/OpenBSD/
    https://mirror.one.com/pub/OpenBSD/
    https://ftp.fr.openbsd.org/pub/OpenBSD/
    https://mirrors.ircam.fr/pub/OpenBSD/
    https://ftp.spline.de/pub/OpenBSD/
    https://mirror.hs-esslingen.de/pub/OpenBSD/
    https://ftp.halifax.rwth-aachen.de/openbsd/
    https://ftp.hostserver.de/pub/OpenBSD/
    https://ftp.fau.de/pub/OpenBSD/
    https://ftp.cc.uoc.gr/pub/OpenBSD/
    https://openbsd.hk/pub/OpenBSD/
    https://ftp.heanet.ie/pub/OpenBSD/
    https://openbsd.mirror.garr.it/pub/OpenBSD/
    https://mirror.litnet.lt/pub/OpenBSD/
    https://mirror.meerval.net/pub/OpenBSD/
    https://ftp.nluug.nl/pub/OpenBSD/
    https://ftp.bit.nl/pub/OpenBSD/
    https://mirrors.dalenys.com/pub/OpenBSD/
    https://ftp.icm.edu.pl/pub/OpenBSD/
    https://ftp.rnl.tecnico.ulisboa.pt/pub/OpenBSD/
    https://mirrors.pidginhost.com/pub/OpenBSD/
    https://mirror.yandex.ru/pub/OpenBSD/
    https://ftp.eu.openbsd.org/pub/OpenBSD/
    https://ftp.yzu.edu.tw/pub/OpenBSD/
    https://www.mirrorservice.org/pub/OpenBSD/
    https://anorien.csc.warwick.ac.uk/pub/OpenBSD/
    https://mirror.bytemark.co.uk/pub/OpenBSD/
    https://mirrors.sonic.net/pub/OpenBSD/
    https://ftp3.usa.openbsd.org/pub/OpenBSD/
    https://mirrors.syringanetworks.net/pub/OpenBSD/
    https://openbsd.mirror.constant.com/pub/OpenBSD/
    https://ftp4.usa.openbsd.org/pub/OpenBSD/
    https://ftp5.usa.openbsd.org/pub/OpenBSD/
    https://mirror.esc7.net/pub/OpenBSD/
    http://mirror.internode.on.net/pub/OpenBSD/
    http://mirrors.unb.br/pub/OpenBSD/
    http://ftp.aso.ee/pub/OpenBSD/
    http://ftp2.fr.openbsd.org/pub/OpenBSD/
    http://ftp.bytemine.net/pub/OpenBSD/
    http://artfiles.org/openbsd/
    http://ftp.fsn.hu/pub/OpenBSD/
    http://kartolo.sby.datautama.net.id/pub/OpenBSD/
    http://ftp.jaist.ac.jp/pub/OpenBSD/
    http://mirror.rise.ph/pub/OpenBSD/
    http://piotrkosoft.net/pub/OpenBSD/
    http://ftp.man.poznan.pl/pub/OpenBSD/
    http://www.obsd.si/pub/OpenBSD/
    http://mirror.switch.ch/ftp/pub/OpenBSD/
    http://mirror.ox.ac.uk/pub/OpenBSD/
    http://mirror.exonetric.net/pub/OpenBSD/
    http://mirrors.gigenet.com/pub/OpenBSD/
    http://mirrors.mit.edu/pub/OpenBSD/
    http://openbsd.mirrors.hoobly.com/
    http://openbsd.mirrors.pair.com/
    ftp://mirror.internode.on.net/pub/OpenBSD/
    ftp://ftp2.eu.openbsd.org/pub/OpenBSD/
    ftp://openbsd.c3sl.ufpr.br/pub/OpenBSD/
    ftp://mirrors.unb.br/pub/OpenBSD/
    ftp://openbsd.ipacct.com/pub/OpenBSD/
    ftp://openbsd.cs.toronto.edu/pub/OpenBSD/
    ftp://mirrors.dotsrc.org/pub/OpenBSD/
    ftp://mirror.one.com/pub/OpenBSD/
    ftp://ftp.aso.ee/pub/OpenBSD/
    ftp://ftp2.fr.openbsd.org/pub/OpenBSD/
    ftp://mirrors.ircam.fr/pub/OpenBSD/
    ftp://ftp.irisa.fr/pub/OpenBSD/
    ftp://ftp.spline.de/pub/OpenBSD/
    ftp://mirror.hs-esslingen.de/pub/OpenBSD/
    ftp://ftp.bytemine.net/pub/OpenBSD/
    ftp://ftp.hostserver.de/pub/OpenBSD/
    ftp://ftp.cc.uoc.gr/pub/OpenBSD/
    ftp://ftp.fsn.hu/pub/OpenBSD/
    ftp://ftp.heanet.ie/pub/OpenBSD/
    ftp://openbsd.mirror.garr.it/mirrors/OpenBSD/
    ftp://ftp.jaist.ac.jp/pub/OpenBSD/
    ftp://ftp.kddilabs.jp/pub/OpenBSD/
    ftp://mirror.litnet.lt/pub/OpenBSD/
    ftp://mirror.meerval.net/pub/OpenBSD/
    ftp://ftp.nluug.nl/pub/OpenBSD/
    ftp://ftp.bit.nl/pub/OpenBSD/
    ftp://mirrors.dalenys.com/pub/OpenBSD/
    ftp://mirror.rise.ph/pub/OpenBSD/
    ftp://ftp.piotrkosoft.net/pub/OpenBSD/
    ftp://ftp.icm.edu.pl/pub/OpenBSD/
    ftp://ftp.man.poznan.pl/pub/OpenBSD/
    ftp://mirror.yandex.ru/pub/OpenBSD/
    ftp://ftp.obsd.si/pub/OpenBSD/
    ftp://ftp.eu.openbsd.org/pub/OpenBSD/
    ftp://mirror.switch.ch/pub/OpenBSD/
    ftp://ftp.yzu.edu.tw/pub/OpenBSD/
    ftp://ftp.ulak.net.tr/pub/OpenBSD/
    ftp://ftp.mirrorservice.org/pub/OpenBSD/
    ftp://anorien.csc.warwick.ac.uk/pub/OpenBSD/
    ftp://mirror.bytemark.co.uk/pub/OpenBSD/
    ftp://mirror.ox.ac.uk/pub/OpenBSD/
    ftp://mirror.exonetric.net/pub/OpenBSD/
    ftp://mirrors.sonic.net/pub/OpenBSD/
    ftp://ftp3.usa.openbsd.org/pub/OpenBSD/
    ftp://mirrors.syringanetworks.net/pub/OpenBSD/
    ftp://mirrors.mit.edu/pub/OpenBSD/
    ftp://ftp4.usa.openbsd.org/pub/OpenBSD/
    ftp://ftp5.usa.openbsd.org/pub/OpenBSD/
    ftp://mirror.esc7.net/pub/OpenBSD/
}

# https://osdn.jp/docs/Mirrors
# They don't actually list the URLs; these were obtained by guessing.
set portfetch::mirror_sites::sites(osdn) {
    http://aarnet.dl.osdn.jp/
    http://c3sl.dl.osdn.jp/
    http://gigenet.dl.osdn.jp/
    http://iij.dl.osdn.jp/
    http://jaist.dl.osdn.jp/
    http://nchc.dl.osdn.jp/
    http://onet.dl.osdn.jp/
    http://osdn.dl.sourceforge.jp/
    http://rwthaachen.dl.osdn.jp/
}

# Equivalent to "cpan"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(perl_cpan) \
        $portfetch::mirror_sites::sites(cpan)

# http://php.net/mirrors.php
# The country code domains without number suffix are supposed to redirect to
# an available mirror in that country. To update this list use:
# curl -s --compressed http://php.net/mirrors.php | sed -E -n 's,^.*http://([a-z]{2})[0-9]*(\.php\.net)/.*$,\1\2,p' | sort -u | xargs -n 1 -I % sh -c '{ curl -s --compressed --connect-timeout 30 -m 60 http://%/ | grep -iq "php group" && echo "    http://%/:nosubdir"; }' | tee /dev/tty | pbcopy
set portfetch::mirror_sites::sites(php) {
    http://ar.php.net/:nosubdir
    http://at.php.net/:nosubdir
    http://au.php.net/:nosubdir
    http://be.php.net/:nosubdir
    http://br.php.net/:nosubdir
    http://ca.php.net/:nosubdir
    http://ch.php.net/:nosubdir
    http://cl.php.net/:nosubdir
    http://cn.php.net/:nosubdir
    http://cz.php.net/:nosubdir
    http://de.php.net/:nosubdir
    http://ee.php.net/:nosubdir
    http://fi.php.net/:nosubdir
    http://hk.php.net/:nosubdir
    http://ie.php.net/:nosubdir
    http://in.php.net/:nosubdir
    http://ir.php.net/:nosubdir
    http://it.php.net/:nosubdir
    http://jm.php.net/:nosubdir
    http://jp.php.net/:nosubdir
    http://kr.php.net/:nosubdir
    http://lt.php.net/:nosubdir
    http://mx.php.net/:nosubdir
    http://my.php.net/:nosubdir
    http://nl.php.net/:nosubdir
    http://nz.php.net/:nosubdir
    http://pa.php.net/:nosubdir
    http://pl.php.net/:nosubdir
    http://se.php.net/:nosubdir
    http://sg.php.net/:nosubdir
    http://th.php.net/:nosubdir
    http://tr.php.net/:nosubdir
    http://tw.php.net/:nosubdir
    http://uk.php.net/:nosubdir
    http://us.php.net/:nosubdir
    http://za.php.net/:nosubdir
}

set portfetch::mirror_sites::sites(postgresql) {
    http://mirror.aarnet.edu.au/pub/postgresql/
    http://www.mirrorservice.org/sites/ftp.postgresql.org/
    http://ftp.postgresql.org/pub/
}

# Note that mirror_sites aren't intelligent enough to handle how this should
# work automatically (which is, append first letter of port name, then
# port name) so just use a basic form here and fake it in ports that need
# to use this.
set portfetch::mirror_sites::sites(pypi) {
    https://pypi.python.org/packages/source/:nosubdir
    https://files.pythonhosted.org/packages/source/:nosubdir
}

set portfetch::mirror_sites::sites(ruby) {
    ftp://ftp.easynet.be/ruby/ruby/
    ftp://ftp.fu-berlin.de/unix/languages/ruby/
    http://mirrors.ibiblio.org/ruby/
    ftp://ftp.iDaemons.org/pub/mirror/ftp.ruby-lang.org/ruby/
    ftp://ftp.iij.ad.jp/pub/lang/ruby/
    http://www.mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby/
    ftp://xyz.csail.mit.edu/pub/ruby/
    ftp://ftp.ntua.gr/pub/lang/ruby/
    http://ftp.ruby-lang.org/pub/ruby/
}

# Equivalent to "nongnu"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(savannah) \
        $portfetch::mirror_sites::sites(nongnu)

# https://sourceforge.net/p/forge/documentation/Mirrors/
set portfetch::mirror_sites::sites(sourceforge) {
    http://ayera.dl.sourceforge.net/
    http://cytranet.dl.sourceforge.net/
    http://excellmedia.dl.sourceforge.net/
    http://freefr.dl.sourceforge.net/
    http://iweb.dl.sourceforge.net/
    http://jaist.dl.sourceforge.net/
    http://kent.dl.sourceforge.net/
    http://liquidtelecom.dl.sourceforge.net/
    http://nchc.dl.sourceforge.net/
    http://ncu.dl.sourceforge.net/
    http://netassist.dl.sourceforge.net/
    http://netcologne.dl.sourceforge.net/
    http://netix.dl.sourceforge.net/
    http://phoenixnap.dl.sourceforge.net/
    http://pilotfiber.dl.sourceforge.net/
    http://superb-dca2.dl.sourceforge.net/
    http://superb-sea2.dl.sourceforge.net/
    http://tenet.dl.sourceforge.net/
    http://svwh.dl.sourceforge.net/
    http://ufpr.dl.sourceforge.net/
}

set portfetch::mirror_sites::sites(sourceforge_jp) {
    http://globalbase.dl.sourceforge.jp/
    http://iij.dl.sourceforge.jp/
    http://jaist.dl.sourceforge.jp/
    http://keihanna.dl.sourceforge.jp/
    http://osdn.dl.sourceforge.jp/
}

set portfetch::mirror_sites::sites(sunsite) {
    ftp://ftp.cse.cuhk.edu.hk/pub4/Linux/
    http://www.gtlib.gatech.edu/pub/Linux/
    http://www.ibiblio.org/pub/Linux/
    ftp://ftp.icm.edu.pl/vol/rzm1/linux-ibiblio/
    ftp://ftp.kddlabs.co.jp/Linux/metalab.unc.edu/
    ftp://ftp.lip6.fr/pub/linux/sunsite/
    http://ftp.nluug.nl/pub/sunsite/
    ftp://ftp.nvg.ntnu.no/pub/mirrors/metalab.unc.edu/
    ftp://ftp.cs.tu-berlin.de/pub/linux/Mirrors/sunsite.unc.edu/
    ftp://ftp.tuwien.ac.at/pub/linux/ibiblio/
    ftp://ftp.unicamp.br/pub/systems/Linux/
    ftp://sunsite.unc.edu/pub/Linux/
}

set portfetch::mirror_sites::sites(tcltk) {
    ftp://ftp.funet.fi/pub/languages/tcl/tcl/
    ftp://ftp.kddlabs.co.jp/lang/tcl/ftp.scriptics.com/
    http://www.mirrorservice.org/sites/ftp.tcl.tk/pub/tcl/
    ftp://xyz.csail.mit.edu/pub/tcl/
    ftp://mirror.switch.ch/mirror/tcl.tk/
    ftp://ftp.tcl.tk/pub/tcl/
    ftp://ftp.informatik.uni-hamburg.de/pub/soft/lang/tcl/
    http://www.etsimo.uniovi.es/pub/mirrors/ftp.scriptics.com/
}

# Equivalent to "ctan"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(tex_ctan) \
        $portfetch::mirror_sites::sites(ctan)

set portfetch::mirror_sites::sites(trolltech) {
    http://ftp.heanet.ie/mirrors/ftp.trolltech.com/pub/qt/source/:nosubdir
    ftp://ftp.informatik.hu-berlin.de/pub1/Mirrors/ftp.troll.no/QT/qt/source/:nosubdir
    http://get.qt.nokia.com/qt/source/:nosubdir
    http://ftp.ntua.gr/pub/X11/Qt/qt/source/:nosubdir
    http://releases.qt-project.org/qt4/source/:nosubdir
    http://ftp.iasi.roedu.net/mirrors/ftp.trolltech.com/qt/source/:nosubdir
    ftp://ftp.trolltech.com/qt/source/:nosubdir
}

set portfetch::mirror_sites::sites(xcontrib) {
    http://ftp.gwdg.de/pub/x11/x.org/contrib/
    http://ftp.x.org/contrib/
    ftp://ftp.x.org/contrib/
    ftp://ftp2.x.org/contrib/
}

set portfetch::mirror_sites::sites(xfree) {
    http://mirror.aarnet.edu.au/pub/xfree86/
    ftp://ftp.esat.net/pub/X11/XFree86/
    http://ftp-stud.fht-esslingen.de/pub/Mirrors/ftp.xfree86.org/XFree86/
    http://www.gtlib.gatech.edu/pub/XFree86/
    http://ftp.gwdg.de/pub/xfree86/XFree86/
    http://www.mirrorservice.org/sites/ftp.xfree86.org/pub/XFree86/
    ftp://ftp.physics.uvt.ro/pub/XFree86/
    ftp://ftp.fit.vutbr.cz/pub/XFree86/
    ftp://ftp.xfree86.org/pub/XFree86/
}

set portfetch::mirror_sites::sites(xorg) {
    http://ftp.cica.es/mirrors/X/pub/
    ftp://ftp.cs.cuhk.edu.hk/pub/X11/
    http://xorg.freedesktop.org/archive/
    http://xorg.freedesktop.org/releases/
    http://mi.mirror.garr.it/mirrors/x.org/
    http://ftp.gwdg.de/pub/x11/x.org/pub/
    ftp://ftp.is.co.za/pub/x.org/pub/
    http://www.mirrorservice.org/sites/ftp.x.org/pub/
    ftp://ftp.ntua.gr/pub/X11/X.org/
    http://x.cs.pu.edu.tw/
    ftp://ftp.sunet.se/pub/X11/ftp.x.org/
    http://mirror.switch.ch/ftp/mirror/X11/pub/
    ftp://sunsite.uio.no/pub/X11/
    http://mirror.csclub.uwaterloo.ca/x.org/
    http://ftp.nara.wide.ad.jp/pub/X11/x.org/
    ftp://ftp.x.org/pub/
    http://www.x.org/pub/
}
