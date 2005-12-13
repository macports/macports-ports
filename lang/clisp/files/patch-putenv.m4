--- src/m4/putenv.m4	2004-11-08 09:26:41.000000000 -0500
+++ /Users/gwright/tmp/clisp/src/m4/putenv.m4	2005-12-05 19:49:58.000000000 -0500
@@ -1,5 +1,5 @@
 dnl -*- Autoconf -*-
-dnl Copyright (C) 1993-2004 Free Software Foundation, Inc.
+dnl Copyright (C) 1993-2005 Free Software Foundation, Inc.
 dnl This file is free software, distributed under the terms of the GNU
 dnl General Public License.  As a special exception to the GNU General
 dnl Public License, this file may be distributed as part of a program
@@ -19,9 +19,21 @@
 if test $ac_cv_func_putenv = yes; then
   AC_DEFINE(HAVE_PUTENV, 1, [Define if you have the putenv() function.])
 fi
-AC_CHECK_FUNCS(setenv)dnl
+AC_CHECK_FUNCS(setenv unsetenv)dnl
 AC_CHECK_DECLS(environ,,,[#include <stdlib.h>
 #ifdef HAVE_UNISTD_H
 #include <unistd.h>
 #endif])
+if test "$ac_cv_func_unsetenv" = yes; then
+  AC_MSG_CHECKING(return value of unsetenv)
+  CL_PROTO_RET([#include <stdlib.h>],[int unsetenv(char*);],[int unsetenv();],
+cl_cv_proto_unsetenv_ret,int,void)
+  AC_MSG_RESULT($cl_cv_proto_unsetenv_ret)
+  if test "$cl_cv_proto_unsetenv_ret" = int;
+  then cl_cv_proto_unsetenv_posix=1
+  else cl_cv_proto_unsetenv_posix=0
+  fi
+  AC_DEFINE_UNQUOTED(UNSETENV_POSIX,$cl_cv_proto_unsetenv_posix,
+  [define to 1 if the return type of unsetenv is int])
+fi
 ])
