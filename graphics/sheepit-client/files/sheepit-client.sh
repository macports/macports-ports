#!/bin/sh

JAVA_HOME=$(/usr/libexec/java_home -v @@JAVA_VERSION@@)
exec "$JAVA_HOME/bin/java" \
    -Xdock:name="SheepIt" \
    -Xdock:icon=@@ICON@@ \
    -jar @@JAR@@ "$@"
