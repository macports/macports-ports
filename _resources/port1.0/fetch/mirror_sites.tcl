# $Id$
# mirror_sites.tcl
#
# List of master site classes for use in Portfiles
# Most of these are taken shamelessly from FreeBSD.
#
# Appending :nosubdir as a tag to a mirror, means that
# the portfetch target will NOT append a subdirectory to
# the mirror site.
#
# Please keep this list sorted.

namespace eval portfetch::mirror_sites { }

set portfetch::mirror_sites::sites(afterstep) {
    ftp://ftp.kddlabs.co.jp/X11/AfterStep/
    ftp://ftp.dti.ad.jp/pub/X/AfterStep/
    ftp://ftp.afterstep.org/
}

set portfetch::mirror_sites::sites(apache) {
    http://mirrors.ibiblio.org/apache/
    http://www.gtlib.gatech.edu/pub/apache/
    http://apache.mirror.rafal.ca/
    ftp://ftp.infoscience.co.jp/pub/net/apache/dist/
    http://apache.multidist.com/
    http://mirror.internode.on.net/pub/apache/
    http://www.mirrorservice.org/sites/ftp.apache.org/
    http://mirror.aarnet.edu.au/pub/apache/
    http://apache-mirror.dkuug.dk/
    http://apache.is.co.za/
    http://mirror.facebook.net/apache/
    http://apache.pesat.net.id/
    http://www.apache.org/dist/
    http://archive.apache.org/dist/
}

# Note that mirror_sites aren't intelligent enough to handle how this should
# work automatically (which is, append first letter of port name, then
# port name) so just use a basic form here and fake it in ports that need
# to use this.
set portfetch::mirror_sites::sites(debian) {
    http://ftp.us.debian.org/debian/pool/main/:nosubdir
    http://ftp.au.debian.org/debian/pool/main/:nosubdir
    http://ftp.bg.debian.org/debian/pool/main/:nosubdir
    http://ftp.cl.debian.org/debian/pool/main/:nosubdir
    http://ftp.cz.debian.org/debian/pool/main/:nosubdir
    http://ftp.de.debian.org/debian/pool/main/:nosubdir
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
    http://ftp.wa.au.debian.org/debian/pool/main/:nosubdir
    http://ftp2.de.debian.org/debian/pool/main/:nosubdir
}

set portfetch::mirror_sites::sites(fink) {
    http://distfiles.hnd.jp.asi.finkmirrors.net/:nosubdir
    http://distfiles.ber.de.eu.finkmirrors.net/:nosubdir
    http://distfiles.hel.fi.eu.finkmirrors.net/:nosubdir
    http://distfiles.dub.ie.eu.finkmirrors.net/:nosubdir
    http://distfiles.ams.nl.eu.finkmirrors.net/:nosubdir
    http://distfiles.sjc.ca.us.finkmirrors.net/:nosubdir
    http://www.mirrorservice.org/sites/master.us.finkmirrors.net/distfiles/:nosubdir
    http://distfiles.master.finkmirrors.net/:nosubdir
}

set portfetch::mirror_sites::sites(freebsd) {
    http://ftp4.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    http://ftp4.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp5.freebsd.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp5.freebsd.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    http://ftp10.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    http://ftp10.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    http://ftp14.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    http://ftp14.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp.uk.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp.uk.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    http://www.mirrorservice.org/sites/ftp.freebsd.org/pub/FreeBSD/ports/distfiles/:nosubdir
    http://www.mirrorservice.org/sites/ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp.jp.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp.jp.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp.tw.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp.tw.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp.ru.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp.ru.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp.se.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp.se.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    http://mirror.aarnet.edu.au/pub/FreeBSD/ports/distfiles/:nosubdir
    http://mirror.aarnet.edu.au/pub/FreeBSD/ports/local-distfiles/:nosubdir
    http://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    http://ftp.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
    ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/:nosubdir
    ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/local-distfiles/:nosubdir
}

