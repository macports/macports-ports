#!/bin/sh

# Attempt to set JAVA_HOME if it's not already set
if [ -z "$JAVA_HOME" ]; then
	
	# Set JAVA_HOME for Darwin
	if [ `uname -s` = "Darwin" ]; then
		
		[ -z "$JAVA_HOME" -a -d "/Library/Java/Home" ] &&
			export JAVA_HOME="/Library/Java/Home"
			
		[ -z "$JAVA_HOME" -a -d "/System/Library/Frameworks/JavaVM.framework/Home" ] &&
			export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
		
	fi
	
fi