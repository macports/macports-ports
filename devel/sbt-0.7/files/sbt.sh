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

# Ensure enough heap space is created for SBT.
if [ -z "$JAVA_OPTS" ]; then
	JAVA_OPTS="-Xmx512M"
fi

# Assume java is already in the shell path.
exec java $JAVA_OPTS -jar "$LAUNCHJAR" "$@"
