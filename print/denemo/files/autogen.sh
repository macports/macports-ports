#!/bin/sh
aclocal $ACLOCAL_FLAGS -I build -I /usr/share/aclocal && \
autoheader && \
glibtoolize --force && \
intltoolize --copy --force --automake && \
automake --add-missing --gnu && \
autoconf
