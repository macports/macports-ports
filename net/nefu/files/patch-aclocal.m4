===================================================================
RCS file: /usr/local/src/cvsroot/nefu/aclocal.m4,v
retrieving revision 1.12
retrieving revision 1.13
diff -u -r1.12 -r1.13
--- aclocal.m4	2002/11/21 16:34:27	1.12
+++ aclocal.m4	2003/11/20 18:34:51	1.13
@@ -11,7 +11,7 @@
     # ldapdirs will be "yes", "no", or a user defined path
     if test x_$ldapdirs != x_no; then
 	if test x_$ldapdirs = x_yes; then
-	    ldapdirs="/usr/local /usr/local/ldap /usr/local/openldap"
+	    ldapdirs="$prefix /usr /usr/local /usr/local/ldap /usr/local/openldap"
 	fi
 
 	for dir in $ldapdirs; do
@@ -31,7 +31,7 @@
 	    LDFLAGS="$LDFLAGS -L$ldapdir/lib";
 	    TEST_SRC="$TEST_SRC ldap.c"
 	    TEST_OBJ="$TEST_OBJ ldap.o"
-	    AC_DEFINE(HAVE_LDAP)
+	    AC_DEFINE([HAVE_LDAP], [], [LDAP check])
 	fi
 
     else
