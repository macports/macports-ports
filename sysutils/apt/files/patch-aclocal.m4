--- aclocal.m4.orig	Fri Dec 10 17:19:05 2004
+++ aclocal.m4	Fri Dec 10 17:19:11 2004
@@ -964,12 +964,13 @@
 		GLIBC_VER=`./$dummy`
 		AC_MSG_RESULT([$GLIBC_VER])
 		ac_cv_glibc_ver=$GLIBC_VER
+		GLIBC_VER="-$ac_cv_glibc_ver"
 	else
 		AC_MSG_WARN([cannot determine GNU C library minor version number])
+		GLIBC_VER=""
 	fi
 	rm -f $dummy $dummy.c
 	)
-	GLIBC_VER="-$ac_cv_glibc_ver"
 	AC_SUBST(GLIBC_VER)
 ])
 
