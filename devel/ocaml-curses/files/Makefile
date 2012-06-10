# $Id: Makefile.in,v 1.2 2008/11/17 16:53:36 rwmj Exp $

PACKAGE = ocaml-curses
VERSION = 1.0.3
CURSES = ncurses
CLIBS = ncurses
INCDIRS = @PREFIX@/include
LIBDIRS = @PREFIX@/lib
DEFS  = -DHAVE_CONFIG_H

RESULT = curses
SOURCES = ml_curses.c keys.ml curses.mli curses.ml

CC = @CC@
CFLAGS = -g -Wall $(DEFS)
LDFLAGS =
RANLIB = ranlib
LIBINSTALL_FILES = $(wildcard *.mli *.cmi *.cma *.cmxa *.a *.so)
OCAMLDOCFLAGS = -stars

all: byte opt

opt: ncl META
	$(RANLIB) *.a

byte: bcl META
	$(RANLIB) *.a

test: test.ml byte
	$(OCAMLC) -I . -o $@ curses.cma $<

test.opt: test.ml opt
	$(OCAMLOPT) -I . -o $@ curses.cmxa $<

META: META.in
	sed \
	  -e 's/@PACKAGE@/curses/' \
	  -e 's/@VERSION@/$(VERSION)/' \
	  -e 's/@CURSES@/$(CURSES)/' \
	  < $< > $@

doc: htdoc

include OCamlMakefile

.PHONY: doc
