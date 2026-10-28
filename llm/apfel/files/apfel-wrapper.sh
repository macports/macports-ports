#!/bin/sh

set -a
source @@CONFIG_PATH@@/@@ENV_FILE@@
/usr/bin/sudo -nEu "$APFEL_USER" @@PREFIX@@/bin/@@BIN@@ --serve
