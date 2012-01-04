#!/bin/sh
@prefix@/bin/dypgen.ml --ocamlc "-I @prefix@/lib/ocaml/site-lib/dyp" $*
