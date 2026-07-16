#!/bin/sh
rm -f .RData
@PREFIX@/bin/R -f @FRAMEWORKS_DIR@/R.framework/Resources/library/rNMR/macosx/loadrNMR.R
@PREFIX@/bin/R
