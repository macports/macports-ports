#!/bin/sh

prefix=@PREFIX@

rm ${prefix}/etc/adblock2privoxy/{css,privoxy}/ab2p.*
find ${prefix}/etc/adblock2privoxy/css -type d -depth 1 -exec rm -fr {} 2>/dev/null ';'

launchctl kickstart -k system/org.macports.adblock2privoxy
