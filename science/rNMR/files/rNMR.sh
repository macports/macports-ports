#!/bin/sh
rm -f .RData
@PREFIX@/bin/R -f @PREFIX@/lib/R/library/rNMR/macosx/loadrNMR.R
@PREFIX@/bin/R
