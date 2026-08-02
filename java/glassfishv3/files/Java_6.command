#!/bin/zsh
############################################################## {{{1 ##########
#   $Author$
#   $Revision$
#   $Date$
#   $HeadURL$
############################################################## }}}1 ##########

setopt X_Trace;

if test "${USER}" = "root"; then
    pushd "/System/Library/Frameworks/JavaVM.framework/Versions";
	if test -d "A"; then
	    rm "Current";
	    ln -s "A" "Current";   
	fi;
	if test -d "1.6"; then
	    rm "CurrentJDK";
	    ln -s "1.6" "CurrentJDK";
	fi;
    popd;
else
    sudo ${0}
fi;

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
