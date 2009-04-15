#!/bin/sh

# clj - Clojure launcher script


cljjar='lib/clojure.jar'
cljclass='clojure.lang.Repl'
cljscript='clojure.lang.Script'

dir=$0
while [ -h "$dir" ]; do
  ls=`ls -ld "$dir"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  
  if expr "$link" : '/.*' > /dev/null; then
    dir="$link"
  else
    dir=`dirname "$dir"`"/$link"
  fi
done

dir=`dirname $dir`
dir=`cd "$dir" > /dev/null && pwd`
cljjar="$dir/../$cljjar"

if [ -z "$1" ]; then
  exec java -classpath $cljjar $cljclass
else
  scriptname=$1
  exec java -classpath $cljjar $cljscript $scriptname --$*
fi
