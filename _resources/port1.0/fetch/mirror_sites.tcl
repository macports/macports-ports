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

# The link: http://www.apache.org/dyn/closer.cgi
# Maybe that one's enough, and we'll rely on their “cdn”
set portfetch::mirror_sites::sites(apache) {
    https://archive.apache.org/dist/
    http://apache.is.co.za/
    http://apache.mirrors.spacedump.net/
    https://mirror.aarnet.edu.au/pub/apache/
    http://mirror.cc.columbia.edu/pub/software/apache/
    http://mirror.facebook.net/apache/
    http://mirror.internode.on.net/pub/apache/
    http://mirrors.ibiblio.org/apache/
    https://www.mirrorservice.org/sites/ftp.apache.org/
    http://www.gtlib.gatech.edu/pub/apache/
}

# Equivalent to "perl_cpan"; neither name takes precedence over the other.
# Mirrors: https://cpan.metacpan.org/SITES.html
# Mirror status: http://mirrors.cpan.org
set portfetch::mirror_sites::sites(cpan) {
    https://cpan.metacpan.org/modules/by-module/
    https://www.cpan.org/modules/by-module/
    http://artfiles.org/cpan.org/modules/by-module/
    http://cpan-mirror.rbc.ru/pub/CPAN/modules/by-module/
    http://cpan.catalyst.net.nz/CPAN/modules/by-module/
    http://cpan.cpantesters.org/modules/by-module/
    http://cpan.cs.utah.edu/modules/by-module/
    http://cpan.cs.uu.nl/modules/by-module/
    http://cpan.dcc.uchile.cl/modules/by-module/
    http://cpan.etla.org/modules/by-module/
    http://cpan.excellmedia.net/modules/by-module/
    http://cpan.inode.at/modules/by-module/
    http://cpan.inspire.net.nz/modules/by-module/
    http://cpan.ip-connect.vn.ua/modules/by-module/
    http://cpan.llarian.net/modules/by-module/
    http://cpan.lnx.sk/modules/by-module/
    http://cpan.mines-albi.fr/modules/by-module/
    https://cpan.mirror.ac.za/modules/by-module/
    http://cpan.mirror.anlx.net/modules/by-module/
    http://cpan.mirror.ba/modules/by-module/
    http://cpan.mirror.cdnetworks.com/modules/by-module/
    http://cpan.mirror.choon.net/modules/by-module/
    https://cpan.mirror.colo-serv.net/modules/by-module/
    http://cpan.mirror.constant.com/modules/by-module/
    http://cpan.mirror.digitalpacific.com.au/modules/by-module/
    http://cpan.mirror.iphh.net/modules/by-module/
    http://cpan.mirror.rafal.ca/modules/by-module/
    http://cpan.mirror.serversaustralia.com.au/modules/by-module/
    http://cpan.mirror.triple-it.nl/modules/by-module/
    http://cpan.mirrors.hoobly.com/modules/by-module/
    http://cpan.mirrors.ionfish.org/modules/by-module/
    http://cpan.mirrors.tds.net/modules/by-module/
    http://cpan.mirrors.uk2.net/modules/by-module/
    http://cpan.mmgdesigns.com.ar/modules/by-module/
    http://cpan.nctu.edu.tw/modules/by-module/
    http://cpan.noris.de/modules/by-module/
    http://cpan.pair.com/modules/by-module/
    http://cpan.panu.it/modules/by-module/
    https://cpan.perl.pt/modules/by-module/
    http://cpan.pesat.net.id/modules/by-module/
    http://cpan.rinet.ru/modules/by-module/
    http://cpan.saix.net/modules/by-module/
    http://cpan.stu.edu.tw/modules/by-module/
    https://cpan.uib.no/modules/by-module/
    http://cpan.ulak.net.tr/modules/by-module/
    http://cpan.uni-altai.ru/modules/by-module/
    http://cpan.webdesk.ru/modules/by-module/
    https://cpan.zbr.pt/modules/by-module/
    http://download.xs4all.nl/CPAN/modules/by-module/
    http://httpupdate118.cpanel.net/CPAN/modules/by-module/
    http://httpupdate127.cpanel.net/CPAN/modules/by-module/
    http://kartolo.sby.datautama.net.id/CPAN/modules/by-module/
    https://lib.ugent.be/CPAN/modules/by-module/
    http://linorg.usp.br/CPAN/modules/by-module/
    http://mirror-hk.koddos.net/CPAN/modules/by-module/
    http://mirror.0x.sg/CPAN/modules/by-module/
    http://mirror.23media.de/cpan/modules/by-module/
    http://mirror.amberit.com.bd/CPAN/modules/by-module/
    http://mirror.as43289.net/pub/CPAN/modules/by-module/
    http://mirror.bibleonline.ru/cpan/modules/by-module/
    http://mirror.biznetgio.com/cpan/modules/by-module/
    http://mirror.bytemark.co.uk/CPAN/modules/by-module/
    http://mirror.cc.columbia.edu/pub/software/cpan/modules/by-module/
    http://mirror.cedia.org.ec/CPAN/modules/by-module/
    http://mirror.checkdomain.de/CPAN/modules/by-module/
    http://mirror.cogentco.com/pub/CPAN/modules/by-module/
    http://mirror.csclub.uwaterloo.ca/CPAN/modules/by-module/
    http://mirror.datapipe.net/CPAN/modules/by-module/
    http://mirror.de.leaseweb.net/CPAN/modules/by-module/
    http://mirror.dkm.cz/cpan/modules/by-module/
    http://mirror.downloadvn.com/cpan/modules/by-module/
    http://mirror.easyname.at/cpan/modules/by-module/
    http://mirror.funkfreundelandshut.de/cpan/modules/by-module/
    http://mirror.host.ag/CPAN/modules/by-module/
    http://mirror.ibcp.fr/pub/CPAN/modules/by-module/
    http://mirror.intergrid.com.au/cpan/modules/by-module/
    http://mirror.is.co.za/pub/cpan/modules/by-module/
    http://mirror.its.dal.ca/cpan/modules/by-module/
    https://mirror.jre655.com/CPAN/modules/by-module/
    http://mirror.koddos.net/CPAN/modules/by-module/
    http://mirror.kumi.systems/cpan/modules/by-module/
    http://mirror.liquidtelecom.com/CPAN/modules/by-module/
    http://mirror.low-orbit.net/pub/cpan/modules/by-module/
    http://mirror.lzu.edu.cn/CPAN/modules/by-module/
    http://mirror.met.hu/CPAN/modules/by-module/
    http://mirror.metrocast.net/cpan/modules/by-module/
    http://mirror.navercorp.com/CPAN/modules/by-module/
    http://mirror.nbtelecom.com.br/CPAN/modules/by-module/
    http://mirror.neostrada.nl/cpan/modules/by-module/
    http://mirror.netcologne.de/cpan/modules/by-module/
    http://mirror.nl.leaseweb.net/CPAN/modules/by-module/
    http://mirror.nyi.net/CPAN/modules/by-module/
    http://mirror.optusnet.com.au/CPAN/modules/by-module/
    http://mirror.ox.ac.uk/sites/www.cpan.org/modules/by-module/
    http://mirror.pregi.net/CPAN/modules/by-module/
    http://mirror.ps.kz/CPAN/modules/by-module/
    http://mirror.rasanegar.com/CPAN/modules/by-module/
    http://mirror.rise.ph/cpan/modules/by-module/
    http://mirror.rol.ru/CPAN/modules/by-module/
    http://mirror.sbb.rs/CPAN/modules/by-module/
    http://mirror.softaculous.com/cpan/modules/by-module/
    http://mirror.sov.uk.goscomb.net/CPAN/modules/by-module/
    http://mirror.team-cymru.org/CPAN/modules/by-module/
    http://mirror.transip.net/CPAN/modules/by-module/
    http://mirror.truenetwork.ru/CPAN/modules/by-module/
    http://mirror.ucu.ac.ug/cpan/modules/by-module/
    https://mirror.uic.edu/CPAN/modules/by-module/
    http://mirror.uoregon.edu/CPAN/modules/by-module/
    http://mirror.waia.asn.au/pub/cpan/modules/by-module/
    http://mirror.webtastix.net/CPAN/modules/by-module/
    http://mirror.yandex.ru/mirrors/cpan/modules/by-module/
    http://mirror.yer.az/CPAN/modules/by-module/
    http://mirrors.163.com/cpan/modules/by-module/
    http://mirrors.coreix.net/CPAN/modules/by-module/
    http://mirrors.dotsrc.org/cpan/modules/by-module/
    https://mirrors.gossamer-threads.com/CPAN/modules/by-module/
    http://mirrors.hostingromania.ro/cpan.org/modules/by-module/
    http://mirrors.ibiblio.org/CPAN/modules/by-module/
    https://mirrors.linux-bulgaria.org/cpan/modules/by-module/
    http://mirrors.m247.ro/CPAN/modules/by-module/
    http://mirrors.namecheap.com/CPAN/modules/by-module/
    http://mirrors.nav.ro/CPAN/modules/by-module/
    http://mirrors.neterra.net/CPAN/modules/by-module/
    http://mirrors.netix.net/CPAN/modules/by-module/
    http://mirrors.neusoft.edu.cn/cpan/modules/by-module/
    http://mirrors.nic.cz/CPAN/modules/by-module/
    http://mirrors.nxthost.com/CPAN/modules/by-module/
    http://mirrors.rit.edu/CPAN/modules/by-module/
    http://mirrors.sonic.net/cpan/modules/by-module/
    http://mirrors.syringanetworks.net/CPAN/modules/by-module/
    http://mirrors.ucr.ac.cr/CPAN/modules/by-module/
    http://mirrors.up.pt/CPAN/modules/by-module/
    http://mirrors.xservers.ro/CPAN/modules/by-module/
    https://osl.ugr.es/CPAN/modules/by-module/
    http://sunsite.icm.edu.pl/pub/CPAN/modules/by-module/
    http://tux.rainside.sk/CPAN/modules/by-module/
    http://www.cpan.org.ua/modules/by-module/
    http://www.mirrorservice.org/sites/cpan.perl.org/CPAN/modules/by-module/
    http://www.planet-elektronik.de/CPAN/modules/by-module/
}

