--- test/test.sh.orig	2008-11-16 12:35:40.000000000 -0800
+++ test/test.sh	2009-06-25 20:17:13.000000000 -0700
@@ -18,28 +18,28 @@
 		return
 	fi	
 
-echo -n " test-eof: "
+printf %s " test-eof: "
 if ./test-eof >/dev/null ; 
 then 
 	echo OKAY ; 
 else 
 	echo FAILED ; 
 fi
-echo -n " test-weof: "
+printf %s " test-weof: "
 if ./test-weof >/dev/null ; 
 then 
 	echo OKAY ; 
 else 
 	echo FAILED ; 
 fi
-echo -n " test-time: "
+printf %s " test-time: "
 if ./test-time >/dev/null ; 
 then 
 	echo OKAY ; 
 else 
 	echo FAILED ; 
 fi
-echo -n " regress: "
+printf %s " regress: "
 if ./regress >/dev/null ; 
 then 
 	echo OKAY ; 
