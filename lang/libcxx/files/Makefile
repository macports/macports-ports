all: libc++.1.dylib libc++abi.dylib

install: all
	install -d -m 755 $(DESTDIR)/usr/lib
	install -m 755 libc++abi.dylib $(DESTDIR)/usr/lib
	install -m 755 libc++.1.dylib $(DESTDIR)/usr/lib
	ln -s libc++.1.dylib $(DESTDIR)/usr/lib/libc++.dylib

$(LIBCXXABI_PATH)/lib/libc++abi.dylib: $(LIBCXXABI_PATH)/lib/buildit
	cd $(LIBCXXABI_PATH)/lib && ./buildit

$(LIBCXX_PATH)/lib/libc++.1.dylib: libc++abi.dylib
	cd $(LIBCXX_PATH)/lib && ./buildit

libc++abi.dylib: $(LIBCXXABI_PATH)/lib/libc++abi.dylib
	cp $< $@

libc++.1.dylib: $(LIBCXX_PATH)/lib/libc++.1.dylib
	cp $< $@

libc++.dylib: libc++.1.dylib
	ln -s $< $@
