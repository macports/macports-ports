#!/bin/sh
echo Snort will start in 60s
sleep 60
__PREFIX__/bin/snort -D -c __PREFIX__/etc/snort/snort.conf

