#!/bin/sh
java -classpath __LIBDIR__/aspectjtools.jar:__LIBDIR__/aspectjrt.jar -Xmx64M org.aspectj.tools.ajc.Main "$@"

