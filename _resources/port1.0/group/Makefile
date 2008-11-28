INSTALLDIR=	${DESTDIR}${prefix}/share/macports/resources/port1.0/group

RSRCS=		gnustep-1.0.tcl perl5-1.0.tcl python-1.0.tcl python24-1.0.tcl python25-1.0.tcl python30-1.0.tcl ruby-1.0.tcl \
		xcode-1.0.tcl zope-1.0.tcl

include ../../../../Mk/macports.autoconf.mk

all:

clean:

distclean:

test:
	${TCLSH} tests/ruby-1.0.tcl

install:
	$(INSTALL) -d -o ${DSTUSR} -g ${DSTGRP} -m ${DSTMODE} ${INSTALLDIR}
	$(SILENT)set -x; for file in ${RSRCS}; do \
		$(INSTALL) -o ${DSTUSR} -g ${DSTGRP} -m 444 $$file ${INSTALLDIR}; \
	done
