#!/bin/sh
#
# conf_setup.sh
#
# This file performs a self-repair sanity check on the tomcat configuration files.
# Any critical files that are missing will be replaced by sample files. This is 
# particularly useful in first-run situations.
#
# Note that no effort is made to ensure the validity of file contents.
#

PRG=`basename $0`

# Look for $CATALINA_BASE
if [ -z "$CATALINA_BASE" -o ! -d "$CATALINA_BASE" ]; then
	echo "$PRG: CATALINA_BASE must be set in my environment"
	exit 1
fi

# Look for $CATALINA_BASE/conf
CONF="${CATALINA_BASE}/conf"
if [ ! -d "${CONF}" ]; then
	echo "$PRG: ${CONF} directory not found!"
	exit 1
fi

# Try to repair any needed files in conf
for FILE in conf/catalina.policy conf/catalina.properties conf/server.xml conf/tomcat-users.xml conf/web.xml; do
	SAMPLE="${FILE}.sample"
	if [ ! -f "${CATALINA_BASE}/${FILE}" ]; then
		if [ ! -f "${CATALINA_BASE}/${SAMPLE}" ]; then
			echo "$PRG: file ${FILE} is missing, but no corresponding ${SAMPLE} file was found to repair it!"
		else
			echo "$PRG: file ${FILE} is missing; copying ${SAMPLE} to its place."
			cp -p "${CATALINA_BASE}/${SAMPLE}" "${CATALINA_BASE}/${FILE}"
		fi
	fi
done
