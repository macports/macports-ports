#!/bin/sh

if [ ! -d $HOME/.te ]; then
	mkdir $HOME/.te
	cp -R __PREFIX/share/thirdeye/user/* $HOME/.te
fi

__PREFIX/bin/epic -l __PREFIX/share/thirdeye/te.irc $@