# curl -s http://www.gentoo.org/main/en/mirrors2.xml | sed -n '/(http)\|(ftp)/s/.*"\([^"]*\)".*/    \1\/distfiles\/:nosubdir/p' | sed s@//distfiles@/distfiles@g
set portfetch::mirror_sites::sites(gentoo) {
    http://gentoo.arcticnetwork.ca/distfiles/:nosubdir
    http://gentoo.mirrors.tera-byte.com/distfiles/:nosubdir
    http://mirror.mcs.anl.gov/pub/gentoo/distfiles/:nosubdir
    http://gentoo.localhost.net.ar/distfiles/:nosubdir
    http://gentoo.c3sl.ufpr.br/distfiles/:nosubdir
    http://gentoo.inode.at/distfiles/:nosubdir
    http://mirror.bih.net.ba/gentoo/distfiles/:nosubdir
    http://distfiles.gentoo.bg/distfiles/:nosubdir
    http://ftp.fi.muni.cz/pub/linux/gentoo/distfiles/:nosubdir
    http://ftp.klid.dk/ftp/gentoo/distfiles/:nosubdir
    http://trumpetti.atm.tut.fi/gentoo/distfiles/:nosubdir
    ftp://ftp.free.fr/mirrors/ftp.gentoo.org/distfiles/:nosubdir
    http://mirrors.linuxant.fr/distfiles.gentoo.org/distfiles/:nosubdir
    http://de-mirror.org/distro/gentoo/distfiles/:nosubdir
    http://files.gentoo.gr/distfiles/:nosubdir
    http://gentoo.inf.elte.hu/distfiles/:nosubdir
    http://ftp.rhnet.is/pub/gentoo/distfiles/:nosubdir
    http://ftp.heanet.ie/pub/gentoo/distfiles/:nosubdir
    http://gentoo.tups.lv/source/distfiles/:nosubdir
    http://mirror.elen.ktu.lt/gentoo/distfiles/:nosubdir
    http://mirror.cambrium.nl/pub/os/linux/gentoo/distfiles/:nosubdir
    http://gentoo.tiscali.nl/distfiles/:nosubdir
    http://mirror.gentoo.no/distfiles/:nosubdir
    http://gentoo.prz.rzeszow.pl/distfiles/:nosubdir
    http://darkstar.ist.utl.pt/gentoo/distfiles/:nosubdir
    http://mirrors.evolva.ro/gentoo/distfiles/:nosubdir
    http://gentoo-euetib.upc.es/mirror/gentoo/distfiles/:nosubdir
    http://ftp.ds.karen.hj.se/gentoo/distfiles/:nosubdir
    http://mirror.switch.ch/ftp/mirror/gentoo/distfiles/:nosubdir
    http://ftp.linux.org.tr/gentoo/distfiles/:nosubdir
    http://mirror.bytemark.co.uk/gentoo/distfiles/:nosubdir
    http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/:nosubdir
    http://gentoo.kiev.ua/ftp/distfiles/:nosubdir
    http://ftp.swin.edu.au/gentoo/distfiles/:nosubdir
    http://ftp.iij.ad.jp/pub/linux/gentoo/distfiles/:nosubdir
    http://mirror2.corbina.ru/gentoo-distfiles/distfiles/:nosubdir
    http://ftp.kaist.ac.kr/pub/gentoo/distfiles/:nosubdir
    http://ftp.ncnu.edu.tw/Linux/Gentoo/distfiles/:nosubdir
    http://gentoo.in.th/distfiles/:nosubdir
    http://mirror.isoc.org.il/pub/gentoo/distfiles/:nosubdir
    http://mirror.neolabs.kz/gentoo/pub/distfiles/:nosubdir
    http://mirror.facebook.net/gentoo/distfiles/:nosubdir
}

