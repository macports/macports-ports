CC = gcc
CFLAGS =
CPPFLAGS =
DESTDIR =
INSTALL = install
INSTALL_DATA = $(INSTALL) -m 644
LD = $(CC)
LDFLAGS =
LN = ln
MKDIR = mkdir
PREFIX = /usr/local

all: libglpng.a libglpng.1.dylib

libglpng.o:
	$(CC) $(CFLAGS) -I../include $(CPPFLAGS) -c -o libglpng.o glpng.c

libglpng.a: libglpng.o
	$(AR) cqs libglpng.a libglpng.o

libglpng.1.dylib: libglpng.o
	$(LD) $(LDFLAGS) -dynamiclib -install_name $(PREFIX)/lib/libglpng.1.dylib -lGL -lpng -lz -lm -o libglpng.1.dylib libglpng.o

install: all
	$(INSTALL_DATA) libglpng.1.dylib $(DESTDIR)$(PREFIX)/lib
	$(INSTALL_DATA) libglpng.a $(DESTDIR)$(PREFIX)/lib
	$(LN) -sf libglpng.1.dylib $(DESTDIR)$(PREFIX)/lib/libglpng.dylib
	$(MKDIR) $(DESTDIR)$(PREFIX)/include/GL/
	$(INSTALL_DATA) ../include/GL/glpng.h $(DESTDIR)$(PREFIX)/include/GL/
