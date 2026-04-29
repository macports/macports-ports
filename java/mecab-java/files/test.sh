#!/bin/sh
java -Dfile.encoding=UTF-8 -Djava.library.path=@java_library_path@ -cp @cp@ test