set portfetch::mirror_sites::sites(gimp) {
    http://ftp.gtk.org/pub/
    ftp://ftp.gtk.org/pub/
    ftp://ftp.gimp.org/pub/
    http://gimp.mirrors.hoobly.com/
    http://gimp.cp-dev.com/
    http://gimp.promotionalpromos.com/
    http://gimp.sixsigmaonline.org/
    http://www.mirrorservice.org/sites/ftp.gimp.org/pub/
    http://piotrkosoft.net/pub/mirrors/ftp.gimp.org/pub/
    ftp://gd.tuwien.ac.at/graphics/gimp/
    ftp://ftp.funet.fi/pub/sci/graphics/packages/
    http://ftp.iut-bm.univ-fcomte.fr/gimp/
    ftp://ftp.gwdg.de/pub/misc/grafik/gimp/
    http://ftp.gwdg.de/pub/misc/grafik/gimp/
    ftp://ftp.esat.net/mirrors/ftp.gimp.org/pub/
    http://ftp.esat.net/mirrors/ftp.gimp.org/pub/
    ftp://ftp.heanet.ie/mirrors/ftp.gimp.org/pub/
    http://ftp.heanet.ie/mirrors/ftp.gimp.org/pub/
    ftp://ftp.u-aizu.ac.jp/pub/graphics/tools/gimp/
    ftp://ftp.ring.gr.jp/pub/graphics/
    http://www.ring.gr.jp/pub/graphics/
    ftp://ftp.snt.utwente.nl/pub/software/gimp/
    http://ftp.snt.utwente.nl/pub/software/gimp/
    ftp://sunsite.icm.edu.pl/pub/graphics/
    ftp://ftp.sai.msu.su/pub/unix/graphics/gimp/mirror/
    http://sunsite.rediris.es/mirror/
    ftp://ftp.rediris.es/mirror/
    ftp://ftp.acc.umu.se/pub/gimp/
    ftp://ftp.sunet.se/pub/gnu/
    http://ftp.sunet.se/pub/gnu/
    ftp://ftp.is.co.za/mirror/ftp.gimp.org/
}

set portfetch::mirror_sites::sites(gnome) {
    ftp://ftp.cse.buffalo.edu/pub/Gnome/
    http://www.gtlib.gatech.edu/pub/gnome/
    http://www.mirrorservice.org/sites/ftp.gnome.org/pub/GNOME/
    http://fr2.rpmfind.net/linux/gnome.org/
    http://mirror.aarnet.edu.au/pub/gnome/
    http://ftp.unina.it/pub/linux/GNOME/
    http://ftp.acc.umu.se/pub/GNOME/
    http://ftp.belnet.be/mirror/ftp.gnome.org/
    http://ftp.nara.wide.ad.jp/pub/X11/GNOME/
    ftp://ftp.dit.upm.es/pub/GNOME/
    ftp://ftp.no.gnome.org/pub/GNOME/
    ftp://ftp.nara.wide.ad.jp/pub/X11/GNOME/
    ftp://ftp.kddlabs.co.jp/pub/GNOME/
    http://mirror.internode.on.net/pub/gnome/
    http://ftp.df.lth.se/pub/gnome/
    http://linorg.usp.br/gnome/
    http://ftp.gnome.org/pub/GNOME/
}

set portfetch::mirror_sites::sites(gnu) {
    http://mirrors.ibiblio.org/gnu/ftp/gnu/
    http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/
    http://mirror.facebook.net/gnu/gnu/
    ftp://ftp.funet.fi/pub/gnu/prep/
    ftp://ftp.kddlabs.co.jp/pub/gnu/gnu/
    ftp://ftp.kddlabs.co.jp/pub/gnu/old-gnu/
    ftp://ftp.dti.ad.jp/pub/GNU/
    ftp://ftp.informatik.hu-berlin.de/pub/gnu/gnu/
    ftp://ftp.lip6.fr/pub/gnu/
    http://mirror.internode.on.net/pub/gnu/
    http://mirror.aarnet.edu.au/pub/gnu/
    ftp://ftp.unicamp.br/pub/gnu/
    ftp://ftp.gnu.org/gnu/
    http://ftp.gnu.org/gnu/
    ftp://ftp.gnu.org/old-gnu/
}

set portfetch::mirror_sites::sites(gnupg) {
    http://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/
    ftp://gd.tuwien.ac.at/privacy/gnupg/
    http://ftp.freenet.de/pub/ftp.gnupg.org/gcrypt/
    ftp://ftp.jyu.fi/pub/crypt/gcrypt/
    http://www.ring.gr.jp/pub/net/gnupg/
    ftp://ftp.gnupg.org/gcrypt/
}

set portfetch::mirror_sites::sites(gnustep) {
    http://ftpmain.gnustep.org/pub/gnustep/
    ftp://ftp.gnustep.org/pub/gnustep/
}

