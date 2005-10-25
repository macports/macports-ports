all: ecm unecm

install: all
	install -d -m 755 ${prefix}/bin
	install -d -m 755 ${prefix}/share/doc/ecm
	install -m 755 ecm ${prefix}/bin/ecm
	install -m 755 unecm ${prefix}/bin/unecm
	install -m 644 format.txt ${prefix}/share/doc/ecm/
	install -m 644 gpl.txt ${prefix}/share/doc/ecm/
	install -m 644 readme.txt ${prefix}/share/doc/ecm/
