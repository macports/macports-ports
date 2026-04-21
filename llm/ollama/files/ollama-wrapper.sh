#!/bin/sh

set -a
. @@CONFIG_PATH@@/@@ENV_FILE@@
@@PREFIX@@/bin/@@BIN@@ serve