set portfetch::mirror_sites::sites(googlecode) {
    http://${name}.googlecode.com/files/
}

set portfetch::mirror_sites::sites(isc) {
    http://www.mirrorservice.org/sites/ftp.isc.org/isc/
    ftp://ftp.nominum.com/pub/isc/
    http://mirrors.24-7-solutions.net/pub/isc/
    http://www.mirrorservice.org/sites/ftp.isc.org/isc/
    ftp://gd.tuwien.ac.at/infosys/servers/isc/
    http://ftp.arcane-networks.fr/pub/mirrors/ftp.isc.org/isc/
    ftp://ftp.ciril.fr/pub/isc/
    ftp://ftp.funet.fi/pub/mirrors/ftp.isc.org/isc/
    ftp://ftp.freenet.de/pub/ftp.isc.org/isc/
    ftp://ftp.fsn.hu/pub/isc/
    ftp://ftp.iij.ad.jp/pub/network/isc/
    ftp://ftp.dti.ad.jp/pub/net/isc/
    http://ftp.kaist.ac.kr/pub/isc/
    ftp://ftp.task.gda.pl/mirror/ftp.isc.org/isc/
    ftp://ftp.sunet.se/pub/network/isc/
    ftp://ftp.ripe.net/mirrors/sites/ftp.isc.org/isc/
    ftp://ftp.ntua.gr/pub/net/isc/isc/
    ftp://ftp.metu.edu.tr/pub/mirrors/ftp.isc.org/
    http://mirror.internode.on.net/pub/isc/
    ftp://ftp.isc.org/isc/
}

set portfetch::mirror_sites::sites(kde) {
    http://mirrors.mit.edu/kde/
    http://kde.mirrors.hoobly.com/
    http://ftp.gtlib.gatech.edu/pub/kde/
    http://www.mirrorservice.org/sites/ftp.kde.org/pub/kde/
    http://gd.tuwien.ac.at/kde/
    http://mirrors.isc.org/pub/kde/
    http://kde.mirrors.tds.net/pub/kde/
    ftp://ftp.solnet.ch/mirror/KDE/
    http://mirror.internode.on.net/pub/kde/
    http://mirror.aarnet.edu.au/pub/KDE/
    http://ftp.kddlabs.co.jp/pub/X11/kde/
    ftp://ftp.kde.org/pub/kde/
    http://mirror.facebook.net/kde/
}

set portfetch::mirror_sites::sites(macports) {
    http://svn.macports.org/repository/macports/distfiles/
}

set portfetch::mirror_sites::sites(macports_distfiles) {
    http://distfiles.macports.org/:mirror
    http://aarnet.au.distfiles.macports.org/pub/macports/mpdistfiles/:mirror
    http://cjj.kr.distfiles.macports.org/:mirror
    http://fco.it.distfiles.macports.org/mirrors/macports-distfiles/:mirror
    http://her.gr.distfiles.macports.org/mirrors/macports/mpdistfiles/:mirror
    http://jog.id.distfiles.macports.org/macports/mpdistfiles/:mirror
    http://lil.fr.distfiles.macports.org/:mirror
    http://mse.uk.distfiles.macports.org/sites/distfiles.macports.org/:mirror
    http://ykf.ca.distfiles.macports.org/MacPorts/mpdistfiles/:mirror
}

set portfetch::mirror_sites::sites(netbsd) {
    http://ftp7.de.NetBSD.org/pub/ftp.netbsd.org/pub/NetBSD/
    http://ftp.fr.NetBSD.org/pub/NetBSD/
    ftp://ftp7.us.NetBSD.org/pub/NetBSD/
    ftp://ftp.uk.NetBSD.org/pub/NetBSD/
    ftp://ftp.tw.NetBSD.org/pub/NetBSD/
    ftp://ftp7.jp.NetBSD.org/pub/NetBSD/
    ftp://ftp.ru.NetBSD.org/pub/NetBSD/
    http://ftp.NetBSD.org/pub/NetBSD/
}

