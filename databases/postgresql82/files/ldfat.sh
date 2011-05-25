#!/bin/sh

# http://archives.postgresql.org/pgsql-hackers/2006-04/msg00285.php

OFILES=""
RELOPT=""
OUTPUT=""
OTHERS=""
ARCHS="@UNIVERSAL_ARCHS@"

while [ "$#" != "0" ];
do
   case "$1" in
     -r) RELOPT="-r";;
     -o) OUTPUT=`basename -s .o "$2"`; shift;;
     *.o) OFILES="$OFILES $1";;
     *) OTHERS="$OTHERS $1";;
   esac
   shift
done

if [ "$RELOPT" == "-r" ];
then
   echo ldfat $RELOPT -o $OUTPUT $OFILES $OTHERS
   THIN_OBJS=""
   for ARCH in $ARCHS; do
        /usr/bin/ld -r -arch $ARCH -o ${OUTPUT}_${ARCH}.o $OFILES $OTHERS
        THIN_OBJS+=" ${OUTPUT}_${ARCH}.o"
   done
   lipo -create -output ${OUTPUT}.o $THIN_OBJS
else
   echo ld -o $OUTPUT $OFILES $OTHERS
   /usr/bin/ld -o $OUTPUT $OFILES $OTHERS
fi
exit $?