# Equivalent to "tex_ctan"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(ctan) {
    http://ctan.math.utah.edu/ctan/tex-archive/
    https://mirror.aarnet.edu.au/pub/CTAN/
    http://mirror.cc.columbia.edu/pub/software/ctan/
    http://mirror.internode.on.net/pub/ctan/
    http://mirrors.ibiblio.org/CTAN/
    http://mirrors.mit.edu/CTAN/
    ftp://ftp.funet.fi/pub/TeX/CTAN/
    ftp://ftp.kddlabs.co.jp/CTAN/
    ftp://mirror.macomnet.net/pub/CTAN/
    ftp://xyz.csail.mit.edu/pub/CTAN/
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
    https://www.mirrorservice.org/sites/distfiles.finkmirrors.net/:nosubdir
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
    http://ftp-stud.hs-esslingen.de/pub/Mirrors/gentoo/distfiles/:nosubdir
    http://ftp.dei.uc.pt/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.fau.de/gentoo/distfiles/:nosubdir
    http://ftp.fi.muni.cz/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.free.fr/mirrors/ftp.gentoo.org/distfiles/:nosubdir
    http://ftp.halifax.rwth-aachen.de/gentoo/distfiles/:nosubdir
    http://ftp.iij.ad.jp/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.jaist.ac.jp/pub/Linux/Gentoo/distfiles/:nosubdir
    http://ftp.kaist.ac.kr/gentoo/distfiles/:nosubdir
    http://ftp.lanet.kr/pub/gentoo/distfiles/:nosubdir
    http://ftp.linux.org.tr/gentoo/distfiles/:nosubdir
    http://ftp.ntua.gr/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.rnl.tecnico.ulisboa.pt/pub/gentoo/gentoo-distfiles/distfiles/:nosubdir
    http://ftp.romnet.org/gentoo/distfiles/:nosubdir
    http://ftp.snt.utwente.nl/pub/os/linux/gentoo/distfiles/:nosubdir
    http://ftp.swin.edu.au/gentoo/distfiles/:nosubdir
    http://ftp.twaren.net/Linux/Gentoo/distfiles/:nosubdir
    http://ftp.vectranet.pl/gentoo/distfiles/:nosubdir
    http://gentoo-mirror.alexxy.name/distfiles/:nosubdir
    http://gentoo.aditsu.net:8000/distfiles/:nosubdir
    http://gentoo.bloodhost.ru/distfiles/:nosubdir
    http://gentoo.c3sl.ufpr.br/distfiles/:nosubdir
    http://gentoo.cs.utah.edu/distfiles/:nosubdir
    http://gentoo.gossamerhost.com/distfiles/:nosubdir
    http://gentoo.mirror.web4u.cz/distfiles/:nosubdir
    http://gentoo.mirrors.easynews.com/linux/gentoo/distfiles/:nosubdir
    http://gentoo.mirrors.ovh.net/gentoo-distfiles/distfiles/:nosubdir
    http://gentoo.mirrors.tds.net/gentoo/distfiles/:nosubdir
    http://gentoo.mirrors.tera-byte.com/distfiles/:nosubdir
    http://gentoo.modulix.net/gentoo/distfiles/:nosubdir
    http://gentoo.osuosl.org/distfiles/:nosubdir
    http://gentoo.ussg.indiana.edu/distfiles/:nosubdir
    http://gentoo.wheel.sk/distfiles/:nosubdir
    http://linux.rz.ruhr-uni-bochum.de/download/gentoo-mirror/distfiles/:nosubdir
    http://mirror.bytemark.co.uk/gentoo/distfiles/:nosubdir
    http://mirror.csclub.uwaterloo.ca/gentoo-distfiles/distfiles/:nosubdir
    http://mirror.dkm.cz/gentoo/distfiles/:nosubdir
    http://mirror.eu.oneandone.net/linux/distributions/gentoo/gentoo/distfiles/:nosubdir
    http://mirror.isoc.org.il/pub/gentoo/distfiles/:nosubdir
    http://mirror.kakao.com/gentoo/distfiles/:nosubdir
    http://mirror.leaseweb.com/gentoo/distfiles/:nosubdir
    http://mirror.mdfnet.se/gentoo/distfiles/:nosubdir
    http://mirror.netcologne.de/gentoo/distfiles/:nosubdir
    http://mirror.ps.kz/gentoo/pub/distfiles/:nosubdir
    http://mirror.rise.ph/gentoo/distfiles/:nosubdir
    http://mirror.sjc02.svwh.net/gentoo/distfiles/:nosubdir
    http://mirror.yandex.ru/gentoo-distfiles/distfiles/:nosubdir
    http://mirrors.163.com/gentoo/distfiles/:nosubdir
    http://mirrors.rit.edu/gentoo/distfiles/:nosubdir
    http://mirrors.soeasyto.com/distfiles.gentoo.org/distfiles/:nosubdir
    http://mirrors.tuna.tsinghua.edu.cn/gentoo/distfiles/:nosubdir
    http://mirrors.xservers.ro/gentoo/distfiles/:nosubdir
    http://tux.rainside.sk/gentoo/distfiles/:nosubdir
    http://www.gtlib.gatech.edu/pub/gentoo/distfiles/:nosubdir
    http://www.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/:nosubdir
}

