#!/bin/sh

# Is the location of the PlantUML launcher JAR file.
LAUNCHJAR="__PLANTUML_LAUNCHER_PATH__"

exec java -jar "$LAUNCHJAR" "$@"

