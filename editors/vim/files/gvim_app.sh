#!/bin/sh
# $Id: gvim_app.sh,v 1.1 2004/07/20 18:55:50 rshaw Exp $
# Script used to create GVim.app application using the Platypus
# application builder.
#
# The GVim.app included here was built using Platypus version 2.2 with
# the following settings:
# App Name: GVim
# Script Type: Shell
# Script Path: /path/to/dports/editors/vim/files/gvim_app.sh
# Output: None
# Advanced Options - Is droppable: Enabled
#
# If first arg is the application path, shift it off, not needed
case "$1" in
	*/GVim.app) shift ;;
esac
# Start Vim in GUI mode in the background
/Applications/DarwinPorts/Vim/Vim.app/Contents/MacOS/Vim -g "$@" &

