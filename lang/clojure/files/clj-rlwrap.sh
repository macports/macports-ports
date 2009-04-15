#!/bin/sh

# clj - Clojure launcher script

BREAK_CHARS="\(\){}[],^%$#@\"\";:''|\\"

cljjar='lib/clojure.jar'
cljclass='clojure.lang.Repl'
cljscript='clojure.lang.Script'
cljcompletions='.clj_completions'

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
cljcompletions="$dir/../$cljcompletions"

if [ $# -eq 0 ]; then
  rlwrap --remember -c -b $BREAK_CHARS -f $cljcompletions \
           java -cp $cljjar $cljclass
else
  scriptname=$1
  exec java -classpath $cljjar $cljscript $scriptname --$*
fi

