#!/bin/zsh
############################################################## {{{1 ##########
#   $Author$
#   $Revision$
#   $Date$
#   $HeadURL$
############################################################## }}}1 ##########

setopt X_Trace;

if test "${USER}" = "root"; then
    if test -d "@PREFIX@/share/java/glassfishv3/glassfish/domains/domain1"; then
	gchown -R martin "@PREFIX@/share/java/glassfishv3/glassfish/domains/domain1"
    fi;
else
    sudo ${0} ${USER}

    if test -d "@PREFIX@/share/java/glassfishv3"; then
	typeset -x -g -U -T CLASSPATH classpath ":";
	typeset -x -g JAVA_HOME="/Library/Java/Home";

        path+="@PREFIX@/share/java/glassfishv3/bin";
    fi;
    
    asadmin start-domain domain1
fi;

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
# vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
