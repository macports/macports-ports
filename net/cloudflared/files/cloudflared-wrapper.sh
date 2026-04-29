#!/bin/sh

source @@CONFIG_PATH@@/@@ENV_FILE@@
@@PREFIX@@/bin/cloudflared proxy-dns $CLOUDFLARED_OPTS
