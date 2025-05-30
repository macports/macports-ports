#!/bin/sh

set -a
source @@CONFIG_PATH@@/@@ENV_FILE@@
@@PREFIX@@/bin/@@BIN@@ serve
