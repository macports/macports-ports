#!/bin/sh
echo ntop will start in 60s
sleep 60
__PREFIX__/bin/ntop @__PREFIX__/etc/ntop/ntop.conf -d

