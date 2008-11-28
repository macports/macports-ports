INSTALLDIR=	${DESTDIR}${prefix}/share/macports/resources/port1.0/fetch

RSRCS=		mirror_sites.tcl

include ../../../../Mk/macports.autoconf.mk

all:

clean:

distclean:

test:

install:
	$(INSTALL) -d -o ${DSTUSR} -g ${DSTGRP} -m ${DSTMODE} ${INSTALLDIR}
	$(SILENT)set -x; for file in ${RSRCS}; do \
		$(INSTALL) -o ${DSTUSR} -g ${DSTGRP} -m 444 $$file ${INSTALLDIR}; \
	done
