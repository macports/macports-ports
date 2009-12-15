#!/bin/zsh
############################################################## {{{1 ##########
#   $Author$
#   $Revision$
#   $Date$
#   $HeadURL$
############################################################## }}}1 ##########

setopt X_Trace;

if test -d "@PREFIX@/share/java/derby"; then
    typeset -x -g -U -T CLASSPATH classpath ":";
    typeset -x -g DERBY_HOME="@PREFIX@/share/java/derby";
    typeset -x -g JAVA_HOME="/Library/Java/Home";

    path+="${DERBY_HOME}/bin"
    classpath+="${DERBY_HOME}/lib/derbyclient.jar";
fi;

if test ! -d ~/.derby; then
    mkdir ~/.derby
fi;

pushd ~/.derby      
    startNetworkServer
popd;

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
