#!/bin/sh
# $Id: gvim.sh,v 1.1 2004/07/20 18:55:50 rshaw Exp $
#
# You should be able to start Vim from the command line by typing
#
#	% gvim <arguments>
#
# Note that this will start a new instance of Vim.  As of May 2003, the
# Carbon version of Vim does not support the --remote option.
#
/Applications/DarwinPorts/Vim/Vim.app/Contents/MacOS/Vim -g "$@" &

