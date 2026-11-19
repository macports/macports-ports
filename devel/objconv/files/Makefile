# Custom Makefile to aid universal builds

.POSIX:

SRC = $(wildcard *.cpp)

all: objconv

objconv: $(SRC)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

.PHONY: install

install:
	install -m 755 objconv $(DESTDIR)$(PREFIX)/bin/objconv
