SUBDIRS = lpsolve55 lp_solve

.PHONY: all install installjava java $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	cd "$@" && prefix="$(PREFIX)" sh -x ./ccc.osx

install:
	install -m 755 -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 lp_solve/bin/*/lp_solve $(DESTDIR)$(PREFIX)/bin/
	install -m 755 -d $(DESTDIR)$(PREFIX)/lib
	install -m 755 lpsolve55/bin/*/liblpsolve55.a lpsolve55/bin/*/liblpsolve55.dylib $(DESTDIR)$(PREFIX)/lib/
	install -m 755 -d $(DESTDIR)$(PREFIX)/include/lpsolve
	install -m 644 *.h $(DESTDIR)$(PREFIX)/include/lpsolve/

java: src/c/liblpsolve55j.jnilib

# Based on the minimal build-osx script in lp_solve_5.5.2.11_java.zip
src/c/lpsolve5j.o:
	$(CXX) -fPIC -fno-common -Isrc/c -I$(PREFIX)/include/lpsolve -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin -c $(@:.o=.cpp) -o $@ $(CPPFLAGS) $(CXXFLAGS)

src/c/liblpsolve55j.jnilib: src/c/lpsolve5j.o
	$(CXX) -dynamiclib -compatibility_version 5.5.0 -current_version 5.5.0 -install_name $(PREFIX)/lib/$(notdir $@) $^ -o $@ $(CXXFLAGS) $(LDFLAGS) -lc -llpsolve55

installjava: src/c/liblpsolve55j.jnilib lib/lpsolve55j.jar
	install -m 755 -d $(DESTDIR)$(PREFIX)/lib
	install -m 755 src/c/liblpsolve55j.jnilib $(DESTDIR)$(PREFIX)/lib/
	install -m 755 -d $(DESTDIR)$(PREFIX)/share/java/lp_solve
	install -m 644 lib/lpsolve55j.jar $(DESTDIR)$(PREFIX)/share/java/lp_solve
	install -m 755 -d $(DESTDIR)$(PREFIX)/share/doc/lp_solve_java
	install -m 644 CHANGES.txt LGPL README.html $(DESTDIR)$(PREFIX)/share/doc/lp_solve_java
	cp -R docs/* $(DESTDIR)$(PREFIX)/share/doc/lp_solve_java
