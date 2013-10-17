#!/bin/sh
for file in `find . -name '*.pro'`; do
	cat << EOT > ${file}.tmp
QMAKE_CFLAGS_RELEASE += $@
QMAKE_CXXFLAGS_RELEASE += $@
QMAKE_LFLAGS_RELEASE += $@
EOT
	cat ${file} >> ${file}.tmp
	mv ${file}.tmp ${file}
done
