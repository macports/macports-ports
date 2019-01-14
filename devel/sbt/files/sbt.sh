#!/bin/sh
#
# Copyright (c) 2010 Jon Buffington. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Is the location of the SBT launcher JAR file.
LAUNCHJAR="__SBT_LAUNCHER_PATH__"

# Customization: this may define JAVA_OPTS.
SBTCONF=$HOME/.sbtconfig
if [ -f "$SBTCONF" ]; then
    . $SBTCONF
fi
if [ -z "$JAVA_OPTS" ]; then
    # Ensure enough heap space is created for sbt.  These settings are
    # the default settings from Typesafe's sbt wrapper.
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [ "$JAVA_VERSION" \< "1.8" ]; then
        CLASS_METADATA_OPT="MaxPermSize"
    else
        CLASS_METADATA_OPT="MaxMetaspaceSize"
    fi
    JAVA_OPTS="-XX:+CMSClassUnloadingEnabled -Xms1536m -Xmx1536m -XX:$CLASS_METADATA_OPT=384m -XX:ReservedCodeCacheSize=192m -Dfile.encoding=UTF8"
fi

# Assume java is already in the shell path.
exec java $JAVA_OPTS -jar "$LAUNCHJAR" "$@"