set portfetch::mirror_sites::sites(openbsd) {
    http://www.mirrorservice.org/sites/ftp.openbsd.org/pub/OpenBSD/
    ftp://carroll.cac.psu.edu/pub/OpenBSD/
    ftp://openbsd.informatik.uni-erlangen.de/pub/OpenBSD/
    ftp://gd.tuwien.ac.at/opsys/OpenBSD/
    http://ftp.ch.openbsd.org/pub/OpenBSD/
    ftp://ftp.stacken.kth.se/pub/OpenBSD/
    ftp://ftp3.usa.openbsd.org/pub/OpenBSD/
    ftp://rt.fm/pub/OpenBSD/
    ftp://ftp.openbsd.md5.com.ar/pub/OpenBSD/
    ftp://ftp.jp.openbsd.org/pub/OpenBSD/
    http://mirror.internode.on.net/pub/OpenBSD/
    http://mirror.aarnet.edu.au/pub/OpenBSD/
    ftp://ftp.openbsd.org/pub/OpenBSD/
}

set portfetch::mirror_sites::sites(perl_cpan) {
    http://mirrors.ibiblio.org/CPAN/modules/by-module/
    http://www.mirrorservice.org/sites/ftp.cpan.org/pub/CPAN/modules/by-module/
    http://ftp.ucr.ac.cr/Unix/CPAN/modules/by-module/
    ftp://ftp.funet.fi/pub/languages/perl/CPAN/modules/by-module/
    ftp://ftp.kddlabs.co.jp/lang/perl/CPAN/modules/by-module/
    ftp://ftp.sunet.se/pub/lang/perl/CPAN/modules/by-module/
    ftp://mirror.hiwaay.net/CPAN/modules/by-module/
    ftp://ftp.auckland.ac.nz/pub/perl/CPAN/modules/by-module/
    ftp://ftp.cs.colorado.edu/pub/perl/CPAN/modules/by-module/
    ftp://ftp.is.co.za/programming/perl/modules/by-module/
    http://mirror.internode.on.net/pub/cpan/modules/by-module/
    http://cpan.mirrors.ilisys.com.au/modules/by-module/
    http://mirror.aarnet.edu.au/pub/CPAN/modules/by-module/
    http://mirror.facebook.net/cpan/modules/by-module/
    ftp://ftp.cpan.org/pub/CPAN/modules/by-module/
    http://backpan.perl.org/modules/by-module/
}

# http://php.net/mirrors.php
set portfetch::mirror_sites::sites(php) {
    http://at2.php.net/distributions/:nosubdir
    http://au.php.net/distributions/:nosubdir
    http://ch2.php.net/distributions/:nosubdir
    http://cn2.php.net/distributions/:nosubdir
    http://de3.php.net/distributions/:nosubdir
    http://es.php.net/distributions/:nosubdir
    http://fr2.php.net/distributions/:nosubdir
    http://id.php.net/distributions/:nosubdir
    http://ie.php.net/distributions/:nosubdir
    http://in.php.net/distributions/:nosubdir
    http://jp2.php.net/distributions/:nosubdir
    http://nl.php.net/distributions/:nosubdir
    http://no2.php.net/distributions/:nosubdir
    http://se2.php.net/distributions/:nosubdir
    http://tw2.php.net/distributions/:nosubdir
    http://uk.php.net/distributions/:nosubdir
    http://us2.php.net/distributions/:nosubdir
    http://us3.php.net/distributions/:nosubdir
}

set portfetch::mirror_sites::sites(postgresql) {
    http://ftp.postgresql.org/pub/
    http://www.mirrorservice.org/sites/ftp.postgresql.org/
    http://ftp7.de.postgresql.org/ftp.postgresql.org/
    ftp://ftp2.ch.postgresql.org/pub/mirrors/postgresql
    ftp://ftp.de.postgresql.org/mirror/postgresql/
    ftp://ftp.fr.postgresql.org/
    http://mirror.aarnet.edu.au/pub/postgresql/
    ftp://ftp2.au.postgresql.org/pub/postgresql/
    ftp://ftp.ru.postgresql.org/pub/unix/database/pgsql/
    ftp://ftp.postgresql.org/pub/
}

