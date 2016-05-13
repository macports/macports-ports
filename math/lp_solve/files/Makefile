# $Id$

SUBDIRS = lpsolve55 lp_solve

.PHONY: all install $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	cd "$@" && c="$(CC)" prefix="$(PREFIX)" sh -x ./ccc.osx

install:
	install -m 755 -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 lp_solve/bin/*/lp_solve $(DESTDIR)$(PREFIX)/bin/
	install -m 755 -d $(DESTDIR)$(PREFIX)/lib
	install -m 755 lpsolve55/bin/*/liblpsolve55.a lpsolve55/bin/*/liblpsolve55.dylib $(DESTDIR)$(PREFIX)/lib/
	install -m 755 -d $(DESTDIR)$(PREFIX)/include/lpsolve
	install -m 644 *.h $(DESTDIR)$(PREFIX)/include/lpsolve/
