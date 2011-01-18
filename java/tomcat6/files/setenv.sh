#!/bin/sh
#
# setenv.sh
#
# You may edit this script to set defaults for such variables as JAVA_HOME.
#
# For Apple Java, the $JAVA_HOME is not well respected by the JNI launching code
# in jsvc. On Apple Java systems, you are better off setting JAVA_JVM_VERSION
# to the proper java name, such as 1.4, 1.5, or CurrentJDK, and let JAVA_HOME
# be calculated from that.
#

# First source the conf/setenv.local file to allow user to configure environment
# in an even more minimal fashion.
if [ -r "$CATALINA_HOME/conf/setenv.local" ]; then
    . "$CATALINA_HOME/conf/setenv.local"
fi

# Attempt to set JAVA_HOME if it's not already set
if [ -z "$JAVA_HOME" ]; then

    # Set JAVA_JVM_VERSION and JAVA_HOME for Darwin
    if [ `uname -s` = "Darwin" ]; then

        # Look for a java version specified by JAVA_JVM_VERSION, falling back to current version
        # Set JAVA_HOME to reflect the version
        for jversion in $JAVA_JVM_VERSION CurrentJDK ; do
            jhome="/System/Library/Frameworks/JavaVM.framework/Versions/${jversion}/Home"
            if [ -z "$JAVA_HOME" -a -d "${jhome}" ]; then
                # Get the actual version that any symlink points to, since
                # jni doesn't like JAVA_JVM_VERSION set to CurrentJDK
                saved=`pwd`
                cd "/System/Library/Frameworks/JavaVM.framework/Versions/${jversion}"
                actualvers=$(basename $(pwd -P))
                cd $saved

                export JAVA_JVM_VERSION=${actualvers}
                export JAVA_HOME=${jhome}
            fi
        done

    fi

fi
