all:
	cd ImageLib/src && make
	cd BlockOut && make

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/share/blockout2
	install -c -m 755 BlockOut/blockout $(DESTDIR)$(PREFIX)/bin/blockout2
	cp -R BlockOut/images $(DESTDIR)$(PREFIX)/share/blockout2
	cp -R BlockOut/sounds $(DESTDIR)$(PREFIX)/share/blockout2
