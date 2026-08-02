
all:: mailqmft

mailqmft:: mailqfmt.pl
	cp mailqfmt.pl mailqfmt

install:: mailqmft
	install -d ${DESTDIR}/${prefix}/bin
	install -m 755 mailqfmt ${DESTDIR}/${prefix}/bin/mailqfmt


