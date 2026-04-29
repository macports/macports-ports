#!/bin/sh
exec __PREFIX__/bin/erl -smp disable -run wings_start start_halt ${1+"$@"}
