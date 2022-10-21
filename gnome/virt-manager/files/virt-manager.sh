#!/bin/sh

PATH=@PREFIX@/bin:@PREFIX@/sbin:${PATH:-$(/usr/bin/getconf PATH)}
exec @PREFIX@/bin/virt-manager --no-fork "$@"
