# $Id$

SUBDIRS = lpsolve55 lp_solve

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	cd "$@" && c="$(CC)" prefix="$(PREFIX)" sh -x ./ccc.osx