set portfetch::mirror_sites::sites(gimp) {
    https://artfiles.org/gimp.org/pub/
    https://download.gimp.org/pub/
    https://ftp.acc.umu.se/pub/gimp/
    https://ftp.cc.uoc.gr/mirrors/
    https://ftp.fau.de/gimp/
    https://ftp.gwdg.de/pub/grafik/
    https://ftp.icm.edu.pl/pub/graphics/
    http://ftp.is.co.za/mirror/ftp.gimp.org/
    https://ftp.lysator.liu.se/pub/
    https://ftp.snt.utwente.nl/pub/software/gimp/
    http://gimp.mirrors.hoobly.com/pub/
    https://mirror.ibcp.fr/pub/
    http://mirror.rise.ph/
    https://mirror.umd.edu/gimp/
    https://mirrors.dotsrc.org/gimp/
    https://mirrors.syringanetworks.net/gimp/
    https://mirrors.ukfast.co.uk/sites/gimp.org/pub/
    https://sunsite.icm.edu.pl/pub/graphics/
    https://www.mirrorservice.org/sites/ftp.gimp.org/pub/
    http://www.ring.gr.jp/pub/graphics/
}

set portfetch::mirror_sites::sites(gnome) {
    http://ftp.gnome.org/pub/GNOME/
    https://www.mirrorservice.org/sites/ftp.gnome.org/pub/GNOME/
    https://fr2.rpmfind.net/linux/gnome.org/
    https://ftp.acc.umu.se/pub/GNOME/
    http://ftp.cse.buffalo.edu/pub/Gnome/
    https://ftp.fau.de/gnome/
    http://ftp.is.co.za/mirror/ftp.gnome.org/
    http://ftp.nara.wide.ad.jp/pub/X11/GNOME/
    http://ftp.rpmfind.net/linux/gnome.org/
    https://ftp1.nluug.nl/windowing/gnome/
    https://ftp2.nluug.nl/windowing/gnome/
    http://mirror.cc.columbia.edu/pub/software/gnome/
    http://mirror.internode.on.net/pub/gnome/
    https://mirror.umd.edu/gnome/
    https://mirrors.dotsrc.org/gnome/
    https://mirrors.ustc.edu.cn/gnome/
    https://muug.ca/mirror/gnome/
    http://www.gtlib.gatech.edu/pub/gnome/
    https://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.gnome.org/
    ftp://ftp.kddlabs.co.jp/pub/GNOME/
}

