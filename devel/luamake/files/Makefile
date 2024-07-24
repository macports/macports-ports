all: luamake

luamake: compile/ninja/macos.ninja
	@sed -i "" \
		-e "s|__MACPORTS_CC__|$(CC)|g" \
		-e "s|__MACPORTS_CXX__|$(CXX)|g" \
		-e "s|__MACPORTS_CPPFLAGS__|$(CPPFLAGS)|g" \
		-e "s|__MACPORTS_CFLAGS__|$(CFLAGS)|g" \
		-e "s|__MACPORTS_CXXFLAGS__|$(CXXFLAGS)|g" \
		-e "s|__MACPORTS_LDFLAGS__|$(LDFLAGS)|g" \
		$<
	@$(PREFIX)/bin/ninja -f compile/ninja/macos.ninja -v

.PHONY: all
