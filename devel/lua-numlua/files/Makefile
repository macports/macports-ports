# Makefile for numlua
# $Id$

CC ?= /usr/bin/clang
CFLAGS ?= -O2 -arch x86_64
CPPFLAGS ?= -I%%PREFIX%%/include
LDFLAGS ?= -L%%PREFIX%%/lib
DEPLOYMENT_TARGET ?= 10.5
PREFIX ?= /tmp

LUA_VERSION = 5.1
INSTALL_ROOT = $(DESTDIR)$(PREFIX)
INSTALL_INC = $(INSTALL_ROOT)/include/lua$(LUA_VERSION)
INSTALL_LUA = $(INSTALL_ROOT)/share/lua/$(LUA_VERSION)/numlua
INSTALL_LIB = $(INSTALL_ROOT)/lib/lua/$(LUA_VERSION)
TO_INC = amos.h blas.h cdflib.h lapack.h numlua.h rng.h
TO_LUA = matrix.lua seeall.lua
TO_LIB = numlua.so

OBJECTS = numlua.o complex.o fft.o msort.o lmatrix.o mt.o ranlib.o rng.o dcdflib.o ipmpar.o stat.o amos.o mathx.o

%.o : %.c
	export MACOSX_DEPLOYMENT_TARGET=$(DEPLOYMENT_TARGET); $(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

.PHONY : numlua
numlua : numlua.so

numlua.so : $(OBJECTS)
	export MACOSX_DEPLOYMENT_TARGET=$(DEPLOYMENT_TARGET); $(CC) -bundle -undefined dynamic_lookup -all_load -o numlua.so $(LDFLAGS) $(OBJECTS) -Wl,-rpath,$(PREFIX)/lib: -lhdf5 -lfftw3 -llapack -lblas

clean : 
	-rm -f $(OBJECTS) numlua.so

all : numlua

install : all
	mkdir -p "$(INSTALL_ROOT)"
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB) $(INSTALL_LUA)
	cp $(TO_INC) $(INSTALL_INC)
	cp $(TO_LIB) $(INSTALL_LIB)
	cp $(TO_LUA) $(INSTALL_LUA)