set portfetch::mirror_sites::sites(gnu) {
    https://artfiles.org/gnu.org/
    https://ftp.gnu.org/gnu/
    https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/
    http://mirror.cc.columbia.edu/pub/software/gnu/
    http://mirror.facebook.net/gnu/
    http://mirror.internode.on.net/pub/gnu/
    http://mirrors.ibiblio.org/gnu/ftp/gnu/
    ftp://ftp.funet.fi/pub/gnu/prep/
    ftp://ftp.gnu.org/old-gnu/
    ftp://ftp.kddlabs.co.jp/pub/gnu/gnu/
    ftp://ftp.kddlabs.co.jp/pub/gnu/old-gnu/
    ftp://ftp.lip6.fr/pub/gnu/
    ftp://ftp.unicamp.br/pub/gnu/
}

set portfetch::mirror_sites::sites(gnupg) {
    https://gnupg.org/ftp/gcrypt/
    https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/
    http://mirror.cc.columbia.edu/pub/software/gnupg/
    http://www.ring.gr.jp/pub/net/gnupg/
}

set portfetch::mirror_sites::sites(gnustep) {
    http://ftpmain.gnustep.org/pub/gnustep/
}

set portfetch::mirror_sites::sites(googlecode) {
    https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/
}

set portfetch::mirror_sites::sites(isc) {
    https://www.mirrorservice.org/sites/ftp.isc.org/isc/
    http://ftp.kaist.ac.kr/isc/
    http://mirror.internode.on.net/pub/isc/
    ftp://ftp.fsn.hu/pub/isc/
    ftp://ftp.funet.fi/pub/mirrors/ftp.isc.org/isc/
    ftp://ftp.iij.ad.jp/pub/network/isc/
    ftp://ftp.isc.org/isc/
    ftp://ftp.ntua.gr/pub/net/isc/isc/
    ftp://ftp.ripe.net/mirrors/sites/ftp.isc.org/isc/
    ftp://ftp.task.gda.pl/mirror/ftp.isc.org/isc/
}