set portfetch::mirror_sites::sites(ruby) {
    http://mirrors.ibiblio.org/ruby/
    http://www.mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby/
    ftp://xyz.lcs.mit.edu/pub/ruby/
    ftp://ftp.iij.ad.jp/pub/lang/ruby/
    ftp://ftp.fu-berlin.de/unix/languages/ruby/
    ftp://ftp.easynet.be/ruby/ruby/
    ftp://ftp.ntua.gr/pub/lang/ruby/
    ftp://ftp.iDaemons.org/pub/mirror/ftp.ruby-lang.org/ruby/
    http://ftp.ruby-lang.org/pub/ruby/
    ftp://ftp.ruby-lang.org/pub/ruby/
}

set portfetch::mirror_sites::sites(savannah) {
    http://download.savannah.gnu.org/releases-noredirect/
    http://ftp.cc.uoc.gr/mirrors/nongnu.org/
    http://ftp.twaren.net/Unix/NonGNU/
    ftp://ftp.twaren.net/Unix/NonGNU/
    http://mirror.csclub.uwaterloo.ca/nongnu/
    ftp://mirror.csclub.uwaterloo.ca/nongnu/
    http://mirrors.openfountain.cl/savannah/
    http://mirrors.zerg.biz/nongnu/
    http://savannah.c3sl.ufpr.br/
    ftp://savannah.c3sl.ufpr.br/savannah-nongnu/
    http://www.de-mirrors.de/nongnu/
}
# Alias nongnu to savannah
set portfetch::mirror_sites::sites(nongnu) $portfetch::mirror_sites::sites(savannah)

# http://sourceforge.net/apps/trac/sourceforge/wiki/Mirrors
set portfetch::mirror_sites::sites(sourceforge) {
    http://aarnet.dl.sourceforge.net/
    http://citylan.dl.sourceforge.net/
    http://freefr.dl.sourceforge.net/
    http://garr.dl.sourceforge.net/
    http://heanet.dl.sourceforge.net/
    http://ignum.dl.sourceforge.net/
    http://internode.dl.sourceforge.net/
    http://iweb.dl.sourceforge.net/
    http://jaist.dl.sourceforge.net/
    http://nchc.dl.sourceforge.net/
    http://netcologne.dl.sourceforge.net/
    http://space.dl.sourceforge.net/
    http://superb-dca2.dl.sourceforge.net/
    http://superb-dca3.dl.sourceforge.net/
    http://switch.dl.sourceforge.net/
    http://tenet.dl.sourceforge.net/
    http://ufpr.dl.sourceforge.net/
    http://voxel.dl.sourceforge.net/
    http://waix.dl.sourceforge.net/
}

set portfetch::mirror_sites::sites(sourceforge_jp) {
    http://iij.dl.sourceforge.jp/
    http://osdn.dl.sourceforge.jp/
    http://jaist.dl.sourceforge.jp/
    http://keihanna.dl.sourceforge.jp/
    http://globalbase.dl.sourceforge.jp/
}

set portfetch::mirror_sites::sites(sunsite) {
    http://www.ibiblio.org/pub/Linux/
    http://www.gtlib.gatech.edu/pub/Linux/
    ftp://sunsite.unc.edu/pub/Linux/
    ftp://ftp.unicamp.br/pub/systems/Linux/
    ftp://ftp.tuwien.ac.at/pub/linux/ibiblio/
    ftp://ftp.cs.tu-berlin.de/pub/linux/Mirrors/sunsite.unc.edu/
    ftp://ftp.lip6.fr/pub/linux/sunsite/
    http://ftp.nluug.nl/pub/sunsite/
    ftp://ftp.nvg.ntnu.no/pub/mirrors/metalab.unc.edu/
    ftp://ftp.icm.edu.pl/vol/rzm1/linux-ibiblio/
    ftp://ftp.cse.cuhk.edu.hk/pub4/Linux/
    ftp://ftp.kddlabs.co.jp/Linux/metalab.unc.edu/
}

set portfetch::mirror_sites::sites(tcltk) {
    http://www.mirrorservice.org/sites/ftp.tcl.tk/pub/tcl/
    ftp://mirror.switch.ch/mirror/tcl.tk/
    ftp://ftp.informatik.uni-hamburg.de/pub/soft/lang/tcl/
    ftp://ftp.funet.fi/pub/languages/tcl/tcl/
    ftp://ftp.kddlabs.co.jp/lang/tcl/ftp.scriptics.com/
    http://www.etsimo.uniovi.es/pub/mirrors/ftp.scriptics.com/
    ftp://ftp.tcl.tk/pub/tcl/
}

