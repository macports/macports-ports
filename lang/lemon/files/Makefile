#!/bin/sh
include flags
all: lemon lemoncxx
lemon: lemon.c
	$(CC) $< -o $@ -DLEMPAR=\"$(PREFIX)/share/lemon/lempar.c\" -DCSUFFIX=\".c\" -DHSUFFIX=\".h\"
lemoncxx: lemon.c
	$(CC) $< -o $@ -DLEMPAR=\"$(PREFIX)/share/lemon/lempar.cpp\" -DCSUFFIX=\".cpp\" -DHSUFFIX=\".hpp\"

