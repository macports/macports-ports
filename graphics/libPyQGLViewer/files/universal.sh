#!/bin/sh
for file in `find @@@WRKSRCPATH@@@ -name '*.pro'`; do
	cat << EOT > ${file}.tmp
QMAKE_CFLAGS_RELEASE += @@@ARCHS@@@
QMAKE_CXXFLAGS_RELEASE += @@@ARCHS@@@
QMAKE_LFLAGS_RELEASE += @@@ARCHS@@@
EOT
	cat ${file} >> ${file}.tmp
	mv ${file}.tmp ${file}
done
