files=`port distfiles smlnj | grep '^\[' | awk '{print$2}'`

for f in $files; do
    sha256=`openssl dgst -r -sha256 $f | awk '{print$1}'`
    rmd160=`openssl dgst -r -rmd160 $f | awk '{print$1}'`
    size=`stat -f %z $f`
    printf '    %-23s %64s %40s %-7d \\\n' `basename $f` $sha256 $rmd160 $size
done
