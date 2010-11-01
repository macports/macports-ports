# $Id$

.PHONY: all clean

all: clit/clit

clean:
	$(MAKE) clean -C lib
	$(MAKE) clean -C clit

lib/openclit.a:
	$(MAKE) -C lib

clit/clit: lib/openclit.a
	$(MAKE) -C clit
