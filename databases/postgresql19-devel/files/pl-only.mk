# Build and install only the procedural language directories in PL_DIRS.
# The caller sets BE_DLLLIBS to link against the installed postgres binary.

.PHONY: all install

all:
	$(MAKE) -C src/backend generated-headers
	for d in $(PL_DIRS); do $(MAKE) -C $$d all || exit 1; done

install:
	for d in $(PL_DIRS); do $(MAKE) -C $$d install || exit 1; done
