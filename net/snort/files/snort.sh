#!/bin/sh
echo Snort will start in 60s
sleep 60
__PREFIX__/bin/snort -D -i en0 -c __PREFIX__/etc/snort/snort.conf