set portfetch::mirror_sites::sites(kde) {
    https://www.mirrorservice.org/sites/ftp.kde.org/pub/kde/
    http://ftp.gtlib.gatech.edu/pub/kde/
    http://ftp.kddlabs.co.jp/pub/X11/kde/
    http://kde.mirrors.hoobly.com/
    http://kde.mirrors.tds.net/pub/kde/
    http://mirror.cc.columbia.edu/pub/software/kde/
    http://mirror.facebook.net/kde/
    http://mirror.internode.on.net/pub/kde/
    http://mirrors.mit.edu/kde/
}

set portfetch::mirror_sites::sites(macports) {
    https://svn.macports.org/repository/macports/distfiles/
}

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

set portfetch::mirror_sites::sites(macports_distfiles) [lsearch -all -glob -inline -not "
    ${fastly}://distfiles.macports.org/:mirror
    ${aarnet.au}://aarnet.au.distfiles.macports.org/pub/macports/distfiles/:mirror
    ${atl.us}://atl.us.distfiles.macports.org/:mirror
    ${cjj.kr}://cjj.kr.distfiles.macports.org/:mirror
    ${cph.dk}://cph.dk.distfiles.macports.org/:mirror
    ${ema.uk}://ema.uk.distfiles.macports.org/:mirror
    ${fco.it}://fco.it.distfiles.macports.org/:mirror
    ${fra.de}://fra.de.distfiles.macports.org/:mirror
    ${jnb.za}://jnb.za.distfiles.macports.org/distfiles/:mirror
    ${jog.id}://jog.id.distfiles.macports.org/macports/distfiles/:mirror
    ${kmq.jp}://kmq.jp.distfiles.macports.org/:mirror
    ${mse.uk}://mse.uk.distfiles.macports.org/:mirror
    ${nue.de}://nue.de.distfiles.macports.org/:mirror
    ${pek.cn}://pek.cn.distfiles.macports.org/macports/distfiles/:mirror
    ${ykf.ca}://ykf.ca.distfiles.macports.org/MacPorts/mpdistfiles/:mirror
    ${ywg.ca}://ywg.ca.distfiles.macports.org/mirror/macports/distfiles/:mirror
" {:*}]

# MySQL
# Test ports:
# $ for port in mysql{5,51,55,56} ; do echo "Port: ${port}" && curl -sI $(port distfiles ${port} | grep -v macports | grep -E "^ *(https)://"); done
set portfetch::mirror_sites::sites(mysql) {
    https://cdn.mysql.com/Downloads/:nosubdir
}

# https://www.netbsd.org/mirrors/
# CDN: http://cdn.NetBSD.org/pub/NetBSD/
set portfetch::mirror_sites::sites(netbsd) {
    http://cdn.NetBSD.org/pub/NetBSD/
    http://ftp.NetBSD.org/pub/NetBSD/
    http://ftp.fi.NetBSD.org/pub/NetBSD/
    http://ftp.fr.NetBSD.org/pub/NetBSD/
    http://mirror.isoc.org.il/pub/netbsd/
    http://mirror.planetunix.net/pub/NetBSD/
    http://netbsd.mirrors.hoobly.com/
    ftp://ftp.de.NetBSD.org/pub/NetBSD/
    ftp://ftp.dk.NetBSD.org/pub/NetBSD/
    ftp://ftp.hu.NetBSD.org/pub/NetBSD/
    ftp://ftp.kaist.ac.kr/NetBSD/
    ftp://ftp.nl.NetBSD.org/pub/NetBSD/
    ftp://ftp.tw.NetBSD.org/pub/NetBSD/
    ftp://ftp2.fr.NetBSD.org/pub/NetBSD/
    ftp://ftp2.ie.NetBSD.org/mirrors/ftp.netbsd.org/pub/NetBSD/
    ftp://ftp2.jp.NetBSD.org/pub/NetBSD/
    ftp://ftp3.de.NetBSD.org/pub/NetBSD/
    ftp://ftp4.fr.NetBSD.org/mirrors/ftp.netbsd.org/
    ftp://ftp4.jp.NetBSD.org/pub/NetBSD/
    ftp://ftp6.jp.NetBSD.org/pub/NetBSD/
    ftp://ftp7.jp.NetBSD.org/pub/NetBSD/
    ftp://mirrors.up.pt/pub/NetBSD/
}

# Equivalent to "savannah"; neither name takes precedence over the other.
# https://download-mirror.savannah.gnu.org/releases/00_MIRRORS.txt
set portfetch::mirror_sites::sites(nongnu) {
    https://bigsearcher.com/mirrors/nongnu/
    https://de.freedif.org/savannah/
    http://download-mirror.savannah.gnu.org/releases/
    http://ftp.acc.umu.se/mirror/gnu.org/savannah/
    http://ftp.cc.uoc.gr/mirrors/nongnu.org/
    http://ftp.igh.cnrs.fr/pub/nongnu/
    http://mirror.cedia.org.ec/nongnu/
    http://mirror.csclub.uwaterloo.ca/nongnu/
    http://mirror.downloadvn.com/nongnu/
    http://mirror.easyname.at/nongnu/
    https://mirror.freedif.org/GNU-Sa/
    http://mirror.kumi.systems/nongnu/
    http://mirror.marwan.ma/savannah/
    http://mirror.netcologne.de/savannah/
    http://mirror.ossplanet.net/nongnu/
    http://mirror.rackdc.com/savannah/
    http://mirror.yongbok.net/nongnu/
    https://mirrors.sarata.com/non-gnu/
    http://mirrors.up.pt/pub/nongnu/
    http://nongnu.askapache.com/
    http://nongnu.freemirror.org/nongnu/
    https://nongnu.uib.no/
    http://quantum-mirror.hu/mirrors/pub/gnusavannah/
    http://savannah-nongnu-org.ip-connect.vn.ua/
    http://savannah.c3sl.ufpr.br/
    http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/
}


# https://www.openbsd.org/ftp.html
set portfetch::mirror_sites::sites(openbsd) {
    https://cdn.openbsd.org/pub/OpenBSD/
    https://cloudflare.cdn.openbsd.org/pub/OpenBSD/
    https://artfiles.org/openbsd/
    https://ftp.bit.nl/pub/OpenBSD/
    https://ftp.cc.uoc.gr/pub/OpenBSD/
    https://ftp.eenet.ee/pub/OpenBSD/
    https://ftp.eu.openbsd.org/pub/OpenBSD/
    https://ftp.fau.de/pub/OpenBSD/
    https://ftp.fr.openbsd.org/pub/OpenBSD/
    https://ftp.fsn.hu/pub/OpenBSD/
    https://ftp.halifax.rwth-aachen.de/pub/OpenBSD/
    https://ftp.heanet.ie/pub/OpenBSD/
    https://ftp.hostserver.de/pub/OpenBSD/
    https://ftp.icm.edu.pl/pub/OpenBSD/
    http://ftp.jaist.ac.jp/pub/OpenBSD/
    http://ftp.man.poznan.pl/pub/OpenBSD/
    https://ftp.nluug.nl/pub/OpenBSD/
    https://ftp.OpenBSD.org/pub/OpenBSD/
    https://ftp.riken.jp/pub/OpenBSD/
    https://ftp.rnl.tecnico.ulisboa.pt/pub/OpenBSD/
    https://ftp.spline.de/pub/OpenBSD/
    http://ftp.uio.no/pub/OpenBSD/
    http://ftp.ulak.net.tr/OpenBSD/
    https://ftp.usa.openbsd.org/pub/OpenBSD/
    https://ftp2.eu.openbsd.org/pub/OpenBSD/
    http://ftp2.fr.openbsd.org/pub/OpenBSD/
    https://ftp4.usa.openbsd.org/pub/OpenBSD/
    http://kartolo.sby.datautama.net.id/pub/OpenBSD/
    https://mirror.aarnet.edu.au/pub/OpenBSD/
    https://mirror.bytemark.co.uk/pub/OpenBSD/
    https://mirror.csclub.uwaterloo.ca/pub/OpenBSD/
    https://mirror.esc7.net/pub/OpenBSD/
    https://mirror.exonetric.net/pub/OpenBSD/
    https://mirror.fsmg.org.nz/pub/OpenBSD/
    http://mirror.internode.on.net/pub/OpenBSD/
    https://mirror.hs-esslingen.de/pub/OpenBSD/
    https://mirror.labkom.id/pub/OpenBSD/
    https://mirror.leaseweb.com/pub/OpenBSD/
    https://mirror.linux.pizza/pub/openbsd/
    https://mirror.litnet.lt/pub/OpenBSD/
    https://mirror.one.com/pub/OpenBSD/
    http://mirror.ox.ac.uk/pub/OpenBSD/
    https://mirror.planetunix.net/pub/OpenBSD/
    http://mirror.rise.ph/pub/OpenBSD/
    https://mirror.ungleich.ch/pub/OpenBSD/
    https://mirror.vdms.com/pub/OpenBSD/
    https://mirror.yandex.ru/pub/OpenBSD/
    https://mirrors.dalenys.com/pub/OpenBSD/
    https://mirrors.dotsrc.org/pub/OpenBSD/
    https://mirrors.gigenet.com/pub/OpenBSD/
    https://mirrors.mit.edu/pub/OpenBSD/
    https://mirrors.pidginhost.com/pub/OpenBSD/
    https://mirrors.sonic.net/pub/OpenBSD/
    http://mirrors.syringanetworks.net/pub/OpenBSD/
    https://mirrors.ucr.ac.cr/pub/OpenBSD/
    https://openbsd.c3sl.ufpr.br/pub/OpenBSD/
    https://openbsd.cs.toronto.edu/pub/OpenBSD/
    https://openbsd.hk/pub/OpenBSD/
    https://openbsd.ipacct.com/pub/OpenBSD/
    https://openbsd.mirror.constant.com/pub/OpenBSD/
    https://openbsd.mirror.garr.it/OpenBSD/
    https://openbsd.mirror.netelligent.ca/pub/OpenBSD/
    https://plug-mirror.rcac.purdue.edu/pub/OpenBSD/
    http://www.ftp.ne.jp/pub/OpenBSD/
    https://www.mirrorservice.org/pub/OpenBSD/
    http://www.obsd.si/pub/OpenBSD/
    ftp://ftp.irisa.fr/pub/OpenBSD/
    ftp://ftp.kddilabs.jp/pub/OpenBSD/
    ftp://ftp.ulak.net.tr/pub/OpenBSD/
}

# https://osdn.net/docs/Mirrors
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

# PHP
set portfetch::mirror_sites::sites(php) {
    http://www.php.net/:nosubdir
}

set portfetch::mirror_sites::sites(postgresql) {
    http://ftp.postgresql.org/pub/
    https://mirror.aarnet.edu.au/pub/postgresql/
    https://www.mirrorservice.org/sites/ftp.postgresql.org/
}

# Note that mirror_sites aren't intelligent enough to handle how this should
# work automatically (which is, append first letter of port name, then
# port name) so just use a basic form here and fake it in ports that need
# to use this.
#
# files.pythonhosted.org has a redirector so you don't have to know the
# hash-based subdir in order to fetch. Requires TLS 1.2, which doesn't work
# on 10.8 and earlier.

set portfetch::mirror_sites::sites(pypi) {
    https://files.pythonhosted.org/packages/source/:nosubdir
}

set portfetch::mirror_sites::sites(ruby) {
    https://cache.ruby-lang.org/pub/ruby/
    https://mirror.cyberbits.eu/ruby/
    ftp://ftp.fu-berlin.de/unix/languages/ruby/
    ftp://ftp.iij.ad.jp/pub/lang/ruby/
    ftp://ftp.ntua.gr/pub/lang/ruby/
}

# Equivalent to "nongnu"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(savannah) \
        $portfetch::mirror_sites::sites(nongnu)

# https://sourceforge.net/p/forge/documentation/Mirrors/
set portfetch::mirror_sites::sites(sourceforge) {
    http://astuteinternet.dl.sourceforge.net/
    http://cfhcable.dl.sourceforge.net/
    http://deac-ams.dl.sourceforge.net/
    http://deac-fra.dl.sourceforge.net/
    http://deac-riga.dl.sourceforge.net/
    http://excellmedia.dl.sourceforge.net/
    http://freefr.dl.sourceforge.net/
    http://gigenet.dl.sourceforge.net/
    http://iweb.dl.sourceforge.net/
    http://jaist.dl.sourceforge.net/
    http://jztkft.dl.sourceforge.net/
    http://kumisystems.dl.sourceforge.net/
    http://liquidtelecom.dl.sourceforge.net/
    http://managedway.dl.sourceforge.net/
    http://nchc.dl.sourceforge.net/
    http://netactuate.dl.sourceforge.net/
    http://netcologne.dl.sourceforge.net/
    http://netix.dl.sourceforge.net/
    http://newcontinuum.dl.sourceforge.net/
    http://phoenixnap.dl.sourceforge.net/
    http://pilotfiber.dl.sourceforge.net/
    http://razaoinfo.dl.sourceforge.net/
    http://tenet.dl.sourceforge.net/
    http://svwh.dl.sourceforge.net/
    http://ufpr.dl.sourceforge.net/
    http://versaweb.dl.sourceforge.net/
}

set portfetch::mirror_sites::sites(sourceforge_jp) {
    http://iij.dl.sourceforge.jp/
    http://jaist.dl.sourceforge.jp/
    http://osdn.dl.sourceforge.jp/
}

set portfetch::mirror_sites::sites(sunsite) {
    http://www.gtlib.gatech.edu/pub/Linux/
    http://www.ibiblio.org/pub/Linux/
    ftp://ftp.icm.edu.pl/vol/rzm5/linux-ibiblio/
    ftp://ftp.lip6.fr/pub/linux/sunsite/
    ftp://ftp.nvg.ntnu.no/pub/mirrors/metalab.unc.edu/
}

set portfetch::mirror_sites::sites(tcltk) {
    https://www.mirrorservice.org/sites/ftp.tcl.tk/pub/tcl/
    ftp://ftp.funet.fi/pub/languages/tcl/tcl/
    ftp://ftp.kddlabs.co.jp/lang/tcl/ftp.scriptics.com/
    ftp://ftp.tcl.tk/pub/tcl/
    ftp://xyz.csail.mit.edu/pub/tcl/
}

# Equivalent to "ctan"; neither name takes precedence over the other.
set portfetch::mirror_sites::sites(tex_ctan) \
        $portfetch::mirror_sites::sites(ctan)

set portfetch::mirror_sites::sites(xorg) {
    https://www.x.org/archive/
    https://xorg.freedesktop.org/archive/
    https://xorg.freedesktop.org/releases/
    https://www.mirrorservice.org/sites/ftp.x.org/pub/
    http://ftp.gwdg.de/pub/x11/x.org/pub/
    http://ftp.nara.wide.ad.jp/pub/X11/x.org/
    http://mi.mirror.garr.it/mirrors/x.org/
    http://mirror.csclub.uwaterloo.ca/x.org/
    ftp://ftp.ntua.gr/pub/X11/X.org/
    ftp://ftp.x.org/pub/
    ftp://sunsite.uio.no/pub/X11/
}