set portfetch::mirror_sites::sites(tex_ctan) {
    http://mirrors.ibiblio.org/CTAN/
    http://ctan.math.utah.edu/ctan/tex-archive/
    ftp://ftp.funet.fi/pub/TeX/CTAN/
    http://mirror.internode.on.net/pub/ctan/
    ftp://ctan.unsw.edu.au/tex-archive/
    http://mirror.aarnet.edu.au/pub/CTAN/
    ftp://ftp.kddlabs.co.jp/CTAN/
    ftp://mirror.macomnet.net/pub/CTAN/
    http://ftp.sun.ac.za/ftp/CTAN/
    http://ftp.inf.utfsm.cl/pub/tex-archive/
    ftp://ftp.tex.ac.uk/tex-archive/
    ftp://ftp.dante.de/tex-archive/
    ftp://ctan.tug.org/tex-archive/
}

set portfetch::mirror_sites::sites(trolltech) {
    http://releases.qt-project.org/qt4/source/:nosubdir
    http://ftp.heanet.ie/mirrors/ftp.trolltech.com/pub/qt/source/:nosubdir
    ftp://ftp.informatik.hu-berlin.de/pub1/Mirrors/ftp.troll.no/QT/qt/source/:nosubdir
    http://ftp.iasi.roedu.net/mirrors/ftp.trolltech.com/qt/source/:nosubdir
    http://ftp.ntua.gr/pub/X11/Qt/qt/source/:nosubdir
    http://get.qt.nokia.com/qt/source/:nosubdir
    ftp://ftp.trolltech.com/qt/source/:nosubdir
}

set portfetch::mirror_sites::sites(xcontrib) {
    ftp://ftp.net.ohio-state.edu/pub/X11/contrib/
    http://www.mirrorservice.org/sites/ftp.x.org/contrib/
    ftp://ftp.gwdg.de/pub/x11/x.org/contrib/
    http://mirror.aarnet.edu.au/pub/X11/contrib/
    ftp://ftp2.x.org/contrib/
    ftp://ftp.x.org/contrib/
}

set portfetch::mirror_sites::sites(xfree) {
    http://www.gtlib.gatech.edu/pub/XFree86/
    http://www.mirrorservice.org/sites/ftp.xfree86.org/pub/XFree86/
    http://ftp-stud.fht-esslingen.de/pub/Mirrors/ftp.xfree86.org/XFree86/
    ftp://ftp.fit.vutbr.cz/pub/XFree86/
    ftp://ftp.gwdg.de/pub/xfree86/XFree86/
    ftp://ftp.esat.net/pub/X11/XFree86/
    ftp://ftp.physics.uvt.ro/pub/XFree86/
    http://mirror.aarnet.edu.au/pub/xfree86/
    ftp://ftp.xfree86.org/pub/XFree86/
}

set portfetch::mirror_sites::sites(xorg) {
    http://mirror.csclub.uwaterloo.ca/x.org/
    http://www.mirrorservice.org/sites/ftp.x.org/pub/
    http://mirror.switch.ch/ftp/mirror/X11/pub/
    ftp://ftp.gwdg.de/pub/x11/x.org/pub/
    http://ftp.cica.es/mirrors/X/pub/
    ftp://ftp.ntua.gr/pub/X11/X.org/
    ftp://ftp.cs.cuhk.edu.hk/pub/X11/
    http://mi.mirror.garr.it/mirrors/x.org/
    http://ftp.nara.wide.ad.jp/pub/X11/x.org/
    ftp://sunsite.uio.no/pub/X11/
    ftp://ftp.sunet.se/pub/X11/ftp.x.org/
    http://x.cs.pu.edu.tw/
    ftp://ftp.is.co.za/pub/x.org/pub/
    http://xorg.freedesktop.org/archive/
    http://xorg.freedesktop.org/releases/
    http://www.x.org/pub/
    ftp://ftp.x.org/pub/
}
