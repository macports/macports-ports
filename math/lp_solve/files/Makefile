# $Id$

SUBDIRS = lpsolve55 lp_solve

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	cd "$@" && c=$(CC) sh ./ccc.osx
