SHLIB_NAME=	tclsqlite.dylib
PREFIX?=	/opt/local
INSTALLDIR=	$(DESTDIR)/$(PREFIX)/lib

all: tclsqlite

### The following section was copied from the sqlite makefile ###

BCC = gcc -g -O2
TOP = .
# The config.h file will contain a single #define that tells us how
# many bytes are in a pointer.  This only works if a pointer is the
# same size on the host as it is on the target.  If you are cross-compiling
# to a target with a different pointer size, you'll need to manually
# configure the config.h file.
#
config.h:
	echo '#include <stdio.h>' >temp.c
	echo 'int main(){printf(' >>temp.c
	echo '"#define SQLITE_PTR_SZ %d",sizeof(char*));' >>temp.c
	echo 'exit(0);}' >>temp.c
	$(BCC) -o temp temp.c
	./temp >config.h
	echo >>config.h
	rm -f temp.c temp

sqlite.h:       $(TOP)/src/sqlite.h.in
	sed -e s/--VERS--/`cat ${TOP}/VERSION`/ \
	    -e s/--ENCODING--/$(ENCODING)/ \
		$(TOP)/src/sqlite.h.in >sqlite.h

### End copied section ###

parse.h:
	echo '' > $(TOP)/parse.h

opcodes.h:
	echo '' > $(TOP)/opcodes.h

tclsqlite: config.h sqlite.h parse.h opcodes.h
	$(CC) -dynamiclib -o tclsqlite.dylib \
		-I. \
		-L$(PREFIX)/lib/ -lsqlite \
		-ltcl \
		src/tclsqlite.c 

clean:
	rm -f $(OBJS) $(SHLIB_NAME)
	rm -f lemon lempar.c parse.* sqlite.h config.h

install:
	mkdir -p $(INSTALLDIR)
	install -m 444 $(SHLIB_NAME) $(INSTALLDIR)
