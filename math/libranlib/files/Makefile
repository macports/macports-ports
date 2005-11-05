OBJ=../linpack/linpack.o com.o ranlib.o

all: $(OBJ)
	$(CC) $(CFLAGS) -dynamiclib $(OBJ) -o libranlib-1.0.dylib -install_name $(prefix)/lib/libranlib-1.0.dylib

install: all
	install -m 644 ranlib.h $(DESTDIR)$(prefix)/include
	install -m 644 libranlib-1.0.dylib $(DESTDIR)$(prefix)/lib
	cd $(DESTDIR)$(prefix)/lib && ln -s libranlib-1.0.dylib libranlib-1.dylib
	cd $(DESTDIR)$(prefix)/lib && ln -s libranlib-1.0.dylib libranlib.dylib
	install -m 755 -d $(DESTROOT)$(prefix)/share/doc/libranlib
	install -m 644 ../README $(DESTROOT)$(prefix)/share/doc/libranlib

