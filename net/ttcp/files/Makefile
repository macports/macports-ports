PREFIX ?= /usr/local
DESTDIR ?=

all: ttcp

ttcp: ttcp.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

install: ttcp ttcp.1 README
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 ttcp $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 644 ttcp.1 $(DESTDIR)$(PREFIX)/share/man/man1
	install -d $(DESTDIR)$(PREFIX)/share/doc/ttcp
	install -m 644 README $(DESTDIR)$(PREFIX)/share/doc/ttcp

.PHONY: all install
